class Activities {
  String? id;
  String? date;
  int? habitId;

  Activities({this.id, this.date, this.habitId});

  Activities.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    habitId =null;
  }

  Activities.fromDbJson(Map<String, dynamic> jsonData)
      : id = jsonData['id'],
        date = jsonData['date'],
        habitId = jsonData['habitId'];

  Map<String, dynamic> toDbJson() {
    return {
      'id': id,
      'date': date,
      'habitId': habitId,
    };
  }
}
