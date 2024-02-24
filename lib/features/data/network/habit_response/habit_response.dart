import 'package:habit_maker/core/common/extension.dart';
import 'package:json_annotation/json_annotation.dart';

part 'habit_response.g.dart';

@JsonSerializable()
class HabitsWrapper {
  List<HabitResponse>? habits;

  HabitsWrapper({this.habits});

  factory HabitsWrapper.fromJson(Map<String, dynamic> jsonData) {
    return _$HabitsWrapperFromJson(jsonData);
  }
}

@JsonSerializable()
class HabitResponse {
  String? id;
  String? title;
  RepetitionResponse? repetition;
  String? color;
  List<ActivitiesResponse>? activities;

  HabitResponse({
    this.id,
    this.activities,
    this.title,
    this.repetition,
    this.color,
  });

  factory HabitResponse.fromJson(Map<String, dynamic> jsonData) =>
      _$HabitResponseFromJson(jsonData);

  Map<String, dynamic> toJson() => _$HabitResponseToJson(this);
}

@JsonSerializable()
class RepetitionResponse {
  int? numberOfDays;
  String? notifyTime;
  bool? showNotification;
  List<DayResponse>? weekdays;

  RepetitionResponse(
      {this.numberOfDays,
      this.notifyTime,
      this.showNotification,
      this.weekdays});

  factory RepetitionResponse.fromJson(Map<String, dynamic> json) =>
      _$RepetitionResponseFromJson(json);

  Map<String, dynamic> toJson() => _$RepetitionResponseToJson(this);
}

@JsonSerializable()
class DayResponse {
  WeekDay? weekday;
  bool? isSelected;

  DayResponse({this.weekday, this.isSelected});

  factory DayResponse.fromJson(Map<String, dynamic> json) =>
      _$DayResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DayResponseToJson(this);
}

@JsonSerializable()
class ActivitiesResponse {
  String? id;
  String? date;
  String? habitId;

  ActivitiesResponse({
    this.id,
    this.date,
    this.habitId,
  });

  factory ActivitiesResponse.fromJson(Map<String, dynamic> json) =>
      _$ActivitiesResponseFromJson(json);

  Map<String, dynamic> toJson() {
    return _$ActivitiesResponseToJson(this);
  }
}
