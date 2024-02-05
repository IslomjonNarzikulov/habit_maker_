import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/arch_provider/arch_provider.dart';
import 'package:habit_maker/common/constants.dart';
import 'package:habit_maker/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/models/log_out_state.dart';

import '../../data/repository/repository.dart';

class LogInProvider extends BaseProvider {

  LogInProvider(
      LogOutState logOutState, Repository habitRepository,HabitStateKeeper keeper)
      : super(keeper,logOutState, habitRepository,);


  void signIn(String email, String password, void Function() success,
      void Function() failure) async {
    if (await habitRepository.signIn(email, password)) {
      loadHabits();
      success();
    }
    failure();
    notifyListeners();
  }
}
