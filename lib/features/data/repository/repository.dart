import 'dart:async';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/core/common/constants.dart';
import 'package:habit_maker/core/common/extension.dart';
import 'package:habit_maker/features/data/data_source/local/hive_database/hive.box.dart';
import 'package:habit_maker/features/data/data_source/remote/network_client.dart';
import 'package:habit_maker/features/data/models/habit_model.dart';
import 'package:habit_maker/features/data/models/login_response.dart';
import 'package:habit_maker/features/domain/activity_extention/activity_extention.dart';

class Repository {
  NetworkClient networkClient;
  FlutterSecureStorage secureStorage;
  Database database;

  Repository(
      {required this.database,
      required this.networkClient,
      required this.secureStorage});

  Future<void> createHabits(HabitModel habitModel, bool isDailySelected) async {
    if (isDailySelected) {
      if (habitModel.repetition?.weekdays
              ?.every((element) => element.isSelected == false) ??
          false) {
        habitModel.repetition?.numberOfDays = 7;
      } else {
        habitModel.repetition?.numberOfDays = 0;
      }
    } else {
      if (habitModel.repetition?.numberOfDays == 0) {
        habitModel.repetition?.numberOfDays = 7;
      }
      habitModel.repetition?.weekdays =
          defaultRepeat.map((day) => Day.copy(day)).toList();
    }
    await executeTask(logged: (token) async {
      await networkClient.createHabit(habitModel, token);
    }, notLogged: (e) async {
      habitModel.isSynced == false;
      await database.insertHabit(habitModel);
    });
  }

  Future<bool> updateHabits(HabitModel habitModel, bool isDailySelected) async {
    if (isDailySelected) {
      if (habitModel.repetition?.weekdays
              ?.every((element) => element.isSelected == false) ??
          false) {
        habitModel.repetition?.numberOfDays = 7;
      } else {
        habitModel.repetition?.numberOfDays = 0;
      }
    } else {
      if (habitModel.repetition?.numberOfDays == 0) {
        habitModel.repetition?.numberOfDays = 7;
      }
      habitModel.repetition?.weekdays =
          defaultRepeat.map((day) => Day.copy(day)).toList();
    }
    executeTask(
      logged: (token) async {
        networkClient.updateHabits(habitModel, token);
      },
      notLogged: (e) async {
        habitModel.isSynced = false;
        await database.updateHabit(habitModel);
      },
    );
    return true;
  }

  Future<List<HabitModel>> loadHabits() async {
    return await executeTask(
      logged: (token) async {
        var habits = await networkClient.loadHabits(token);
        return await database.insertAllHabits(habits);
      },
      notLogged: (e) async {
        return await database.getHabitList();
      },
    );
  }

  Future<void> createActivity(HabitModel model, List<DateTime> date) async {
    await executeTask(logged: (token) async {
      await Future.forEach(date, (dateTime) async {
        await networkClient.createActivities(
            model.id!, dateTime.toIso8601String(), token);
      });
    }, notLogged: (e) async {
      await database.createActivity(model, date);
    });
  }

  Future<void> deleteActivity(HabitModel model, List<DateTime> date) async {
    await executeTask(logged: (token) async {
      await Future.forEach(date, (dateTime) async {
        var activityId = model.activities!.getTheSameDay(dateTime)?.id;
        if (activityId == null) return;
        await networkClient.deleteActivities(activityId, token);
      });
    }, notLogged: (e) async {
      await database.deleteActivities(model, date);
    });
  }

  Future<void> deleteHabits(HabitModel model) async {
    executeTask(logged: (token) async {
      await networkClient.deleteHabits(model.id!, token);
    }, notLogged: (e) async {
      await database.deleteHabit(model);
    });
  }

  Future<bool> signIn(
    String email,
    String password,
  ) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      var user = await networkClient.login(email, password);
      saveUserCredentials(user!);
      await secureStorage.write(key: isUserLogged, value: "true");
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
      secureStorage.write(key: accessToken, value: user?.token);
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

  Future<String?> getUserFirstName() async{
    return  secureStorage.read(key: firstName);
  }

  Future<String?> getUserLastName() async{
    return  secureStorage.read(key: lastName);
  }

  Future<String?> getUserEmail() {
    return secureStorage.read(key: email);
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

  Future<void> logout() async {
    await secureStorage.deleteAll();
    await database.deleteAllHabits();
  }

  Future<bool> changePassword(String emailAddress) async {
    if (emailAddress.isNotEmpty) {
      var user = await networkClient.restorePassword(emailAddress);
      return user != null;
    }
    return false;
  }
}
