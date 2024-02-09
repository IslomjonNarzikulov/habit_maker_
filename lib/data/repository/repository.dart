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
  Timer? _debounceTimer;

  Repository(
      {required this.dbHelper,
      required this.networkClient,
      required this.secureStorage});

  Future<void> createHabits(HabitModel habitModel) async {
    await executeTask(logged: (token) async {
      if (habitModel.repetition!.numberOfDays == 0 &&
          habitModel.repetition!.weekdays!
              .any((element) => element.isSelected == false)) {
        habitModel.repetition?.numberOfDays = 7;
      }
      if (habitModel.repetition!.showNotification == false) {
        habitModel.repetition!.notifyTime = '00:00';
      }
      await networkClient.createHabit(habitModel, token);
    }, notLogged: (e) async {
      var model = HabitModel(
        title: habitModel.title,
        color: habitModel.color,
        repetition: habitModel.repetition,
        isSynced: false,
      );
      await dbHelper.insertHabit(model);
    });
  }

  Future<List<HabitModel>> loadHabits() async {
    _debounceTimer?.cancel();

    Completer<List<HabitModel>> completer = Completer<List<HabitModel>>();
    const Duration debounceDuration = Duration(milliseconds: 1000);

    _debounceTimer = Timer(debounceDuration, () async {
      try {
        List<HabitModel> result = await executeTask(
          logged: (token) async {
            var habits = await networkClient.loadHabits(token);

            return await dbHelper.insertAllHabits(habits);
          },
          notLogged: (e) async {
            return await dbHelper.getHabitList();
          },
        );

        completer.complete(result);
      } catch (error) {
        completer.completeError(error);
      }
    });

    return completer.future;
  }

  Future<void> createActivity(HabitModel item, List<DateTime> date) async {
    await executeTask(logged: (token) async {
      await Future.forEach(date, (dateTime) async {
        await networkClient.createActivities(
            item.id!, dateTime.toIso8601String(), token);
      });
    }, notLogged: (e) async {
      await dbHelper.insertActivities(item, date);
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
      await Future.forEach(date, (dateTime) {
        if (model.activities?.isEmpty == true) return;
        var activity = model.activities!.getTheSameDay(dateTime);
        if (activity == null) return;
        model.activities!.getTheSameDay(dateTime)!.isDeleted = true;
        model.activities!.getTheSameDay(dateTime)!.isSynced = false;
      });
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

  Future<bool> updateHabits(HabitModel item) async {
    executeTask(
      logged: (token) async {
        networkClient.updateHabits(item, token);
      },
      notLogged: (e) async {
        item.isSynced = false;
        await dbHelper.updateHabit(item);
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
    await dbHelper.deleteAllHabits();
  }

  Future<bool> changePassword(String emailAddress) async {
    if (emailAddress.isNotEmpty) {
      var user = await networkClient.restorePassword(emailAddress);
      return user != null;
    }
    return false;
  }
}
