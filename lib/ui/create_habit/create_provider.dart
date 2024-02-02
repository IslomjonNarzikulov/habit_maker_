import 'package:habit_maker/arch_provider/arch_provider.dart';
import 'package:habit_maker/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/data/repository/repository.dart';
import 'package:habit_maker/models/log_out_state.dart';
import '../../models/habit_model.dart';

class CreateProvider extends BaseProvider {
  CreateProvider(LogOutState logOutState, Repository habitRepository,
      HabitStateKeeper keeper)
      : super(
          keeper,
          logOutState,
          habitRepository,
        );
  int numberOfDays = 7;
  bool isEnded = false;
  DateTime dateTime = DateTime.now();
  int selectedIndex = 0;

  void selectColor(int index) {
    selectedIndex = index;
    notifyListeners();
  }

  void createHabit(HabitModel habitModel) async {
    await habitRepository.createHabits(habitModel);
    await loadHabits();
    notifyListeners();
  }

  void updateHabits(HabitModel model, HabitModel habitModel) async {
    await habitRepository.updateHabits(model, habitModel);
    await loadHabits();
    notifyListeners();
  }

  void add(Repetition repeat) {
    if (numberOfDays == 7) {
      isEnded == true;
    } else {
      numberOfDays++;
    }
    repeat.numberOfDays = numberOfDays;
    notifyListeners();
  }

  void subtract(Repetition repeat) {
    if (numberOfDays == 1) {
      isEnded == true;
    } else {
      numberOfDays--;
    }
    repeat.numberOfDays = numberOfDays;
    notifyListeners();
  }

  void selectTime(DateTime time) {
    dateTime = time;
    notifyListeners();
  }
}
