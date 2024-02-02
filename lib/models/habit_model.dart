import 'package:habit_maker/common/extension.dart';
import 'package:habit_maker/models/activities_model.dart';

class HabitModel {
  String? id;
  String? title;
  Repetition? repetition;
  int? dbId;
  int? color;
  bool? isDeleted;
  bool? isSynced;
  List<Activities>? activities;

  HabitModel(
      {this.id,
      this.activities,
      this.title,
      this.repetition,
      this.dbId,
      this.color,
      this.isDeleted,
      this.isSynced});

  factory HabitModel.fromJson(Map<String, dynamic> jsonData) {
    return HabitModel(
        id: jsonData['id'],
        title: jsonData['title'],
        repetition: Repetition.fromJson(jsonData['repetition']),
        dbId: null,
        color: int.tryParse(jsonData['color']),
        isDeleted: jsonData['isDeleted'],
        isSynced: jsonData['isSynced'],
        activities: List<Activities>.from(jsonData['activities']
            .map((activity) => Activities.fromJson(activity))));
  }

  HabitModel.fromDbJson(Map<String, dynamic> jsonData)
      : id = jsonData['habitId'],
        dbId = jsonData['id'],
        title = jsonData['title'],
        color = jsonData['color'],
        isDeleted = jsonData['isDeleted'] != 0,
        isSynced = jsonData['isSynced'] == 1;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = Map<String, dynamic>();
    jsonData['id'] = id;
    jsonData['title'] = title;
    jsonData['color'] = "$color";
    if (repetition != null) {
      jsonData['repetition'] = repetition!.toJson();
    }
    return jsonData;
  }

  Map<String, Object?> toDbJson() {
    return {
      'habitId': id,
      'title': title,
      'color': color,
      'isDeleted': isDeleted == true ? 1 : 0,
      'isSynced': isSynced == true ? 1 : 0,
    };
  }
}

class Repetition {
  int? numberOfDays;
  String? notifyTime;
  bool? showNotification;
  List<Day>? weekdays;
  String? id;
  int? dbId;

  Repetition(
      {this.numberOfDays,
      this.notifyTime,
      this.showNotification,
      this.weekdays});

  Repetition.fromJson(Map<String, dynamic> json) {
    numberOfDays = json['numberOfDays'];
    notifyTime = json['notifyTime'];
    showNotification = json['showNotification'];
    if (json['weekdays'] != null) {
      weekdays = <Day>[];
      json['weekdays'].forEach((v) {
        weekdays!.add(Day.fromJson(v));
      });
    }
  }

  Repetition.fromDbJson(Map<String, dynamic> json)
      : dbId = json['dbId'],
        numberOfDays = json['numberOfDays'],
        notifyTime = json['notifyTime'],
        showNotification = json['showNotification'] == 1;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['numberOfDays'] = numberOfDays;
    data['notifyTime'] = notifyTime;
    data['showNotification'] = showNotification;
    if (weekdays != null) {
      data['weekdays'] = weekdays?.map((v) => v.toJson()).toList();
    }
    return data;
  }

  Map<String, dynamic> toDbJson(int? habitId) {
    return {
      'dbId': habitId,
      'numberOfDays': numberOfDays,
      'notifyTime': notifyTime,
      'showNotification': showNotification == true ? 1 : 0,
    };
  }
}

class Day {
  WeekDay? weekday;
  bool? isSelected;
  String? id;
  int? dbId;

  Day({this.weekday, this.isSelected});

  Day.copy(Day other)
      : weekday = other.weekday,
        isSelected = other.isSelected;

  Day.fromJson(Map<String, dynamic> json) {
    weekday = (json['weekday'] as String).weekDayFromName();
    isSelected = json['isSelected'];
  }

  Day.fromDbJson(Map<String, dynamic> json)
      : weekday = (json['weekday'] as String).weekDayFromName(),
        isSelected = json['isSelected'] == 1,
        dbId = json['dbId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['weekday'] = weekday!.name;
    data['isSelected'] = isSelected;
    return data;
  }

  Map<String, dynamic> toDbJson(int? habitId) {
    return {
      'dbId': habitId,
      'weekday': weekday!.name,
      'isSelected': isSelected == true ? 1 : 0,
    };
  }
}
