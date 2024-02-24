import 'package:habit_maker/arch_provider/arch_provider.dart';
import 'package:habit_maker/features/domain/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/data/network/network_response/log_out_state.dart';
import 'package:habit_maker/features/domain/repository/login_repository_api.dart';
import 'package:habit_maker/features/domain/repository/habit_repository_api.dart';

class HomeProvider extends BaseProvider {
  var loggedState = false;
  String? userFirstName;
  String? userLastName;

  HomeProvider(LoginRepositoryApi loginRepository, LogOutState logOutState,
      HabitRepositoryApi habitRepository, HabitStateKeeper keeper)
      : super(
          loginRepository,
          keeper,
          habitRepository,
          logOutState,
        ) {
    isLogged();
  }

  void logOut() {
    logoutState.logOutEvent.add(true);
    loggedState = false;
    loginRepository.logout();
    keeper.clear();
    notifyListeners();
  }

  Future<void> isLogged() async {
    var result = await loginRepository.isLogged();
    loggedState = result;
    notifyListeners();
  }
}
