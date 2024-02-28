import 'package:flutter/cupertino.dart';
import 'package:habit_maker/features/data/network/models/network_response/log_out_state.dart';
import 'package:habit_maker/features/domain/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';
import 'package:habit_maker/features/domain/repository/habit_repository_api.dart';
import 'package:habit_maker/features/domain/repository/login_repository_api.dart';

class BaseProvider extends ChangeNotifier {
  HabitStateKeeper keeper;
  HabitRepositoryApi habitRepository;
  LoginRepositoryApi loginRepository;
  LogOutState logoutState;
  var habits = <HabitModel>[];
  var weekly = <HabitModel>[];
  bool isLoggedState = false;

  BaseProvider(
    this.loginRepository,
    this.keeper,
    this.habitRepository,
    this.logoutState,
  ) {
    logoutState.logOutEvent.stream.listen((element) {
      if (element) {
        loginRepository.logout();
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
    //sal noaniq
    keeper.isLoading = true;
    notifyListeners();
    try {
      return await block();
    } finally {
      keeper.isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createActivities(HabitModel model, List<DateTime> date) async {
    return await executeWithLoading(() async {
      await habitRepository.createActivity(model, date);
      await loadHabits();
      notifyListeners();
    });
  }

  Future<void> deleteActivities(HabitModel model, List<DateTime> date) async {
    return await executeWithLoading(() async {
      await habitRepository.deleteActivity(model, date);
      await loadHabits();
      notifyListeners();
    });
  }
}
