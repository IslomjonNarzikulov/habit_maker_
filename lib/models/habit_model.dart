import 'package:habit_maker/common/extension.dart';

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

  factory HabitModel.fromJson(Map<String, dynamic> jsonData) {
    return HabitModel(
        id: jsonData['id'],
        title: jsonData['title'],
        repetition: Repetition.fromJson(jsonData['repetition']),
        color: int.tryParse(jsonData['color']),
        isDeleted: jsonData['isDeleted'],
        isSynced: jsonData['isSynced'],
        activities: List<Activities>.from(jsonData['activities']
            .map((activity) => Activities.fromJson(activity))));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = <String, dynamic>{};
    jsonData['id'] = id;
    jsonData['title'] = title;
    jsonData['color'] = "$color";
    if (repetition != null) {
      jsonData['repetition'] = repetition!.toJson();
    }
    return jsonData;
  }
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

  Repetition.fromJson(Map<String, dynamic> json) {
    numberOfDays = json['numberOfDays'];
    showNotification = json['showNotification'];
    if (json['weekdays'] != null) {
      weekdays = <Day>[];
      json['weekdays'].forEach((v) {
        weekdays!.add(Day.fromJson(v));
      });
    }
    numberOfDays = json['numberOfDays'];
    var time = json['notifyTime'] as String?;
    if (time?.contains(':') ?? false) {
      notifyTime = _formatHHMMtoDateTime(time!);
    }
    showNotification = json['showNotification'];
  }

  DateTime _formatHHMMtoDateTime(String date) {
    List<String> parts = date.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  String _formatDateTimeToHHMM(DateTime dateTime) {
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (weekdays != null) {
      map['weekdays'] = weekdays?.map((v) => v.toJson()).toList();
    }
    map['numberOfDays'] = numberOfDays;
    if (notifyTime != null) {
      map['notifyTime'] = _formatDateTimeToHHMM(notifyTime!);
    } else {
      map['notifyTime'] = "";
    }
    map['showNotification'] = showNotification;
    return map;
  }
}

class Day {
  WeekDay? weekday;
  bool? isSelected;
  String? id;
  dynamic dbKey;

  Day({this.weekday, this.isSelected, this.dbKey});

  Day.copy(Day other)
      : weekday = other.weekday,
        isSelected = other.isSelected;

  Day.fromJson(Map<String, dynamic> json) {
    weekday = (json['weekday'] as String).weekDayFromName();
    isSelected = json['isSelected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['weekday'] = weekday!.name;
    data['isSelected'] = isSelected;
    return data;
  }
}
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

  factory Activities.fromJson(Map<String, dynamic> json) {
    return Activities(
      id: json['id'],
      date: json['date'],
      habitId: null,
    );
  }

  Activities.fromDbJson(Map<String, dynamic> json)
      : date = json['date'],
        habitId = json['habitId'],
        id = json['activityId'],
        isDeleted = json['isDeleted'] != 0,
        isSynced = json['isSynced'] == 1;

  Map<String, dynamic> toDbJson() {
    return {
      'activityId': id,
      'habitId': habitId,
      'date': date,
      'isDeleted': isDeleted == true ? 1 : 0,
      'isSynced': isSynced == true ? 1 : 0,
    };
  }
}

