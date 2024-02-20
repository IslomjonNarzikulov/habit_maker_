import 'package:habit_maker/features/data/arch_provider/arch_provider.dart';
import 'package:habit_maker/features/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/data/models/log_out_state.dart';
import 'package:habit_maker/features/data/repository/repository.dart';

class ProfileProvider extends BaseProvider {
  var loggedState = false;
  String? userFirstName;
  String? userLastName;

  ProfileProvider(LogOutState logOutState, Repository habitRepository,
      HabitStateKeeper keeper)
      : super(
          keeper,
          logOutState,
          habitRepository,
        ) {
    isLogged();
    userInfo();
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

  Future<void> userInfo() async {
    userFirstName = await habitRepository.getUserFirstName();
    userLastName = await habitRepository.getUserLastName();
    notifyListeners();
  }
}
