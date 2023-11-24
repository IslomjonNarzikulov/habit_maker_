class HabitModel {
  String? id;
  String? userId;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;
  int? dbId;
  int? color;
  bool? isDeleted;
  bool? isSynced;

  HabitModel(
      {this.id,
        this.userId,
        this.title,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.dbId,
        this.color,
        this.isDeleted,
        this.isSynced});

  factory HabitModel.fromJson(Map<String, dynamic> jsonData) {
    return HabitModel(
      id: jsonData['id'],
      userId: jsonData['userId'],
      title: jsonData['title'],
      description: jsonData['description'],
      createdAt: jsonData['createdAt'],
      updatedAt: jsonData['updatedAt'],
      dbId: null,
      color: jsonData['color'],
      isDeleted: jsonData['isDeleted'],
      isSynced: jsonData['isSynced'],
    );
  }

  HabitModel.fromDbJson(Map<String, dynamic> jsonData)
      : id = jsonData['habitId'],
        userId = jsonData['userId'],
        dbId = jsonData['id'],
        title = jsonData['title'],
        description = jsonData['description'],
        createdAt = jsonData['createdAt'],
        updatedAt = jsonData['updatedAt'],
        color = jsonData['color'],
        isDeleted = jsonData['isDeleted'] != 0,
        isSynced = jsonData['isSynced'] == 1;


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> jsonData = Map<String, dynamic>();
    jsonData['id'] = id;
    jsonData['userId'] = userId;
    jsonData['title'] = title;
    jsonData['description'] = description;
    jsonData['createdAt'] = createdAt;
    jsonData['updatedAt'] = updatedAt;
    return jsonData;
  }

  Map<String, Object?> toDbJson() {
    return {
      'habitId': id,
      'userId': userId,
      'title': title,
      'description': description,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
      'color': color,
      'isDeleted': isDeleted,
      'isSynced': isSynced,
    };
  }
}