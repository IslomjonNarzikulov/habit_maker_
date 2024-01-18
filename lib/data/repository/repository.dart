import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/data/database/db_helper.dart';
import 'package:habit_maker/data/exception/unauthorized_exception.dart';
import 'package:habit_maker/models/activities_model.dart';
import 'package:habit_maker/models/login_response.dart';

import '../../common/constants.dart';
import '../../models/habit_model.dart';
import '../network_client/network_client.dart';

class Repository {
  NetworkClient networkClient;
  DBHelper dbHelper;
  FlutterSecureStorage secureStorage;

  Repository(
      {required this.dbHelper,
      required this.networkClient,
      required this.secureStorage});

  Future<void> createHabit(HabitModel habitModel) async {
    var token = await secureStorage.read(key: accessToken);
    var isLoggedIn = await secureStorage.read(key: isUserLogged);
    var isLogged = isLoggedIn != null ? bool.parse(isLoggedIn) : false;
    if (isLogged) {
      if (token == null) return;
      await executeWithRetry(
          (token) => networkClient.createHabit(habitModel, token));
    } else {
      await dbHelper.insertHabit(habitModel);
    }
    if (habitModel.repetition!.numberOfDays == 0) {
      habitModel.repetition?.numberOfDays == 7;
    }
  }

  Future<List<HabitModel>> loadHabits(bool force) async {
    var isLoggedIn = await secureStorage.read(key: isUserLogged);
    var isLogged = isLoggedIn != null ? bool.parse(isLoggedIn) : false;
    if (isLogged) {
      var habits =
          await executeWithRetry((token) => networkClient.loadHabits(token));
      var data = await dbHelper.insertAllHabits(habits);
      return data;
    } else {
      try {
        return await dbHelper.getHabitList();
      } catch (e) {
        print(e.toString());
        return [];
      }
    }
  }

  Future<void> createActivity(HabitModel item, DateTime date) async {
    var isLoggedIn = await secureStorage.read(key: isUserLogged);
    var isLogged = isLoggedIn != null ? bool.parse(isLoggedIn) : false;
    if (isLogged) {
      var token = await secureStorage.read(key: accessToken);
      if (token == null) return;
      await networkClient.createActivities(
          item.id!, date.toIso8601String(), token);
    } else {
      var model = Activities(date: date.toIso8601String(), habitId: item.dbId!);
      await dbHelper.insertActivities(model);
    }
  }

  Future<void> deleteHabits(HabitModel model) async {
    var isLoggedIn = await secureStorage.read(key: isUserLogged);
    var isLogged = isLoggedIn != null ? bool.parse(isLoggedIn) : false;
    if (isLogged) {
      var token = await secureStorage.read(key: accessToken);
      if (token == null) return;
      await networkClient.deleteHabits(model.id!, token);
    } else {
      var databaseList = await dbHelper.getHabitList();
      var item =
          databaseList.firstWhere((element) => element.dbId == model.dbId!);
      if (item.isDeleted == false) {
        item.isDeleted = true;
        item.isSynced = false;
        await dbHelper.updateHabit(item);
      }
    }
  }

  Future<bool> updateHabits(HabitModel item, HabitModel habitModel) async {
    try {
      var isLoggedIn = await secureStorage.read(key: isUserLogged);
      var isLogged = isLoggedIn != null ? bool.parse(isLoggedIn) : false;
      if (isLogged) {
        var token = await secureStorage.read(key: accessToken);
        if (token == null) return false;
        networkClient.updateHabits(item.id!, habitModel, token);
      } else {
        var model = HabitModel(
          dbId: item.dbId,
          title: habitModel.title,
          color: habitModel.color,
          repetition: habitModel.repetition,
          isSynced: false,
        );
        await dbHelper.updateHabit(model);
      }
    } catch (e) {
      e.toString();
      var model = HabitModel(
        dbId: item.dbId,
        title: habitModel.title,
        color: habitModel.color,
        repetition: habitModel.repetition,
        isSynced: false,
      );
      await dbHelper.updateHabit(model);
    }
    return true;
  }

  Future<bool> signIn(
    String email,
    String password,
  ) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      var user = await networkClient.login(email, password);
      saveUserCredentials(user!);
      return user != null;
    }
    return true;
  }

  Future<void> signUp(
    String username,
    String password,
  ) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      var user = await networkClient.signUp_response(username, password);
      secureStorage.write(key: accessToken, value: user!.token);
    }
  }

  Future<void> verify(String otp) async {
    var token = await secureStorage.read(key: accessToken);
    if (token != null && otp.isNotEmpty) {
      var user = await networkClient.verify_response(token, otp);
      if (user != null) {
        secureStorage.write(key: accessToken, value: user.token!.accessToken);
        secureStorage.write(key: refreshToken, value: user.token!.refreshToken);
        secureStorage.write(key: firstName, value: user.user!.firstName);
        secureStorage.write(key: lastName, value: user.user!.lastName);
        secureStorage.write(key: email, value: user.user!.email);
        secureStorage.write(key: userId, value: user.user!.id);
      }
    }
  }

  Future<void> refreshUserToken() async {
    var token = await secureStorage.read(key: refreshToken);
    var user = await networkClient.refreshToken(token!);
    if (user != null) {
      saveUserCredentials(user);
    }
  }

// bu xato chiqib qosa qayta tekshirishga
  Future<T> executeWithRetry<T>(Future<T> Function(String token) block) async {
    try {
      var token = await secureStorage.read(key: accessToken);
      return await block(token!);
    } catch (e) {
      if (e is UnAuthorizedException) {
        var refreshUserToken = await secureStorage.read(key: refreshToken);
        var user = await networkClient.refreshToken(refreshUserToken);
        saveUserCredentials(user!);
        var tokenNew = await secureStorage.read(key: accessToken);
        return block(tokenNew!);
      }
      rethrow;
    }
  }

  void saveUserCredentials(LoginResponse user) {
    secureStorage.write(key: accessToken, value: user.token!.accessToken);
    secureStorage.write(key: refreshToken, value: user.token!.refreshToken);
    secureStorage.write(key: firstName, value: user.user!.firstName);
    secureStorage.write(key: lastName, value: user.user!.lastName);
    secureStorage.write(key: email, value: user.user!.email);
    secureStorage.write(key: userId, value: user.user!.id);
  }

  Future<bool> isLogged() async {
    var isLoggedIn = await secureStorage.read(key: isUserLogged);
    return isLoggedIn != null ? bool.parse(isLoggedIn) : false;
  }
}
