

import 'package:habit_maker/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/models/log_out_state.dart';

import '../data/repository/repository.dart';
import '../arch_provider/arch_provider.dart';

class LogoutProvider extends BaseProvider {
  var loggedState = false;

  LogoutProvider(
      LogOutState logOutState, Repository habitRepository,HabitStateKeeper keeper)
      : super(keeper,logOutState, habitRepository,);

  void logout() async {
    logoutState.logOut.add(true);
    habitRepository.logout();
    notifyListeners();
  }


  void isLogged() async {
    var result = await habitRepository.isLogged();
    loggedState = result;
  }
}