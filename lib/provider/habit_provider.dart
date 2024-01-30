import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/data/repository/repository.dart';
import 'package:habit_maker/domain/activity_extention/activity_extention.dart';
import 'package:table_calendar/table_calendar.dart';

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
  var calendarDates = <DateTime>[];

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
    loadHabits();
    notifyListeners();
  }

  Future<List<HabitModel>> loadHabits() async {
    isLoading = true;
    var response = await repository.loadHabits();
    habits = response
        .where((element) =>
            element.isDeleted == false &&
            element.activities!.where((activity) {
              var result =
                  isSameDay(DateTime.parse(activity.date!), DateTime.now()) &&
                      activity.isDeleted == false;
              return result;
            }).isEmpty)
        .toList();
    weekly = response.where((element) => element.isDeleted == false).toList();
    isLoading = false;
    notifyListeners();
    return habits;
  }

  Future<void> deleteHabits(HabitModel model) async {
    await repository.deleteHabits(model);
    loadHabits();
    notifyListeners();
  }

  Future<void> updateHabits(HabitModel model, HabitModel habitModel) async {
    await repository.updateHabits(model, habitModel);
    loadHabits();
    notifyListeners();
  }

  Future<void> createActivities(HabitModel model, DateTime date) async {
    isLoading = true;
    notifyListeners();
    await repository.createActivity(model, date);
    await loadHabits();
    isLoading = false;
    notifyListeners();
  }

  Future<void> deleteActivities(HabitModel model, DateTime date) async {
    isLoading = true;
    notifyListeners();
    await repository.deleteActivity(model, date);
    await loadHabits();
    isLoading = false;
    notifyListeners();
  }

  Future<void> onDaySelected(
      DateTime selectedDay, DateTime focusedDay, HabitModel model) async {
    if (calendarDates.isDateExist(selectedDay)) {
      calendarDates.remove(selectedDay);
      notifyListeners();
      await deleteActivities(model, selectedDay);
    } else {
      calendarDates.add(selectedDay);
      notifyListeners();
      await createActivities(model, selectedDay);
    }
    var updatedHabit = (await loadHabits())
        .where((element) => element.id == model.id)
        .firstOrNull;
    if (updatedHabit != null) {
      initCalendarData(updatedHabit);
    }
    notifyListeners();
  }
  void initCalendarData(HabitModel model) {
    calendarDates.clear();
    model.activities?.where((e) => e.isDeleted == false).forEach((element) {
      calendarDates.add(DateTime.parse(element.date!));
    });
  }
  bool isDaySelected(DateTime day) {
    return calendarDates.isDateExist(day);
  }
}

