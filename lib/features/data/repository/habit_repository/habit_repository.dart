import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/core/common/activity_extension.dart';
import 'package:habit_maker/core/common/constants.dart';
import 'package:habit_maker/core/common/extension.dart';
import 'package:habit_maker/features/data/database/data_source/hive_database/hive.box.dart';
import 'package:habit_maker/features/data/network/data_source/habit_network_source.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';
import 'package:habit_maker/features/domain/repository/habit_repository_api.dart';

class HabitRepository extends HabitRepositoryApi {
  HabitNetworkDataSource habitDataSource;
  FlutterSecureStorage secureStorage;
  Database database;

  HabitRepository(
      {required this.secureStorage,
      required this.habitDataSource,
      required this.database}) {
    Connectivity().onConnectivityChanged.listen((result) async {
      var isLogged = (await secureStorage.read(key: accessToken)) != null;
      if (result != ConnectivityResult.none && isLogged) {
        await loadUnSyncedData();
      }
    });
  }

  @override
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
    await executeTask(logged: () async {
      await habitDataSource.createHabits(habitModel);
    }, notLogged: (e) async {
      habitModel.isSynced = false;
      await database.insertHabit(habitModel);
    });
  }

  @override
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
    return await executeTask(
      logged: () async {
        return await habitDataSource.updateHabits(habitModel.id!, habitModel);
      },
      notLogged: (e) async {
        habitModel.isSynced = false;
       return await database.updateHabit(habitModel);
      },
    );
  }

  @override
  Future<void> initializeConnectivity() async {
    try {
      var isConnected =
          (await Connectivity().checkConnectivity()) != ConnectivityResult.none;
      var isLogged = (await secureStorage.read(key: accessToken)) != null;
      if (isConnected && isLogged) {
        await loadUnSyncedData();
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Future<void> loadUnSyncedData() async {
    try {
      var unSyncedHabits = await database.loadUnSyncedData();
      await habitDataSource.syncHabits(unSyncedHabits);
      await database.deleteCachedHabits();
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Future<List<HabitModel>> loadHabits() async {
    return await executeTask(
      logged: () async {
        var habits = await habitDataSource.loadHabits();
        return await database.insertAllHabits(habits);
      },
      notLogged: (e) async {
        return await database.getHabitList();
      },
    );
  }

  FutureOr<T> executeTask<T>(
      {required Future<T> Function() logged,
      required Future<T> Function(Object?) notLogged}) async {
    try {
      var isLoggedIn = await secureStorage.read(key: isUserLogged);
      var isLogged = isLoggedIn != null ? bool.parse(isLoggedIn) : false;
      if (isLogged) {
        return await logged();
      } else {
        return notLogged(null);
      }
    } catch (e) {
      return notLogged(e);
    }
  }

  @override
  Future<void> createActivity(HabitModel model, List<DateTime> date) async {
    await executeTask(logged: () async {
      await Future.forEach(date, (dateTime) async {
        await habitDataSource.createActivities(
            model.id!, dateTime.toIso8601String());
      });
    }, notLogged: (e) async {
      await database.createActivity(model, date);
    });
  }

  @override
  Future<void> deleteActivity(HabitModel model, List<DateTime> date) async {
    await executeTask(logged: () async {
      await Future.forEach(date, (dateTime) async {
        var activityId = model.activities!.getTheSameDay(dateTime)?.id;
        if (activityId == null) return;
        await habitDataSource.deleteActivities(activityId);
      });
    }, notLogged: (e) async {
      await database.deleteActivities(model, date);
    });
  }

  @override
  Future<void> deleteHabits(HabitModel model) async {
    executeTask(logged: () async {
      await habitDataSource.deleteHabits(model.id!);
    }, notLogged: (e) async {
      await database.deleteHabit(model);
    });
  }

  Future<void> saveInfo()async{
  }
}
