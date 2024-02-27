import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';

abstract class HabitRepositoryApi {
  Future<void> createHabits(HabitModel habitModel, bool isDailySelected);

  Future<bool> updateHabits(HabitModel habitModel, bool isDailySelected);

  Future<List<HabitModel>> loadHabits();

  Future<void> createActivity(HabitModel model, List<DateTime> date);

  Future<void> deleteActivity(HabitModel model, List<DateTime> date);

  Future<void> deleteHabits(HabitModel model);

  Future<void> loadUnSyncedData();





}
