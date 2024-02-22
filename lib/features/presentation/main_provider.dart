import '../../arch_provider/arch_provider.dart';

class MainProvider extends BaseProvider {
  MainProvider(
    loginRepository,
    keeper,
    habitRepository,
    logoutState,
  ) : super(loginRepository, keeper, habitRepository, logoutState) {
    keeper.habitEvent.stream.listen((event) {
      habits = keeper.habits;
      weekly = keeper.weekly;
      notifyListeners();
    });
  }
}
