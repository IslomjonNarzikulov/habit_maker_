import 'package:habit_maker/features/data/arch_provider/arch_provider.dart';
import 'package:habit_maker/features/domain/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/domain/models/network_response/log_out_state.dart';
import 'package:habit_maker/features/domain/repository/login_repository_api.dart';
import 'package:habit_maker/features/domain/repository/repository_api.dart';

class ProfileProvider extends BaseProvider {
  var loggedState = false;
  String? userFirstName;
  String? userLastName;
 String selectedImagePath = 'assets/lottie/blank.png';
  ProfileProvider(LoginRepositoryApi loginRepository, LogOutState logOutState,
      HabitRepositoryApi habitRepository, HabitStateKeeper keeper)
      : super(
          loginRepository,
          keeper,
          habitRepository,
          logOutState,
        ) {
    isLogged();
    userInfo();
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

  Future<void> userInfo() async {
    userFirstName = await loginRepository.getUserFirstName();
    userLastName = await loginRepository.getUserLastName();
    notifyListeners();
  }
  void selectAvatar(String image){
    selectedImagePath = image;
    notifyListeners();
  }

}
