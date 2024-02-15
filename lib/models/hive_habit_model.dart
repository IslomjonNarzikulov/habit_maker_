import 'package:hive/hive.dart';
part 'hive_habit_model.g.dart';

@HiveType(typeId: 0)
class HiveHabitModel extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  HiveRepetition? hiveRepetition;
  @HiveField(3)
  int? color;
  @HiveField(4)
  bool? isDeleted;
  @HiveField(5)
  bool? isSynced;
  @HiveField(6)
  List<HiveActivities>? activities;

  HiveHabitModel(
      {this.id,
      this.hiveRepetition,
      this.color,
      this.isDeleted,
      this.activities,
      this.isSynced,
      this.title});
}

@HiveType(typeId: 1)
class HiveRepetition {
  @HiveField(0)
  int? numberOfDays;
  @HiveField(1)
  DateTime? notifyTime;
  @HiveField(2)
  bool? showNotification;
  @HiveField(3)
  List<HiveDay>? weekdays;
  @HiveField(4)
  String? id;

  HiveRepetition(
      {this.id,
      this.numberOfDays,
      this.notifyTime,
      this.showNotification,
      this.weekdays});
}

@HiveType(typeId: 2)
class HiveDay {
  @HiveField(0)
  int? weekday;
  @HiveField(1)
  bool? isSelected;
  @HiveField(2)
  String? id;

  HiveDay({this.weekday, this.isSelected});
}

@HiveType(typeId: 3)
class HiveActivities extends HiveObject {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? date;
  @HiveField(2)
  bool? isDeleted;
  @HiveField(3)
  bool? isSynced;

  HiveActivities({this.id, this.date, this.isDeleted, this.isSynced});
}
