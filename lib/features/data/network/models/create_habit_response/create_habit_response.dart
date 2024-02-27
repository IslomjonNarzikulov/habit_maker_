class CreateHabitResponse {
  CreateHabitResponse({
    this.id,
    this.title,
    this.color,
    this.repetition,
    this.createdAt,
    this.activities,
  });

  CreateHabitResponse.fromJson(dynamic json) {
    id = json['id'];
    title = json['title'];
    color = json['color'];
    repetition = json['repetition'] != null
        ? Repetition.fromJson(json['repetition'])
        : null;
    createdAt = json['createdAt'];
    if (json['activities'] != null) {
      activities = [];
      json['activities'].forEach((v) {
        activities?.add(HabitActivityResponse.fromJson(v));
      });
    }
  }

  String? id;
  String? title;
  String? color;
  Repetition? repetition;
  String? createdAt;
  List<dynamic>? activities;

  CreateHabitResponse copyWith({
    String? id,
    String? title,
    String? color,
    Repetition? repetition,
    String? createdAt,
    List<dynamic>? activities,
  }) =>
      CreateHabitResponse(
        id: id ?? this.id,
        title: title ?? this.title,
        color: color ?? this.color,
        repetition: repetition ?? this.repetition,
        createdAt: createdAt ?? this.createdAt,
        activities: activities ?? this.activities,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['title'] = title;
    map['color'] = color;
    if (repetition != null) {
      map['repetition'] = repetition?.toJson();
    }
    map['createdAt'] = createdAt;
    if (activities != null) {
      map['activities'] = activities?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Repetition {
  Repetition({
    this.numberOfDays,
    this.notifyTime,
    this.showNotification,
    this.weekdays,
  });

  Repetition.fromJson(dynamic json) {
    numberOfDays = json['numberOfDays'];
    notifyTime = json['notifyTime'];
    showNotification = json['showNotification'];
    if (json['weekdays'] != null) {
      weekdays = [];
      json['weekdays'].forEach((v) {
        weekdays?.add(Weekdays.fromJson(v));
      });
    }
  }

  num? numberOfDays;
  String? notifyTime;
  bool? showNotification;
  List<Weekdays>? weekdays;

  Repetition copyWith({
    num? numberOfDays,
    String? notifyTime,
    bool? showNotification,
    List<Weekdays>? weekdays,
  }) =>
      Repetition(
        numberOfDays: numberOfDays ?? this.numberOfDays,
        notifyTime: notifyTime ?? this.notifyTime,
        showNotification: showNotification ?? this.showNotification,
        weekdays: weekdays ?? this.weekdays,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['numberOfDays'] = numberOfDays;
    map['notifyTime'] = notifyTime;
    map['showNotification'] = showNotification;
    if (weekdays != null) {
      map['weekdays'] = weekdays?.map((v) => v.toJson()).toList();
    }
    return map;
  }
}

class Weekdays {
  Weekdays({
    this.weekday,
    this.isSelected,
  });

  Weekdays.fromJson(dynamic json) {
    weekday = json['weekday'];
    isSelected = json['isSelected'];
  }

  String? weekday;
  bool? isSelected;

  Weekdays copyWith({
    String? weekday,
    bool? isSelected,
  }) =>
      Weekdays(
        weekday: weekday ?? this.weekday,
        isSelected: isSelected ?? this.isSelected,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['weekday'] = weekday;
    map['isSelected'] = isSelected;
    return map;
  }
}

class HabitActivityResponse {
  HabitActivityResponse({
    this.id,
    this.date,
    this.habitId,
  });

  HabitActivityResponse.fromJson(dynamic json) {
    id = json['id'];
    date = json['date'];
    habitId = json['habitId'];
  }

  String? id;
  String? date;
  String? habitId;

  HabitActivityResponse copyWith({
    String? id,
    String? date,
    String? habitId,
  }) =>
      HabitActivityResponse(
        id: id ?? this.id,
        date: date ?? this.date,
        habitId: habitId ?? this.habitId,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = id;
    map['date'] = date;
    map['habitId'] = habitId;
    return map;
  }
}
