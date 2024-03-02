import 'package:freezed_annotation/freezed_annotation.dart';
part 'create_habit_response.freezed.dart';
part 'create_habit_response.g.dart';

@freezed
class CreateHabitResponse with _$CreateHabitResponse {
  factory CreateHabitResponse({
    String? id,
    String? title,
    String? color,
    Repetition? repetition,
    String? createdAt,
    List<HabitActivityResponse>? activities,
  }) = _CreateHabitResponse;

  factory CreateHabitResponse.fromJson(Map<String, dynamic> json) =>
      _$CreateHabitResponseFromJson(json);
}

@freezed
class Repetition with _$Repetition {
  factory Repetition({
    num? numberOfDays,
    String? notifyTime,
    bool? showNotification,
    List<Weekdays>? weekdays,
  }) = _Repetition;

  factory Repetition.fromJson(Map<String, dynamic> json) =>
      _$RepetitionFromJson(json);
}

@freezed
class Weekdays with _$Weekdays {
  factory Weekdays({
    String? weekday,
    bool? isSelected,
  }) = _Weekdays;

  factory Weekdays.fromJson(Map<String, dynamic> json) =>
      _$WeekdaysFromJson(json);
}

@freezed
class HabitActivityResponse with _$HabitActivityResponse {
  factory HabitActivityResponse({
    String? id,
    String? date,
    String? habitId,
  }) = _HabitActivityResponse;

  factory HabitActivityResponse.fromJson(Map<String, dynamic> json) =>
      _$HabitActivityResponseFromJson(json);
}
