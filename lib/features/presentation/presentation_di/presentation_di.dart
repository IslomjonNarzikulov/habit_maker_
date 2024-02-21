import 'package:habit_maker/features/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/data/models/log_out_state.dart';
import 'package:habit_maker/features/data/repository/repository.dart';
import 'package:habit_maker/features/presentation/create_screen/create_provider.dart';
import 'package:habit_maker/features/presentation/habit_screen/habit_screen_provider.dart';
import 'package:habit_maker/features/presentation/home/home_provider.dart';
import 'package:habit_maker/features/presentation/login_screen/login_provider.dart';
import 'package:habit_maker/features/presentation/main_provider.dart';
import 'package:habit_maker/features/presentation/profile_screen/profile_provider.dart';
import 'package:habit_maker/features/presentation/restore_password/restore_provider.dart';
import 'package:habit_maker/features/presentation/sign_up_screen/signup_provider.dart';
import 'package:habit_maker/features/presentation/theme_screen/theme_provider.dart';
import 'package:habit_maker/injection_container.dart';

Future<void> presentationModule() async {
  sl.registerSingletonWithDependencies<RestoreProvider>(
          () => RestoreProvider(repository: sl<Repository>()),
      dependsOn: [Repository]);
  sl.registerSingletonWithDependencies<MainProvider>(
          () => MainProvider(
        sl<HabitStateKeeper>(),
        sl<Repository>(),
        sl<LogOutState>(),
      ),
      dependsOn: [Repository]);
  sl.registerSingletonWithDependencies<CreateProvider>(
          () => CreateProvider(
        sl<LogOutState>(),
        sl<Repository>(),
        sl<HabitStateKeeper>(),
      ),
      dependsOn: [Repository]);
  sl.registerSingletonWithDependencies<HabitScreenProvider>(
          () => HabitScreenProvider(
        sl<LogOutState>(),
        sl<Repository>(),
        sl<HabitStateKeeper>(),
      ),
      dependsOn: [Repository]);
  sl.registerSingletonWithDependencies<ProfileProvider>(
          () => ProfileProvider(
        sl<LogOutState>(),
        sl<Repository>(),
        sl<HabitStateKeeper>(),
      ),
      dependsOn: [Repository]);
  sl.registerSingletonWithDependencies<LogInProvider>(
          () => LogInProvider(
        sl<LogOutState>(),
        sl<Repository>(),
        sl<HabitStateKeeper>(),
      ),
      dependsOn: [Repository]);
  sl.registerSingletonWithDependencies<HomeProvider>(
          () => HomeProvider(
        sl<LogOutState>(),
        sl<Repository>(),
        sl<HabitStateKeeper>(),
      ),
      dependsOn: [Repository]);
  sl.registerSingletonWithDependencies<SignUpProvider>(
          () => SignUpProvider(
        sl<Repository>(),
      ),
      dependsOn: [Repository]);
  sl.registerSingleton(ThemeProvider());
  await sl.isReady<RestoreProvider>();
  await sl.isReady<MainProvider>();
  await sl.isReady<CreateProvider>();
  await sl.isReady<HabitScreenProvider>();
  await sl.isReady<ProfileProvider>();
  await sl.isReady<LogInProvider>();
  await sl.isReady<SignUpProvider>();
  await sl.isReady<HomeProvider>();
}
