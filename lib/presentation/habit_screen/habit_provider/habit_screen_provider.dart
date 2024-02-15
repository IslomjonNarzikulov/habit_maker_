import 'dart:async';

import 'package:habit_maker/arch_provider/arch_provider.dart';
import 'package:habit_maker/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/domain/activity_extention/activity_extention.dart';
import 'package:habit_maker/models/log_out_state.dart';

import '../../../data/repository/repository.dart';
import '../../../models/habit_model.dart';

class HabitPage extends BaseProvider {
  var activityState = <Activity>[];
  var calendarDates = <DateTime>[];
  HabitModel? selectedHabit;
  var title = '';

  HabitPage(LogOutState logOutState, Repository habitRepository,
      HabitStateKeeper keeper)
      : super(
          keeper,
          logOutState,
          habitRepository,
        );

  Future<void> deleteHabits(HabitModel item) async {
    await habitRepository.deleteHabits(item);
    await loadHabits();
    notifyListeners();
  }

  void initSelectedHabit(HabitModel model) {
    calendarDates = getActivitiesDate(model.dbKey!);
    title = model.title ?? "";
    notifyListeners();
  }

  Future<void> onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (selectedHabit?.dbKey == null) return;
    if (calendarDates.isDateExist(selectedDay)) {
      calendarDates.remove(selectedDay);
      notifyListeners();
      activityState.add(Activity(selectedDay, true));
    } else {
      calendarDates.add(selectedDay);
      notifyListeners();
      activityState.add(Activity(selectedDay, false));
    }
    debounceActivityHandling();
    notifyListeners();
  }

  Timer? _debounce;

  void debounceActivityHandling() {
    if (_debounce?.isActive ?? false) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(seconds: 3), () async {
      var lastStateByDate = <String, bool>{};
      for (var activity in activityState) {
        String dateKey = activity.date.toIso8601String().split('T')[0];
        lastStateByDate[dateKey] = activity.isDeleted;
      }
      List<Activity> filteredActivities = [];
      lastStateByDate.forEach((dateKey, isDeleted) {
        Activity? lastActivity = activityState.lastWhere((activity) {
          String activityDateKey =
              activity.date.toIso8601String().split('T')[0];
          return activityDateKey == dateKey && activity.isDeleted == isDeleted;
        });
        filteredActivities.add(lastActivity);
      });

      activityState.clear();
      activityState.addAll(filteredActivities);
      var datesCreated = activityState
          .where((element) => element.isDeleted == false)
          .map((e) => e.date)
          .toList();
      await createActivities(selectedHabit!, datesCreated);
      var datesDeleted = activityState
          .where((element) => element.isDeleted == true)
          .map((e) => e.date)
          .toList();
      await deleteActivities(selectedHabit!, datesDeleted);
      activityState.clear();
      notifyListeners();
    });
  }

  List<DateTime> getActivitiesDate(int dbKey) {
    //here too some more explanation
    var result = (keeper.weekly
                .where((element) => element.dbKey == dbKey)
                .firstOrNull
                ?.activities
                ?.where((element) => element.isDeleted == false) ??
            [])
        .map((e) => DateTime.parse(e.date!))
        .toList();
    return result;
  }

  bool isDaySelected( DateTime day) {
    return calendarDates.isDateExist(day);
  }
}

class Activity {
  late DateTime date;
  late bool isDeleted;

  Activity(this.date, this.isDeleted);
}