// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habit_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HabitsWrapper _$HabitsWrapperFromJson(Map<String, dynamic> json) =>
    HabitsWrapper(
      habits: (json['habits'] as List<dynamic>?)
          ?.map((e) => HabitResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HabitsWrapperToJson(HabitsWrapper instance) =>
    <String, dynamic>{
      'habits': instance.habits,
    };

HabitResponse _$HabitResponseFromJson(Map<String, dynamic> json) =>
    HabitResponse(
      id: json['id'] as String?,
      title: json['title'] as String?,
      color: json['color'] as String?,
      repetition: json['repetition'] == null
          ? null
          : RepetitionResponse.fromJson(
              json['repetition'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
      activities: (json['activities'] as List<dynamic>?)
          ?.map((e) => ActivitiesResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$HabitResponseToJson(HabitResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'color': instance.color,
      'repetition': instance.repetition,
      'createdAt': instance.createdAt,
      'activities': instance.activities,
    };

RepetitionResponse _$RepetitionResponseFromJson(Map<String, dynamic> json) =>
    RepetitionResponse(
      numberOfDays: json['numberOfDays'] as int?,
      notifyTime: json['notifyTime'] as String?,
      showNotification: json['showNotification'] as bool?,
      weekdays: (json['weekdays'] as List<dynamic>?)
          ?.map((e) => DayResponse.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$RepetitionResponseToJson(RepetitionResponse instance) =>
    <String, dynamic>{
      'numberOfDays': instance.numberOfDays,
      'notifyTime': instance.notifyTime,
      'showNotification': instance.showNotification,
      'weekdays': instance.weekdays,
    };

DayResponse _$DayResponseFromJson(Map<String, dynamic> json) => DayResponse(
      weekday: $enumDecodeNullable(_$WeekDayEnumMap, json['weekday']),
      isSelected: json['isSelected'] as bool?,
    );

Map<String, dynamic> _$DayResponseToJson(DayResponse instance) =>
    <String, dynamic>{
      'weekday': _$WeekDayEnumMap[instance.weekday],
      'isSelected': instance.isSelected,
    };

const _$WeekDayEnumMap = {
  WeekDay.MONDAY: 'MONDAY',
  WeekDay.TUESDAY: 'TUESDAY',
  WeekDay.WEDNESDAY: 'WEDNESDAY',
  WeekDay.THURSDAY: 'THURSDAY',
  WeekDay.FRIDAY: 'FRIDAY',
  WeekDay.SATURDAY: 'SATURDAY',
  WeekDay.SUNDAY: 'SUNDAY',
};

ActivitiesResponse _$ActivitiesResponseFromJson(Map<String, dynamic> json) =>
    ActivitiesResponse(
      id: json['id'] as String?,
      date: json['date'] as String?,
      habitId: json['habitId'] as String?,
    );

Map<String, dynamic> _$ActivitiesResponseToJson(ActivitiesResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'habitId': instance.habitId,
    };
