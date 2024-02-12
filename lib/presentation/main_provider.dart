import '../arch_provider/arch_provider.dart';

class MainProvider extends BaseProvider {
  MainProvider(
    keeper,
    habitRepository,
    logoutState,
  ) : super(keeper, habitRepository, logoutState) {
    keeper.habitEvent.stream.listen((event) {
      habits = keeper.habits;
      weekly = keeper.weekly;
      notifyListeners();
    });
  }
}
