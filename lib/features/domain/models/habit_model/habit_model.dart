import 'package:habit_maker/core/common/extension.dart';

class HabitModel {
  String? id;
  String? title;
  Repetition? repetition;
  int? color;
  bool? isDeleted;
  bool? isSynced;
  List<Activities>? activities;
  dynamic dbKey;

  HabitModel(
      {this.id,
      this.dbKey,
      this.activities,
      this.title,
      this.repetition,
      this.color,
      this.isDeleted,
      this.isSynced});
}

class Repetition {
  int? numberOfDays;
  DateTime? notifyTime;
  bool? showNotification;
  List<Day>? weekdays;
  String? id;
  dynamic dbKey;

  Repetition(
      {this.numberOfDays,
      this.dbKey,
      this.notifyTime,
      this.showNotification,
      this.weekdays});
}

class Day {
  WeekDay? weekday;
  bool? isSelected;
  String? id;
  dynamic dbKey;

  Day.copy(Day other)
      : weekday = other.weekday,
        isSelected = other.isSelected;


  Day({this.weekday, this.isSelected, this.dbKey});
}

class Activities {
  String? id;
  String? date;
  String? habitId;
  bool? isDeleted;
  bool? isSynced;
  dynamic dbKey;

  Activities(
      {this.id,
      this.date,
      this.habitId,
      this.isDeleted,
      this.dbKey,
      this.isSynced});
}
