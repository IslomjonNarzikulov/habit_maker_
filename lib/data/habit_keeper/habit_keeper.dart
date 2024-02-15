import 'dart:async';
import 'package:habit_maker/models/habit_model.dart';

class HabitStateKeeper{
  var habitEvent = StreamController<bool>.broadcast();
  var habits = <HabitModel>[];
  var weekly = <HabitModel>[];
  var isLoading = false;

void updateHabits(List<HabitModel> list){
   habits=list;
    weekly= list.where((element) => element.isDeleted == false).toList();
    habitEvent.add(true);
}
  void clear() {
    habits.clear();
    weekly.clear();
    habitEvent.add(true);
  }
}