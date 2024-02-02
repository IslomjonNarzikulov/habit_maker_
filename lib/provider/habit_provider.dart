// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:habit_maker/data/repository/repository.dart';
//
// import '../common/constants.dart';
// import '../models/habit_model.dart';
// import '../models/log_out_state.dart';
//
// class HabitProvider extends ChangeNotifier {
//   var habits = <HabitModel>[];
//   var weekly = <HabitModel>[];
//   bool isLoading = false;
//   Repository repository;
//   LogOutState logOutState;
//   bool isLoggedState = false;
//   FlutterSecureStorage secureStorage;
//   var calendarDates = <DateTime>[];
//
//   HabitProvider(this.repository, this.logOutState, this.secureStorage) {
//     logOutState.logOut.stream.listen((element) {
//       // if (element) {
//       //   secureStorage.delete(key: accessToken);
//       //   secureStorage.delete(key: isUserLogged);
//       //   print('log out');
//       // }
//     });
//   }
//
//   // void createHabit(HabitModel habitModel) async {
//   //   await repository.createHabit(habitModel);
//   //   loadHabits();
//   //   notifyListeners();
//   // }
//
//   // Future<void> createActivities(HabitModel model, DateTime date) async {
//   //   isLoading = true;
//   //   notifyListeners();
//   //   await repository.createActivity(model, date);
//   //   await loadHabits();
//   //   isLoading = false;
//   //   notifyListeners();
//   // }
//
//   // Future<void> deleteActivities(HabitModel model, DateTime date) async {
//   //   isLoading = true;
//   //   notifyListeners();
//   //   await repository.deleteActivity(model, date);
//   //   await loadHabits();
//   //   isLoading = false;
//   //   notifyListeners();
//   // }
// }
