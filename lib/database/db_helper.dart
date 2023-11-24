// ignore_for_file: depend_on_referenced_packages

import 'dart:io' as io;

import 'package:habit_maker/models/habit_model.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

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
    await db.execute("CREATE TABLE habit("
        "id INTEGER "
        "PRIMARY KEY AUTOINCREMENT,"
        "habitId TEXT,"
        " userId TEXT,"
        "  title TEXT,"
        "  description TEXT,"
        " createdAt TEXT,"
        "   updatedAt TEXT,"
        "color INTEGER,"
        "date INTEGER,"
        "isSynced INTEGER DEFAULT 1,"
        "isDeleted INTEGER DEFAULT 0)");
  }

  //inserting database
  Future<HabitModel> insert(HabitModel habitModel) async {
    var dbClient = await db;
    await dbClient?.insert('habit', habitModel.toDbJson());
    return habitModel;
  }

  Future<List<HabitModel>> insertAll(List<HabitModel> list) async {
    await deleteAll();
    await Future.forEach(list, (element) async {
      await insert(element);
    });
    return getDataList();
  }

  Future<void> deleteAll() async {
    await db;
    // ignore: non_constant_identifier_names
    final List<Map<String, dynamic>> queryResult =
        await _db!.rawQuery('SELECT * FROM habit');
    await Future.forEach(queryResult, (element) async {
      await delete(element['id']!);
    });
  }

  Future<List<HabitModel>> getDataList() async {
    await db;
    // ignore: non_constant_identifier_names
    final List<Map<String, Object?>> queryResult =
        await _db!.rawQuery('SELECT * FROM habit');
    return queryResult.map((e) {
      return HabitModel.fromDbJson(e);
    }).toList();
  }

  Future<int> update(HabitModel habitModel) async {
    var dbClient = await db;
    return await dbClient!.update('habit', habitModel.toDbJson(),
        where: 'id=?', whereArgs: [habitModel.dbId]);
  }

  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient!.delete('habit', where: 'id=?', whereArgs: [id]);
  }
}
