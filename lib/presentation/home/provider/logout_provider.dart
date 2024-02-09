import 'package:habit_maker/arch_provider/arch_provider.dart';
import 'package:habit_maker/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/data/repository/repository.dart';
import 'package:habit_maker/models/log_out_state.dart';

class HomeProvider extends BaseProvider {
  var loggedState = false;

  HomeProvider(LogOutState logOutState, Repository habitRepository,
      HabitStateKeeper keeper)
      : super(
          keeper,
          logOutState,
          habitRepository,
        ) {
    isLogged();
  }

  void logOut() {
    logoutState.logOutEvent.add(true);
    loggedState = false;
    habitRepository.logout();
    keeper.clear();
    notifyListeners();
  }

  Future<void> isLogged() async {
    var result = await habitRepository.isLogged();
    loggedState = result;
    notifyListeners();
  }
}
