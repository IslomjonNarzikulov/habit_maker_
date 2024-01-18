import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/data/repository/repository.dart';

import '../common/constants.dart';
import '../models/habit_model.dart';
import '../models/log_out_state.dart';

class HabitProvider extends ChangeNotifier {
  var habits = <HabitModel>[];
  var weekly = <HabitModel>[];
  bool isLoading = false;
  Repository repository;
  LogOutState logOutState;
  bool isLoggedState = false;
  FlutterSecureStorage secureStorage;

  HabitProvider(this.repository, this.logOutState, this.secureStorage) {
    logOutState.logOut.stream.listen((element) {
      if (element) {
        secureStorage.delete(key: accessToken);
        secureStorage.delete(key: isUserLogged);
        print('log out');
      }
    });
  }

  void isLoggedOut() {
    logOutState.logOut.add(true);
    notifyListeners();
  }

  void isLogged() async {
    var result = await repository.isLogged();
    isLoggedState = result;
    print(isLoggedState.toString());
  }

  void createHabit(HabitModel habitModel) async {
    await repository.createHabit(habitModel);
    loadHabits(true);
    notifyListeners();
  }

  void loadHabits(bool force) async {
    isLoading = true;
    habits = (await repository.loadHabits(force))
        .where((element) => element.isDeleted == false)
        .toList();
    weekly = habits
        .where((element) => element.repetition!.numberOfDays == 0)
        .toList();
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteHabits(HabitModel model) async {
    await repository.deleteHabits(model);
    notifyListeners();
  }

  Future<void> updateHabits(HabitModel model, HabitModel habitModel) async {
    await repository.updateHabits(model, habitModel);
    loadHabits(true);
    notifyListeners();
  }

  Future<void> createActivities(HabitModel model, DateTime date) async {
    await repository.createActivity(model, date);
    notifyListeners();
  }
}

extension StatusParsing on int {
  bool isSuccessFull() {
    var res = this >= 200 && this < 300;
    return res;
  }
}
