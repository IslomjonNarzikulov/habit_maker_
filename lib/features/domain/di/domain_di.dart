import 'package:habit_maker/features/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/data/models/log_out_state.dart';
import 'package:habit_maker/injection_container.dart';

Future<void> domainModule() async {
  sl.registerSingleton<HabitStateKeeper>(HabitStateKeeper());
  sl.registerSingleton<LogOutState>(LogOutState());
}
