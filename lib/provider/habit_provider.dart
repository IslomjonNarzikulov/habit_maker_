import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/common/constants.dart';
import 'package:habit_maker/database/db_helper.dart';
import 'package:http/http.dart';
import '../models/habit_model.dart';

class HabitProvider extends ChangeNotifier {
  var dbHelper = DBHelper();

  List<HabitModel> habits = [];
  FlutterSecureStorage secureStorage;

  HabitProvider(this.secureStorage);

  Future<bool> createHabit(HabitModel habitModel) async {
    var token = await secureStorage.read(key: accessToken);
    try {
      final response = await post(
        Uri.parse("https://api.habit.nodirbek.uz/v1/habits"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(habitModel.toJson()),
      );
      if (response.statusCode == 401) {
        secureStorage.write(key: accessToken, value: null);
      }
      loadHabits();
      return response.statusCode.isSuccessFull();
    } catch (e) {
      if (habitModel.isSynced == true) {
        var model = HabitModel(
            id: '',
            userId: '',
            description: 'description',
            title: 'title',
            createdAt: '',
            updatedAt: '');
        dbHelper.insert(model);
        notifyListeners();
      }
      return true;
    }
  }

  void loadHabits() async {
    try {
      var token = await secureStorage.read(key: accessToken);
      var list = <HabitModel>[];
      final response = await get(
          Uri.parse('https://api.habit.nodirbek.uz/v1/habits'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      jsonData['habits'].forEach((element) {
        var item = HabitModel.fromJson(element);
        list.add(item);

      });
      var data=await dbHelper.insertAll(list);
      habits = data;
      notifyListeners();
    } catch (e) {
      e.toString();
    }
  }

  Future<bool> deleteHabits(String id) async {

    var token = await secureStorage.read(key: accessToken);
    try{
      final response = await delete(
          Uri.parse('https://api.habit.nodirbek.uz/v1/habits/$id'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token'
          });
      if (response.statusCode == 401) {
        secureStorage.write(key: accessToken, value: null);
      }
      loadHabits();
      return  response.statusCode.isSuccessFull();
    }catch(e){
      var list=await dbHelper.getDataList();
      var item=list.firstWhere((element) =>  element.id==id);
      if(item.isDeleted==true){
        item.isDeleted==false;
        item.isSynced==true;
        dbHelper.update(item);
      }
      notifyListeners();
      return true;
    }
  }

Future<bool> updateHabits(String id,HabitModel habitModel) async {

  var token = await secureStorage.read(key: accessToken);
  try{
    final response = await put(
        Uri.parse('https://api.habit.nodirbek.uz/v1/habits/$id'),
        body: jsonEncode(habitModel.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    loadHabits();
    return  response.statusCode.isSuccessFull();
  }catch(e){
   if(habitModel.isSynced==true){
     dbHelper.update(HabitModel(
       id:id ,
       dbId: habitModel.dbId,
       title:habitModel.title ,
       description: habitModel.description,
       isSynced: false,
     ));
   }
   }
    notifyListeners();
    return true;
  }
  void removeToken () async{
    await secureStorage.delete(key: accessToken);
    print('token removed');
  }
}


extension StatusParsing on int {
  bool isSuccessFull() {
    var res = this >= 200 && this < 300;
    return res;
  }
}
