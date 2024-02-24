import 'package:habit_maker/features/domain/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/data/network/network_response/log_out_state.dart';
import 'package:habit_maker/injection_container.dart';

Future<void> domainModule() async {
  sl.registerSingleton<HabitStateKeeper>(HabitStateKeeper());
  sl.registerSingleton<LogOutState>(LogOutState());
}
