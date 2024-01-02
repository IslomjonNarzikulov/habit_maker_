import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/data/database/db_helper.dart';
import 'package:habit_maker/models/login_response.dart';
import '../../common/constants.dart';
import '../../models/habit_model.dart';
import '../network_client/network_client.dart';

class Repository {
  NetworkClient networkClient;
  DBHelper dbHelper;
  List<HabitModel> habits = [];
  FlutterSecureStorage secureStorage;

  Repository(
      {required this.dbHelper,
      required this.networkClient,
      required this.secureStorage});

  Future<bool> createHabit(HabitModel habitModel) async {
    var token = await secureStorage.read(key: accessToken);
    if (token == null) return false;
    await networkClient.createHabit(habitModel, token);
    if (habitModel.isSynced == true) {
      var model = HabitModel(
        title: habitModel.title,
        color: habitModel.color,
        repetition: habitModel.repetition,
        isSynced: false,
      );
      await dbHelper.insertHabit(model);
    }
    return true;
  }

  Future<List<HabitModel>> loadHabits() async {
    var databaseList = await dbHelper.getHabitList();
    if (databaseList.isNotEmpty) {
      return databaseList;
    } else {
      var token = await secureStorage.read(key: accessToken);
      if (token == null) return [];
      var list = await networkClient.loadHabits(token);
      var data = await dbHelper.insertAllHabits(list);
      return data;
    }
  }

  Future<bool> deleteHabits(String id) async {
    var token = await secureStorage.read(key: accessToken);
    if (token == null) return false;
    await networkClient.deleteHabits(id, token);
    var databaseList = await dbHelper.getHabitList();
    var item = databaseList.firstWhere((element) => element.id == id);
    if (item.isDeleted == false) {
      item.isDeleted == true;
      item.isSynced == false;
      dbHelper.updateHabit(item);
      return true;
    } else {
      return false;
    }
  }

  Future<bool> updateHabits(String id, HabitModel habitModel) async {
    var token = await secureStorage.read(key: accessToken);
    if (token == null) return false;
    networkClient.updateHabits(id, habitModel, token);
    if (habitModel.isSynced == true) {
      habitModel.isSynced = false;
      habitModel.id = id;
      dbHelper.updateHabit(habitModel);
    }
    return true;
  }
  Future<bool> signIn ( String email, String password, ) async {
    if(email.isNotEmpty&&password.isNotEmpty){
      var user=await networkClient.login(email, password);
      saveUserCredentials(user!);
      return user!=null;
    }
    return false;
  }

  Future<void> signUp (String username, String password,)async {
    if (username.isNotEmpty && password.isNotEmpty) {
      var user = await networkClient.signUp_response(username, password);
      secureStorage.write(key: accessToken, value: user!.token);

    }
  }

  Future<void> verify(String otp) async {
    var token = await secureStorage.read(key: accessToken);
    if (token != null && otp.isNotEmpty) {
      var user = await networkClient.verify_response(token, otp);
      if (user != null) {
        secureStorage.write(key: accessToken, value: user.token!.accessToken);
        secureStorage.write(key: firstName, value: user.user!.firstName);
        secureStorage.write(key: lastName, value: user.user!.lastName);
        secureStorage.write(key: email, value: user.user!.email);
        secureStorage.write(key: userId, value: user.user!.id);
    }
  }
}
  Future<void> refreshUserToken() async {
    var token = await secureStorage.read(key: refreshToken);
    var user = await networkClient.refreshToken(token!);
    if (user != null) {
    saveUserCredentials(user);
    }
  }

  void saveUserCredentials(LoginResponse user) {
    secureStorage.write(key: accessToken, value: user.token!.accessToken);
    secureStorage.write(key: refreshToken, value: user.token!.refreshToken);
    secureStorage.write(key: firstName, value: user.user!.firstName);
    secureStorage.write(key: lastName, value: user.user!.lastName);
    secureStorage.write(key: email, value: user.user!.email);
    secureStorage.write(key: userId, value: user.user!.id);
  }
}
