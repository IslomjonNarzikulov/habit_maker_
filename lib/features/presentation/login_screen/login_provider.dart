import 'package:habit_maker/features/data/arch_provider/arch_provider.dart';
import 'package:habit_maker/features/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/data/models/log_out_state.dart';
import 'package:habit_maker/features/domain/repository/repository_api.dart';

class LogInProvider extends BaseProvider {
  bool passwordVisible = false;

  LogInProvider(LogOutState logOutState, HabitRepositoryApi habitRepository,
      HabitStateKeeper keeper)
      : super(
          keeper,
          habitRepository,
          logOutState,
        );

  void signIn(String email, String password, void Function() success,
      void Function() failure) async {
    if (await habitRepository.signIn(email, password)) {
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
