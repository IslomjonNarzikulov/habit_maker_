import 'package:habit_maker/common/extension.dart';

class HabitModel {
  String? id;
  String? title;
  Repetition? repetition;
  int? dbId;
  int ? color;
  bool? isDeleted;
  bool? isSynced;

  HabitModel(
      { this.id,
        this.title,
        this.repetition,
        this.dbId,
        this.color,
        this.isDeleted,
        this.isSynced
      });

  factory HabitModel.fromJson(Map<String, dynamic> jsonData) {
    return HabitModel(
      id: jsonData['id'],
      title: jsonData['title'],
      repetition: Repetition.fromJson(jsonData['repetition']),
      dbId: null,
      color: int.tryParse(jsonData['color']),
      isDeleted: jsonData['isDeleted'],
      isSynced: jsonData['isSynced'],

    );
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
      'isDeleted': isDeleted==true?1:0,
      'isSynced': isSynced==true?1:0,

    };
  }
}


class Repetition {
  int? numberOfDays;
  String? notifyTime;
  bool? showNotification;
  List<Day>? weekdays;
  String? id;


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

  Repetition.fromDbJson(Map <String, dynamic> json)
  : id = json['habitId'],
  numberOfDays = json['numberOfDays'],
  notifyTime = json['notifyTime'],
  showNotification = json['showNotification']==1;



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

  Map<String, dynamic> toDbJson(String? habitId){
    return{
      'habitId': habitId,
      'numberOfDays':numberOfDays,
      'notifyTime':notifyTime,
      'showNotification':showNotification==true?1:0,
    };
  }
}

class Day {
  WeekDay? weekday;
  bool? isSelected;
  String? id;

  Day({this.weekday, this.isSelected});

  Day.fromJson(Map<String, dynamic> json) {
    weekday = (json['weekday']as String).weekDayFromName();
    isSelected = json['isSelected'];
  }

  Day.fromDbJson(Map<String,dynamic> json)
   :  weekday = (json['weekday']as String).weekDayFromName(),
    isSelected = json['isSelected']==1,
    id = json['habitId'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['weekday'] = weekday!.name;
    data['isSelected'] = isSelected;
    return data;
  }
  Map<String,dynamic> toDbJson(String? habitId){
    return {
      'habitId':habitId,
      'weekday':weekday!.name,
      'isSelected':isSelected==true ? 1:0,
  };
  }
}
