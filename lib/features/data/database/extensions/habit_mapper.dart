import 'package:habit_maker/core/common/extension.dart';
import 'package:habit_maker/features/data/database/db_habit_model/db_habit_model.dart';
import 'package:habit_maker/features/data/database/extensions/activities_mapper.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';

extension HabitModeltoDb on HabitModel {
  HiveHabitModel toDbHabitModel() {
    return HiveHabitModel(
      color: color,
      isDeleted: isDeleted ?? false,
      isSynced: isSynced ?? false,
      id: id,
      title: title,
      hiveRepetition: repetition?.toHiveRepetition(),
      activities: activities
              ?.map((activities) => activities.toHiveActivities())
              .toList() ?? [],
    );
  }
}

extension DbtoHabitModel on HiveHabitModel {
  HabitModel toHabitModel() {
    return HabitModel(
      title: title,
      id: id,
      dbKey: key,
      isSynced: isSynced,
      isDeleted: isDeleted,
      color: color,
      activities:
          activities?.map((activities) => activities.toActivities()).toList(),
      repetition: hiveRepetition?.toRepetition(),
    );
  }
}

extension RepetitionToHive on Repetition {
  HiveRepetition toHiveRepetition() {
    return HiveRepetition(
      notifyTime: notifyTime,
      numberOfDays: numberOfDays,
      showNotification: showNotification ?? false,
      weekdays: weekdays?.map((day) => day.toHiveDay()).toList(),
    );
  }
}

extension HivetoRepetition on HiveRepetition {
  Repetition toRepetition() {
    return Repetition(
      showNotification: showNotification,
      numberOfDays: numberOfDays,
      notifyTime: notifyTime,
      weekdays: weekdays?.map((hiveDay) => hiveDay.toDay()).toList(),
    );
  }
}

extension ToHive on Day {
  HiveDay toHiveDay() {
    return HiveDay(
      weekday: weekday?.index,
      isSelected: isSelected ?? false,
    );
  }
}

extension HiveToDay on HiveDay {
  Day toDay() {
    return Day(
      isSelected: isSelected,
      weekday: WeekDay.values[weekday!],
    );
  }
}
