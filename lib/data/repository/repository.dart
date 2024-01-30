import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/data/database/db_helper.dart';
import 'package:habit_maker/domain/activity_extention/activity_extention.dart';
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
      await networkClient.createHabit(habitModel, token);
    } else {
      await dbHelper.insertHabit(habitModel);
    }
    if (habitModel.repetition!.numberOfDays == 0) {
      habitModel.repetition?.numberOfDays == 7;
    }
  }

  Future<List<HabitModel>> loadHabits() async {
    return await executeTask(logged: (token) async {
      var habits = await networkClient.loadHabits(token);
      var data = await dbHelper.insertAllHabits(habits);
      return data;
    }, notLogged: (e) async {
      return await dbHelper.getHabitList();
    });
  }

  Future<void> createActivity(HabitModel item, DateTime date) async {
    await executeTask(logged: (token) async {
      await networkClient.createActivities(
          item.id!, date.toIso8601String(), token);
    }, notLogged: (e) async {
      await dbHelper.insertActivities(item, date);
    });
  }

  Future<void> deleteActivity(HabitModel model, DateTime date) async {
    await executeTask(logged: (token) async {
      var activityId = model.activities!.getTheSameDay(date)?.id;
      if (activityId == null) return;
      await networkClient.deleteActivities(activityId, token);
    }, notLogged: (e) async {
      if (model.activities?.isEmpty == true) return;
      var activity = model.activities!.getTheSameDay(date);
      if (activity == null) return;
      model.activities!.getTheSameDay(date)!.isDeleted = true;
      model.activities!.getTheSameDay(date)!.isSynced = false;
      await dbHelper.updateHabit(model);
    });
  }

  Future<void> deleteHabits(HabitModel model) async {
    executeTask(logged: (token) async {
      await networkClient.deleteHabits(model.id!, token);
    }, notLogged: (e) async {
      var databaseList = await dbHelper.getHabitList();
      var item =
          databaseList.firstWhere((element) => element.dbId == model.dbId!);
      if (item.isDeleted == false) {
        item.isDeleted = true;
        item.isSynced = false;
        await dbHelper.updateHabit(item);
      }
    });
  }

  Future<bool> updateHabits(HabitModel item, HabitModel habitModel) async {
    executeTask(
      logged: (token) async {
        networkClient.updateHabits(item.id!, habitModel, token);
      },
      notLogged: (e) async {
        var model = HabitModel(
          dbId: item.dbId,
          title: habitModel.title,
          color: habitModel.color,
          repetition: habitModel.repetition,
          isSynced: false,
        );
        await dbHelper.updateHabit(model);
      },
    );
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

  Future<bool> signUp(
    String username,
    String password,
  ) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      var user = await networkClient.signUpResponse(username, password);
      secureStorage.write(key: accessToken, value: user!.token);
      return user != null;
    } else {
      return false;
    }
  }

  Future<bool> verify(String otp) async {
    var token = await secureStorage.read(key: accessToken);
    if (token != null && otp.isNotEmpty) {
      var user = await networkClient.verifyResponse(token, otp);
      secureStorage.write(key: accessToken, value: user!.token!.accessToken);
      secureStorage.write(key: firstName, value: user.user!.firstName);
      secureStorage.write(key: lastName, value: user.user!.lastName);
      secureStorage.write(key: email, value: user.user!.email);
      secureStorage.write(key: userId, value: user.user!.id);
      return user != null;
    }
    return false;
  }

  Future<void> refreshUserToken() async {
    var token = await secureStorage.read(key: refreshToken);
    var user = await networkClient.refreshToken(token!);
    if (user != null) {
      saveUserCredentials(user);
    }
  }

  FutureOr<T> executeTask<T>(
      {required Future<T> Function(String) logged,
      required Future<T> Function(Object?) notLogged}) async {
    try {
      var isLoggedIn = await secureStorage.read(key: isUserLogged);
      var isLogged = isLoggedIn != null ? bool.parse(isLoggedIn) : false;
      var token = await secureStorage.read(key: accessToken);
      if (isLogged && token != null) {
        return logged(token);
      } else {
        return notLogged(null);
      }
    } catch (e) {
      return notLogged(e);
    }
  }

  Future<String?> userRefreshToken() async {
    var tokenRefresh = await secureStorage.read(key: refreshToken);
    var user = await networkClient.refreshToken(tokenRefresh);
    await saveUserCredentials(user!);
    return await secureStorage.read(key: accessToken);
  }

  Future<void> saveUserCredentials(LoginResponse user) async {
    await secureStorage.write(key: accessToken, value: user.token!.accessToken);
    await secureStorage.write(
        key: refreshToken, value: user.token!.refreshToken);
    await secureStorage.write(key: firstName, value: user.user!.firstName);
    await secureStorage.write(key: lastName, value: user.user!.lastName);
    await secureStorage.write(key: email, value: user.user!.email);
    await secureStorage.write(key: userId, value: user.user!.id);
  }

  Future<bool> isLogged() async {
    var isLoggedIn = await secureStorage.read(key: isUserLogged);
    return isLoggedIn != null ? bool.parse(isLoggedIn) : false;
  }
}
