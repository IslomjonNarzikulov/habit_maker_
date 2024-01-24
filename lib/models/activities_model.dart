class Activities {
  String? id;
  int? dbId;
  String? date;
  int? habitId;
  bool? isDeleted;
  bool? isSynced;

  Activities(
      {this.id,
        this.dbId,
        this.date,
        this.habitId,
        this.isDeleted,
        this.isSynced});

  factory Activities.fromJson(Map<String, dynamic> json) {
    return Activities(
      id: json['id'],
      date: json['date'],
      habitId: null,
      dbId: null,
    );
  }

  Activities.fromDbJson(Map<String, dynamic> json)
      : date = json['date'],
        habitId = json['habitId'],
        id = json['activityId'],
        dbId = json['id'],
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