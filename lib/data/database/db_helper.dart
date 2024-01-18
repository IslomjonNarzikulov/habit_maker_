// ignore_for_file: depend_on_referenced_packages
import 'dart:io' as io;

import 'package:habit_maker/models/activities_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/habit_model.dart';

class DBHelper {
  static Database? _db;

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDatabase();
    return null;
  }

  initDatabase() async {
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'HabitMaker.db');
    var db = await openDatabase(path, version: 1, onCreate: _createDatabase);
    return db;
  }

  _createDatabase(Database db, int version) async {
    //creating table in the database
    await db.execute("CREATE TABLE $habitTableName("
        "id INTEGER "
        "PRIMARY KEY AUTOINCREMENT,"
        "habitId TEXT ,"
        "title TEXT ,"
        "color INTEGER DEFAULT 0,"
        "isDeleted INTEGER DEFAULT 0,"
        "isSynced INTEGER DEFAULT 1 )");

    await db.execute("CREATE TABLE $repetitionTableName("
        "id INTEGER "
        "PRIMARY KEY AUTOINCREMENT,"
        "dbId INTEGER,"
        "numberOfDays INTEGER,"
        "notifyTime TEXT,"
        "showNotification INTEGER DEFAULT 0)");

    await db.execute("CREATE TABLE $weekdayTableName("
        "id INTEGER "
        "PRIMARY KEY AUTOINCREMENT,"
        "dbId INTEGER,"
        "weekday TEXT,"
        "isSelected INTEGER DEFAULT 0)");

    await db.execute("CREATE TABLE $activityTable("
        "id INTEGER "
        "PRIMARY KEY AUTOINCREMENT,"
        "habitId INTEGER,"
        "date TEXT)");
  }

  Future<void> insertHabit(
    HabitModel habitModel,
  ) async {
    final dbClient = await db;
    try {
      int? dbId;
      dbId = await dbClient?.insert(habitTableName, habitModel.toDbJson());
      await dbClient?.insert(
          repetitionTableName, habitModel.repetition!.toDbJson(dbId));
      await Future.forEach(habitModel.repetition!.weekdays!, (element) async {
        var model = element.toDbJson(dbId);
        await dbClient?.insert(weekdayTableName, model);
      });
    } catch (e) {
      e.toString();
    }
  }

  Future<List<HabitModel>> insertAllHabits(List<HabitModel> list) async {
    await deleteAllHabits();
    await Future.forEach(list, (element) async {
      await insertHabit(element);
    });
    return getHabitList();
  }

  Future<void> deleteAllHabits() async {
    await db;
    final List<Map<String, dynamic>> habitResult =
        await _db!.rawQuery('SELECT * FROM $habitTableName');
    await Future.forEach(habitResult, (element) async {
      await delete(element['id']!);
    });
  }

  Future<List<HabitModel>> getHabitList() async {
    await db;
    final List<Map<String, Object?>> habitList =
        await _db!.rawQuery('SELECT * FROM $habitTableName');
    final List<Map<String, Object?>> repetitionList =
        await _db!.rawQuery('SELECT * FROM $repetitionTableName');
    final List<Map<String, Object?>> weekdayList =
        await _db!.rawQuery('SELECT * FROM $weekdayTableName');
    var habits = habitList.map((habit) {
      var repetition = repetitionList
          .map((e) {
            return Repetition.fromDbJson(e);
          })
          .toList()
          .where((element) => element.dbId == habit['id'])
          .first;
      var weekday = weekdayList
          .map((e) {
            return Day.fromDbJson(e);
          })
          .toList()
          .where((element) => element.dbId == habit['id'])
          .toList();
      var model = HabitModel.fromDbJson(habit);
      repetition.weekdays = weekday;
      model.repetition = repetition;
      return model;
    }).toList();
    return habits;
  }

  Future<void> updateHabit(HabitModel habitModel) async {
    var dbClient = await db;
    await dbClient!.update(habitTableName, habitModel.toDbJson(),
        where: 'id=?', whereArgs: [habitModel.dbId]);
    await dbClient.update(
        repetitionTableName, habitModel.repetition!.toDbJson(habitModel.dbId),
        where: 'dbId=?', whereArgs: [habitModel.dbId]);
    habitModel.repetition!.weekdays!.forEach((element) async {
      await dbClient.update(weekdayTableName, element.toDbJson(habitModel.dbId),
          where: 'dbId=?', whereArgs: [habitModel.dbId]);
    });
  }

  Future<void> delete(int id) async {
    var dbClient = await db;
    await dbClient!.delete(habitTableName, where: 'id=?', whereArgs: [id]);
    await dbClient
        .delete(repetitionTableName, where: 'dbId=?', whereArgs: [id]);
    await dbClient.delete(weekdayTableName, where: 'dbId=?', whereArgs: [id]);
  }

  Future<void> insertActivities(Activities activities) async {
    final dbClient = await db;
    try {
      await dbClient?.insert(activityTable, activities.toDbJson());
    } catch (e) {
      e.toString();
    }
  }

  String habitTableName = 'habit';
  String repetitionTableName = 'repetition';
  String weekdayTableName = 'weekdays';
  String activityTable = 'activity';
}
