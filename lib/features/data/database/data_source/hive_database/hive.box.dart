import 'package:habit_maker/core/common/activity_extension.dart';
import 'package:habit_maker/features/data/database/db_habit_model/db_habit_model.dart';
import 'package:habit_maker/features/data/database/extensions/activities_mapper.dart';
import 'package:habit_maker/features/data/database/extensions/habit_mapper.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';
import 'package:hive/hive.dart';

class Database {
  late Box<HiveHabitModel> habitBox;

  Database(this.habitBox);

  Future<void> insertHabit(HabitModel habitModel) async {
    await habitBox.add(habitModel.toDbHabitModel());
  }

  Future<List<HabitModel>> insertAllHabits(List<HabitModel> list) async {
    await deleteAllHabits();
    await Future.forEach(list, (element) async {
      element.isSynced = true;
      await insertHabit(element);
    });
    return getHabitList();
  }

  Future<List<HabitModel>> getHabitList() async {
    var habits = habitBox.values.toList();
    print('db:${habits.length}');
    return habits.map((e) => e.toHabitModel()).toList();
  }

  Future<bool> updateHabit(HabitModel habitModel) async {
    var habits = habitBox.values.toList();
    var item = habits.firstWhere((element) => element.key == habitModel.dbKey);
    item.isDeleted = habitModel.isDeleted ?? false;
    item.isSynced = habitModel.isSynced ?? false;
    item.activities =
        habitModel.activities?.map((e) => e.toHiveActivities()).toList();
    item.hiveRepetition = habitModel.repetition?.toHiveRepetition();
    item.title = habitModel.title;
    item.id = habitModel.id;
    item.color = habitModel.color;
    item.save();
    return true;
  }

  Future<void> deleteAllHabits() async {
    final List<HiveHabitModel> habitKeys = habitBox.values.toList();
    await Future.forEach(habitKeys, (habit) async {
      if (habit.isSynced == true) {
        await habitBox.delete(habit.key);
      }
    });
  }

  Future<List<HabitModel>> loadUnSyncedData() async {
    return habitBox.values
        .toList()
        .where((element) => element.isSynced == false)
        .map((e) => e.toHabitModel())
        .toList();
  }

  Future<void> deleteCachedHabits() async {
    var habits = habitBox.values
        .toList()
        .where((element) => element.isSynced == false)
        .toList();
    await Future.forEach(habits, (habit) async {
      await habitBox.delete(habit.key);
    });
  }

  Future<void> deleteHabit(HabitModel habitModel) async {
    var habits = habitBox.values.toList();
    var item = habits.firstWhere((element) => element.key == habitModel.dbKey);
    if (item.isDeleted == false) {
      item.isDeleted = true;
      item.isSynced = false;
      item.save();
    }
  }

  Future<void> createActivity(
      HabitModel habitModel, List<DateTime> dates) async {
    try {
      await Future.forEach(dates, (dateTime) {
        var activity = habitModel.activities?.getTheSameDay(dateTime);
        if (activity == null) {
          var habits = habitBox.values.toList();
          var hiveActivity = HiveActivities(
            date: dateTime.toIso8601String(),
            isDeleted: false,
            isSynced: false,
          );
          var item = habits.firstWhere((element) =>
              element.key ==
              habitModel.dbKey); // shuni tenglashdan maqsad nima?
          if (item.activities == null) {
            item.activities = [hiveActivity];
          } else {
            item.activities?.add(hiveActivity);
          }
          item.isSynced = false;
          item.save();
        } else {
          var habit = habitBox.values
              .toList()
              .firstWhere((element) => element.key == habitModel.dbKey);
          habit.activities?.getTheSameDay(dateTime)?.isDeleted = false;
          habit.activities?.getTheSameDay(dateTime)?.isSynced = false;
          habit.isSynced = false;
          habit.save();
        }
      });
    } catch (e) {
      e.toString();
    }
  }

  Future<void> deleteActivities(
      HabitModel habitModel, List<DateTime> dates) async {
    await Future.forEach(dates, (dateTime) {
      var activity = habitModel.activities?.getTheSameDay(dateTime);
      if (activity == null) {
        return;
      } else {
        var habit = habitBox.values
            .toList()
            .firstWhere((element) => element.key == habitModel.dbKey);
        habit.activities?.getTheSameDay(dateTime)?.isDeleted = true;
        habit.activities?.getTheSameDay(dateTime)?.isSynced = false;
      }
    });
  }
}
