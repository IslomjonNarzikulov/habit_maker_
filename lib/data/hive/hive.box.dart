import 'package:habit_maker/models/hive_habit_model.dart';
import 'package:hive/hive.dart';

class Database {
  late Box<HiveHabitModel> habitBox;

  Database(this.habitBox);

  Future<void> insertHabit(HiveHabitModel hiveHabitModel) async {
    await habitBox.add(hiveHabitModel);
  }

  Future<List<HiveHabitModel>> insertAllHabits(List<HiveHabitModel>list)async{
    await deleteAllHabits();
    await Future.forEach(list, (element) async {
      await insertHabit(element);
    });
    return
  }

  Future<void> loadHabit(HiveHabitModel hiveHabitModel) async {
    var box = await habitBox.get();
  }

  Future<void> updateHabit(
      int habitIndex, HiveHabitModel hiveHabitModel) async {
    await habitBox.put(habitIndex, hiveHabitModel);
  }

  Future<void> deleteHabit(int habitIndex) async {
    await habitBox.delete(habitIndex);
  }

  Future<void> deleteAllHabits(int habitIndex) async {
    await habitBox.deleteAll();
  }
}
