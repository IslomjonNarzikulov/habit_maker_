import 'package:habit_maker/arch_provider/arch_provider.dart';
import 'package:habit_maker/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/data/repository/repository.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/models/hive_habit_model.dart';
import 'package:habit_maker/models/log_out_state.dart';


class CreateProvider extends BaseProvider {
  int selectedColorIndex = 0;
  late HiveRepetition hiveRepetition;
  var isDailySelected = false;

  CreateProvider(LogOutState logOutState, Repository habitRepository,
      HabitStateKeeper keeper)
      : super(
          keeper,
          logOutState,
          habitRepository,
        );

  void selectColor(int index) {
    selectedColorIndex = index;
    notifyListeners();
  }

  void createHabit(HiveHabitModel hiveHabitModel) async {
    await habitRepository.createHabits(hiveHabitModel, isDailySelected);
    await loadHabits();
    notifyListeners();
  }

  void updateHabits(HiveHabitModel model) async {
    await habitRepository.updateHabits(model, isDailySelected);
    await loadHabits();
    notifyListeners();
  }

  void add() {
    if (hiveRepetition.numberOfDays != 7 && hiveRepetition.numberOfDays != null) {
      hiveRepetition.numberOfDays = hiveRepetition.numberOfDays! + 1;
    }
    notifyListeners();
  }

  void subtract() {
    if (hiveRepetition.numberOfDays != 0 && hiveRepetition.numberOfDays != null) {
      hiveRepetition.numberOfDays = hiveRepetition.numberOfDays! - 1;
    }
    notifyListeners();
  }

  void selectTime(DateTime time) {
    hiveRepetition.notifyTime = time;
    notifyListeners();
  }

  void tabBarChanging(int index) {
    isDailySelected = index == 0;
    notifyListeners();
  }

  void changeButtonColors(int index, HiveRepetition repeat) {
    if (repeat.weekdays![index].isSelected == false) {
      repeat.weekdays![index].isSelected = true;
    } else {
      repeat.weekdays![index].isSelected = false;
    }
    notifyListeners();
  }

  void changeReminderState(bool isChecked) {
    hiveRepetition.showNotification = isChecked;
    notifyListeners();
  }
}
