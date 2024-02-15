import 'package:habit_maker/common/hive_extention.dart';
import 'package:habit_maker/domain/activity_extention/activity_extention.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/models/hive_habit_model.dart';
import 'package:hive/hive.dart';

class Database {
  late Box<HiveHabitModel> habitBox;

  Database(this.habitBox);

  Future<void> insertHabit(HabitModel habitModel) async {
    await habitBox.add(habitModel.toHiveHabitModel());
  }

  Future<List<HabitModel>> insertAllHabits(List<HabitModel> list) async {
    await deleteAllHabits();
    await Future.forEach(list, (element) async {
      await insertHabit(element);
    });
    return getHabitList();
  }

  Future<List<HabitModel>> getHabitList() async {
    var habits = habitBox.values.toList();
    return habits.map((e) => e.toHabitModel()).toList();
  }

  Future<void> updateHabit(HabitModel habitModel) async {
    var habits = habitBox.values.toList();
    var item = habits.firstWhere((element) => element.key == habitModel.dbKey);
    item.isDeleted = habitModel.isDeleted;
    item.isSynced = habitModel.isSynced;
    item.activities =
        habitModel.activities?.map((e) => e.toHiveActivities()).toList();
    item.hiveRepetition = habitModel.repetition?.toHiveRepetition();
    item.title = habitModel.title;
    item.id = habitModel.id;
    item.color = habitModel.color;
    item.save();
  }

  Future<void> deleteAllHabits() async {
    final List<int> habitKeys = habitBox.keys.cast<int>().toList();
    await Future.forEach(habitKeys, (key) async {
      await habitBox.delete(key);
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
    await Future.forEach(dates, (dateTime) {
      var activity = habitModel.activities?.getTheSameDay(dateTime);
      if (activity == null) {
        var test = habitModel.toHiveHabitModel();
        test.activities?.add(HiveActivities(
          date: dateTime.toIso8601String(),
        ));
        test.save();
      } else {
        var habit = habitBox.values
            .toList()
            .firstWhere((element) => element.key == habitModel.dbKey);
        habit.activities?.getTheSameDay(dateTime)?.isSynced = false;
        habit.activities?.getTheSameDay(dateTime)?.isSynced = false;
        habit.save();
      }
    });
  }
}
