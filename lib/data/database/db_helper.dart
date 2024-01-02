// ignore_for_file: depend_on_referenced_packages
import 'dart:io' as io;

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
        "  title TEXT ,"
        "color INTEGER DEFAULT 0,"
        "isDeleted INTEGER DEFAULT 0,"
        "isSynced INTEGER DEFAULT 1 )");

    await db.execute("CREATE TABLE $repetitionTableName("
        "id INTEGER "
        "PRIMARY KEY AUTOINCREMENT,"
        "habitId TEXT ,"
        "numberOfDays INTEGER,"
        "notifyTime TEXT,"
        "showNotification INTEGER DEFAULT 0)");

    await db.execute("CREATE TABLE $weekdayTableName("
        "id INTEGER "
        "PRIMARY KEY AUTOINCREMENT,"
        "habitId TEXT,"
        "weekday TEXT,"
        "isSelected INTEGER DEFAULT 0)");
  }

  //inserting database
  Future<HabitModel> insertHabit(
    HabitModel habitModel,
  ) async {
    final dbClient = await db;
    try {
      await dbClient?.insert(habitTableName, habitModel.toDbJson());
    } catch (e) {
      e.toString();
    }
    try {
      await dbClient?.insert(
          repetitionTableName, habitModel.repetition!.toDbJson(habitModel.id));
    } catch (e) {
      e.toString();
    }
    try {
      habitModel.repetition!.weekdays!.forEach((e) async {
        var model = e.toDbJson(habitModel.id);
        await dbClient?.insert(weekdayTableName, model);
      });
    } catch (e) {
      e.toString();
    }
    return habitModel;
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
          await delete(element['habitId']!);
    });
  }

  Future<List<HabitModel>> getHabitList() async {
    try {
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
            .where((element) => element.id == habit['habitId'])
            .first;
        var weekday = weekdayList
            .map((e) {
              return Day.fromDbJson(e);
            })
            .toList()
            .where((element) => element.id == habit['habitId'])
            .toList();
        var model = HabitModel.fromDbJson(habit);
        repetition.weekdays = weekday;
        model.repetition = repetition;
        return model;
      }).toList();
      return habits;
    } catch (e) {
      e.toString();
      return [];
    }
  }

  Future<void> updateHabit(HabitModel habitModel) async {
    var dbClient = await db;
    await dbClient!.update(habitTableName, habitModel.toDbJson(),
        where: 'id=?', whereArgs: [habitModel.dbId]);
    await dbClient.update(
        repetitionTableName, habitModel.repetition!.toDbJson(habitModel.id),
        where: 'habitId=?', whereArgs: [habitModel.id]);
    habitModel.repetition!.weekdays!.forEach((element) async {
      await dbClient.update(weekdayTableName, element.toDbJson(habitModel.id),
          where: 'habitId=?', whereArgs: [habitModel.id]);
    });
  }

  Future<void> delete(String id) async {
    var dbClient = await db;
    await dbClient!.delete(habitTableName, where: 'habitId=?', whereArgs: [id]);
    await dbClient
        .delete(repetitionTableName, where: 'habitId=?', whereArgs: [id]);
    await dbClient
        .delete(weekdayTableName, where: 'habitId=?', whereArgs: [id]);
  }

  String habitTableName = 'habit';
  String repetitionTableName = 'repetition';
  String weekdayTableName = 'weekdays';
}
