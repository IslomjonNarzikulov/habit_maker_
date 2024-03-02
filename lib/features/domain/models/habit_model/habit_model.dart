import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:habit_maker/core/common/extension.dart';

part 'habit_model.freezed.dart';
part 'habit_model.g.dart';

@unfreezed
class HabitModel with _$HabitModel {
  factory HabitModel({
    String? id,
    dynamic dbKey,
    List<Activities>? activities,
    String? title,
    Repetition? repetition,
    int? color,
    bool? isDeleted,
    bool? isSynced,
  }) = _HabitModel;

  factory HabitModel.fromJson(Map<String, dynamic> json) =>
      _$HabitModelFromJson(json);
}

@unfreezed
class Repetition with _$Repetition {
  factory Repetition({
    int? numberOfDays,
    dynamic dbKey,
    DateTime? notifyTime,
    bool? showNotification,
    List<Day>? weekdays,
  }) = _Repetition;

  factory Repetition.fromJson(Map<String, dynamic> json) =>
      _$RepetitionFromJson(json);
}

@unfreezed
class Day with _$Day {
  factory Day({
    WeekDay? weekday,
    bool? isSelected,
    dynamic dbKey,
    String? id,
  }) = _Day;

  factory Day.fromJson(Map<String, dynamic> json) => _$DayFromJson(json);

  factory Day.copy(Day other)=>Day(
    weekday: other.weekday,
    isSelected: other.isSelected,
    dbKey: other.dbKey,
    id: other.id,
  );
}

@unfreezed
class Activities with _$Activities {
  factory Activities({
    String? id,
    String? date,
    String? habitId,
    bool? isDeleted,
    bool? isSynced,
    dynamic dbKey,
  }) = _Activities;

  factory Activities.fromJson(Map<String, dynamic> json) =>
      _$ActivitiesFromJson(json);
}
