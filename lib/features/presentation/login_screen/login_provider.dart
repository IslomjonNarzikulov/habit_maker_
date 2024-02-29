import 'package:habit_maker/arch_provider/arch_provider.dart';
import 'package:habit_maker/features/domain/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/data/network/models/network_response/log_out_state.dart';
import 'package:habit_maker/features/domain/repository/login_repository_api.dart';
import 'package:habit_maker/features/domain/repository/habit_repository_api.dart';

class LogInProvider extends BaseProvider {
  bool passwordVisible = false;

  LogInProvider(LoginRepositoryApi loginRepository, LogOutState logOutState,
      HabitRepositoryApi habitRepository, HabitStateKeeper keeper)
      : super(
          loginRepository,
          keeper,
          habitRepository,
          logOutState,
        );

  void signIn(String email, String password, void Function() success,
      void Function() failure) async {
    if (await loginRepository.signIn(email, password)) {
      await habitRepository.initializeConnectivity();
      loadHabits();
      success();
    }
    failure();
    notifyListeners();
  }

  void passwordVisibility() {
    passwordVisible = !passwordVisible;
    notifyListeners();
  }
}
