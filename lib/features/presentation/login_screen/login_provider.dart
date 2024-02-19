import 'package:habit_maker/features/data/arch_provider/arch_provider.dart';
import 'package:habit_maker/features/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/data/models/log_out_state.dart';

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
