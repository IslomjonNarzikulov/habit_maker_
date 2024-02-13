import 'package:habit_maker/models/activities_model.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/models/hive_habit_model.dart';

extension HabitModeltoDb on HabitModel{
  HiveHabitModel hiveHabitModelToDb() {
    return HiveHabitModel(
      color: color,
      isDeleted: isDeleted,
      isSynced: isSynced,
      id: id,
      title: title,
    );
  }
}
extension DbtoHabitModel on HiveHabitModel{
  HabitModel habitModel() {
    return HabitModel(
        title: title,
        id: id,
        isSynced: isSynced,
        isDeleted: isDeleted,
        color: color,
        activities:
        repetition:
    );
  }
}

extension ActivitiesToHive on Activities{
  HiveActivities hiveActivities() {
    return HiveActivities(
        id: id,
        date: date,
        habitId: habitId,
        isSynced: isSynced,
        isDeleted: isDeleted
    );
  }
}

extension HivetoActivities on HiveActivities{
  Activities toActivities() {
    return Activities(
      isDeleted: isDeleted,
      isSynced: isSynced,
      id: id,
      habitId: habitId,
      date: date,

    );
  }
}

extension RepetitionToHive on Repetition{
  HiveRepetition hiveRepetition() {
    return HiveRepetition(
        weekdays: weekdays,
        notifyTime: notifyTime,
        numberOfDays: numberOfDays,
        showNotification: showNotification
    );
  }
}

extension HivetoRepetition on HiveRepetition{
  Repetition toRepetition() {
    return Repetition(
      showNotification: showNotification,
      numberOfDays: numberOfDays,
      notifyTime: notifyTime,
      weekdays: weekdays?.map((e) => e.toDay()).toList(),
    );
  }
}

extension ToHive on Day{
  HiveDay hiveDay() {
    return HiveDay(
      weekday: weekday,
      isSelected: isSelected,
    );
  }
}

extension HiveToDay on HiveDay{
  Day toDay() {
    return Day(
        isSelected: isSelected,
        weekday: weekday
    );
  }
}

