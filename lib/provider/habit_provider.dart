import 'package:flutter/cupertino.dart';
import 'package:habit_maker/data/repository/repository.dart';
import '../models/habit_model.dart';

class HabitProvider extends ChangeNotifier {
  List<HabitModel> habits = [];
  bool isLoading = false;
  Repository repository;

  HabitProvider(this.repository){
   loadHabits();  // bu constructor
   notifyListeners();
  }


  void createHabit(HabitModel habitModel) async {
    await repository.createHabit(habitModel);
    loadHabits();
    notifyListeners();
  }

  void loadHabits() async {
    isLoading= true;
    habits = await repository.loadHabits();
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteHabits(HabitModel item) async {
    await repository.deleteHabits(item);
    notifyListeners();
  }

  Future<void> updateHabits(String id, HabitModel model) async {
    await repository.updateHabits(id, model);
    loadHabits();
    notifyListeners();
  }}

extension StatusParsing on int {
  bool isSuccessFull() {
    var res = this >= 200 && this < 300;
    return res;
  }
}
