import 'package:habit_maker/features/data/arch_provider/arch_provider.dart';
import 'package:habit_maker/features/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/data/models/log_out_state.dart';
import 'package:habit_maker/features/domain/repository/repository_api.dart';

class HomeProvider extends BaseProvider {
  var loggedState = false;
  String? userFirstName;
  String? userLastName;

  HomeProvider(LogOutState logOutState, HabitRepositoryApi habitRepository,
      HabitStateKeeper keeper)
      : super(
          keeper,
          habitRepository,
          logOutState,
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
