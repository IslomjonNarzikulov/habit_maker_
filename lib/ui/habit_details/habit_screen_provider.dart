import 'package:flutter/material.dart';
import 'package:habit_maker/arch_provider/arch_provider.dart';
import 'package:habit_maker/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/domain/activity_extention/activity_extention.dart';
import 'package:habit_maker/models/log_out_state.dart';

import '../../UI/create_habit/create_habit.dart';
import '../../data/repository/repository.dart';
import '../../models/habit_model.dart';

class HabitPage extends BaseProvider {
  var calendarDates = <DateTime>[];
  HabitModel? selectedHabit;

  HabitPage(LogOutState logOutState, Repository habitRepository,
      HabitStateKeeper keeper)
      : super(
          keeper,
          logOutState,
          habitRepository,
        );

  Future<void> deleteHabits(HabitModel model) async {
    await habitRepository.deleteHabits(model);
    await loadHabits();
    notifyListeners();
  }

  // void initSelectedHabit(HabitModel habitModel) {
  //   selectedHabit = habitModel;
  // }

  Future<void> onDaySelected(
      DateTime selectedDay, DateTime focusedDay, HabitModel model) async {
    var habits = [];
    if (selectedHabit?.dbId == null) return;
    var dates = getActivitiesDate(selectedHabit!.dbId!);
    if (dates.isDateExist(selectedDay)) {
      calendarDates.remove(selectedDay);
      notifyListeners();
      habits = await deleteActivities(selectedHabit!, selectedDay);
    } else {
      calendarDates.add(selectedDay);
      notifyListeners();
      habits = await createActivities(selectedHabit!, selectedDay);
    }
    var updatedHabit = habits
        .where((element) => element.dbId == selectedHabit!.dbId)
        .firstOrNull;
    if (updatedHabit != null) {
      initCalendarData(updatedHabit);
    }
    notifyListeners();
  }

  List<DateTime> getActivitiesDate(int dbId) {
    var result = (keeper.weekly
                .where((element) => element.dbId == dbId)
                .firstOrNull
                ?.activities
                ?.where((element) => element.isDeleted == false) ??
            [])
        .map((e) => DateTime.parse(e.date!))
        .toList();
    return result;
  }

  void initCalendarData(HabitModel model) {
    selectedHabit = model;
    if (model.dbId == null) return;
    calendarDates = getActivitiesDate(model.dbId!);
  }

  bool isDaySelected(DateTime day) {
    return calendarDates.isDateExist(day);
  }

  Future<void> navigateToUpdatePage(
      HabitModel habitModel, BuildContext context) async {
    final route = MaterialPageRoute(
      builder: (context) => CreateHabit(
        habitModel: habitModel,
      ),
    );
    Navigator.push(context, route);
  }
}
