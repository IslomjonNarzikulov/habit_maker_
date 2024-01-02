import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/common/constants.dart';
import 'package:habit_maker/data/repository/repository.dart';

import '../models/habit_model.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitModel> habits = [];
  bool isLoading = false;
  Repository repository;

  HabitProvider(this.repository, );

  Future<bool> createHabit(HabitModel habitModel) async {
    var result = await repository.createHabit(habitModel);
    loadHabits();
    return result;
  }

  void loadHabits() async {
    isLoading = true;
    habits = await repository.loadHabits();
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteHabits(String id) async {
    await repository.deleteHabits(id);
    loadHabits();
    notifyListeners();
  }

  Future<bool> updateHabits(String id, HabitModel habitModel) async {
    return repository.updateHabits(id, habitModel);
  }}

extension StatusParsing on int {
  bool isSuccessFull() {
    var res = this >= 200 && this < 300;
    return res;
  }
}
