import 'package:habit_maker/arch_provider/arch_provider.dart';
import 'package:habit_maker/features/domain/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';
import 'package:habit_maker/features/data/network/models/network_response/log_out_state.dart';
import 'package:habit_maker/features/domain/repository/login_repository_api.dart';
import 'package:habit_maker/features/domain/repository/habit_repository_api.dart';

class CreateProvider extends BaseProvider {
  int selectedColorIndex = 0;
  var isDailySelected = true;
  late Repetition repetition;

  CreateProvider(LoginRepositoryApi loginRepository, LogOutState logOutState,
      HabitRepositoryApi habitRepository, HabitStateKeeper keeper)
      : super(
          loginRepository,
          keeper,
          habitRepository,
          logOutState,
        );

  void selectColor(int index) {
    selectedColorIndex = index;
    notifyListeners();
  }

  void createHabit(HabitModel habitModel) async {
    await habitRepository.createHabits(habitModel, isDailySelected);
    await loadHabits();
    notifyListeners();
  }

  void updateHabits(HabitModel model) async {
    await habitRepository.updateHabits(model, isDailySelected);
    await loadHabits();
    notifyListeners();
  }

  void add() {
    if (repetition.numberOfDays != 7 && repetition.numberOfDays != null) {
      repetition.numberOfDays = repetition.numberOfDays! + 1;
    }
    notifyListeners();
  }

  void subtract() {
    if (repetition.numberOfDays != 0 && repetition.numberOfDays != null) {
      repetition.numberOfDays = repetition.numberOfDays! - 1;
    }
    notifyListeners();
  }

  void selectTime(DateTime time) {
    repetition.notifyTime = time;
    notifyListeners();
  }

  void tabBarChanging(int index) {
    isDailySelected = index == 0;
    notifyListeners();
  }

  void changeButtonColors(int index, Repetition repeat) {
    if (repeat.weekdays![index].isSelected == false) {
      //setstate alternative
      repeat.weekdays![index].isSelected = true;
    } else {
      repeat.weekdays![index].isSelected = false;
    }
    notifyListeners();
  }

  void changeReminderState(bool isChecked) {
    repetition.showNotification = isChecked;
    notifyListeners();
  }
}
