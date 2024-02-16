import 'dart:async';

import 'package:habit_maker/models/habit_model.dart';
import 'package:table_calendar/table_calendar.dart';

class HabitStateKeeper {
  var habitEvent = StreamController<bool>.broadcast();
  var habits = <HabitModel>[];
  var weekly = <HabitModel>[];
  var isLoading = false;

  void updateHabits(List<HabitModel> list) {
    habits = list
        .where((element) =>
            element.isDeleted == false &&
            (element.activities ?? []).where((activity) {
              var result =
                  (isSameDay(DateTime.parse(activity.date!), DateTime.now()) &&
                      activity.isDeleted == false);
              return result;
            }).isEmpty)
        .toList();
    weekly = list.where((element) => element.isDeleted == false).toList();
    habitEvent.add(true);
  }

  void clear() {
    habits.clear();
    weekly.clear();
    habitEvent.add(true);
  }
}
