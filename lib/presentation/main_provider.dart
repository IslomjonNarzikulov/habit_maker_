import '../arch_provider/arch_provider.dart';
import '../models/habit_model.dart';

class MainProvider extends BaseProvider {
  MainProvider(
    super.keeper,
    super.habitRepository,
    super.logoutState,
  ) {
    keeper.habitEvent.stream.listen((event) {
      habits = keeper.habits;
      weekly = keeper.weekly;
      notifyListeners();
    });
  }

}
