import 'package:flutter/cupertino.dart';
import 'package:habit_maker/data/habit_keeper/habit_keeper.dart';

import '../data/repository/repository.dart';
import '../models/habit_model.dart';
import '../models/log_out_state.dart';

class BaseProvider extends ChangeNotifier {
  HabitStateKeeper keeper;
  Repository habitRepository;
  LogOutState logoutState;
  var habits = <HabitModel>[];
  var weekly = <HabitModel>[];
  bool isLoggedState = false;

  BaseProvider(
    this.keeper,
    this.logoutState,
    this.habitRepository,
  ) {
    logoutState.logOutEvent.stream.listen((element) {
      if (element) {
        habitRepository.logout();
      }
    });
    loadHabits();
  }

  bool isLoadingState() {
    return keeper.isLoading;
  }

  Future<List<HabitModel>> loadHabits() async {
    await executeWithLoading(() async {
      var habitList = await habitRepository.loadHabits();
      keeper.updateHabits(habitList);
      habits = keeper.habits;
      weekly = keeper.weekly;
    });
    notifyListeners();
    return habits;
  }

  Future<T> executeWithLoading<T>(Future<T> Function() block) async {
    keeper.isLoading = true;
    notifyListeners();
    try {
      return await block();
    } finally {
      keeper.isLoading = false;
      notifyListeners();
    }
  }

  Future<List<HabitModel>> createActivities(
      HabitModel model, List<DateTime> date) async {
    return await executeWithLoading(() async {
      await habitRepository.createActivity(model, date);
      return await loadHabits();
    });
  }

  Future<List<HabitModel>> deleteActivities(
      HabitModel model, List<DateTime> date) async {
    return await executeWithLoading(() async {
     // await habitRepository.deleteActivity(model, date);
      return await loadHabits();
    });
  }
}
