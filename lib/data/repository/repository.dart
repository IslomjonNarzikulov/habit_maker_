import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/data/database/db_helper.dart';
import 'package:habit_maker/data/exception/unauthorized_exception.dart';
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
    if (token == null) return;
    try {
      await executeWithRetry(
          (token) => networkClient.createHabit(habitModel, token));
    } catch (e) {
      await dbHelper.insertHabit(habitModel);
    }
  }

  Future<List<HabitModel>> loadHabits() async {
    var token = await secureStorage.read(key: accessToken);
    if (token == null) return [];
    var list = <HabitModel>[];
    list = await executeWithRetry((token) => networkClient.loadHabits(token));
    var data = await dbHelper.insertAllHabits(list);
    return data;
  }

  Future<bool> deleteHabits(HabitModel model) async {
    var token = await secureStorage.read(key: accessToken);
    if (token == null) return false;
    await networkClient.deleteHabits(model.id!, token);
    var databaseList = await dbHelper.getHabitList();
    var item = databaseList.firstWhere((element) => element.id == model.id!);
    if (item.isDeleted == false) {
      item.isDeleted == true;
      item.isSynced == false;
      dbHelper.updateHabit(item);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateHabits(String id, HabitModel model) async {
    var token = await secureStorage.read(key: accessToken);
    if (token == null) return false;
    await networkClient.updateHabits(id, model, token);
    var databaseList = await dbHelper.getHabitList();
    var item = databaseList.firstWhere((element) => element.id == model.id!);
    if (item.isSynced == true) {
      item.isSynced = false;
      item.id = id;
      dbHelper.updateHabit(item);
      return true;
    } else {
      return false;
    }
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
    return false;
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
}
