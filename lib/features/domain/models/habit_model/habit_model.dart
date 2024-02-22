import 'package:habit_maker/core/common/extension.dart';
import 'package:json_annotation/json_annotation.dart';
part 'habit_model.g.dart';

@JsonSerializable()
class HabitsWrapper{
  List<HabitModel>? habits;
  HabitsWrapper({this.habits});

 factory HabitsWrapper.fromJson(Map<String, dynamic> jsonData) {
   return _$HabitsWrapperFromJson(
       jsonData
   );
 }
}

@JsonSerializable()
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

  factory HabitModel.fromJson(Map<String, dynamic> jsonData)=> _$HabitModelFromJson(jsonData);
  Map<String, dynamic> toJson() => _$HabitModelToJson(this);
}

@JsonSerializable()
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

 factory Repetition.fromJson(Map<String, dynamic> json) => _$RepetitionFromJson(json);
  Map<String, dynamic> toJson() => _$RepetitionToJson(this);



  // DateTime _formatHHMMtoDateTime(String date) {
  //   List<String> parts = date.split(':');
  //   int hour = int.parse(parts[0]);
  //   int minute = int.parse(parts[1]);
  //
  //   DateTime now = DateTime.now();
  //   return DateTime(now.year, now.month, now.day, hour, minute);
  // }
  //
  // String _formatDateTimeToHHMM(DateTime dateTime) {
  //   String hour = dateTime.hour.toString().padLeft(2, '0');
  //   String minute = dateTime.minute.toString().padLeft(2, '0');
  //   return "$hour:$minute";
  // }

}

@JsonSerializable()
class Day {
  WeekDay? weekday;
  bool? isSelected;
  String? id;
  dynamic dbKey;

  Day({this.weekday, this.isSelected, this.dbKey});

  Day.copy(Day other)
      : weekday = other.weekday,
        isSelected = other.isSelected;

  factory Day.fromJson(Map<String, dynamic> json) =>_$DayFromJson(json);


  Map<String, dynamic> toJson() => _$DayToJson(this);
}

@JsonSerializable()
class Activities {
  String? id;
  String? date;
  int? habitId;
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

  factory Activities.fromJson(Map<String, dynamic> json)=> _$ActivitiesFromJson(json);

}

