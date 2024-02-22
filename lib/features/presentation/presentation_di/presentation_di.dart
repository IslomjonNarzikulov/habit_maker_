import 'package:habit_maker/features/domain/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/domain/models/network_response/log_out_state.dart';
import 'package:habit_maker/features/domain/repository/login_repository_api.dart';
import 'package:habit_maker/features/domain/repository/repository_api.dart';
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
      () => RestoreProvider(loginRepository: sl<LoginRepositoryApi>()),
      dependsOn: [HabitRepositoryApi]);
  sl.registerSingletonWithDependencies<MainProvider>(
      () => MainProvider(sl<LoginRepositoryApi>(), sl<HabitStateKeeper>(),
          sl<HabitRepositoryApi>(), sl<LogOutState>()),
      dependsOn: [HabitRepositoryApi]);
  sl.registerSingletonWithDependencies<CreateProvider>(
      () => CreateProvider(
            sl<LoginRepositoryApi>(),
            sl<LogOutState>(),
            sl<HabitRepositoryApi>(),
            sl<HabitStateKeeper>(),
          ),
      dependsOn: [HabitRepositoryApi]);
  sl.registerSingletonWithDependencies<HabitScreenProvider>(
      () => HabitScreenProvider(
            sl<LoginRepositoryApi>(),
            sl<LogOutState>(),
            sl<HabitRepositoryApi>(),
            sl<HabitStateKeeper>(),
          ),
      dependsOn: [HabitRepositoryApi]);
  sl.registerSingletonWithDependencies<ProfileProvider>(
      () => ProfileProvider(
            sl<LoginRepositoryApi>(),
            sl<LogOutState>(),
            sl<HabitRepositoryApi>(),
            sl<HabitStateKeeper>(),
          ),
      dependsOn: [HabitRepositoryApi]);
  sl.registerSingletonWithDependencies<LogInProvider>(
      () => LogInProvider(sl<LoginRepositoryApi>(), sl<LogOutState>(),
          sl<HabitRepositoryApi>(), sl<HabitStateKeeper>()),
      dependsOn: [HabitRepositoryApi]);
  sl.registerSingletonWithDependencies<HomeProvider>(
      () => HomeProvider(
            sl<LoginRepositoryApi>(),
            sl<LogOutState>(),
            sl<HabitRepositoryApi>(),
            sl<HabitStateKeeper>(),
          ),
      dependsOn: [HabitRepositoryApi]);
  sl.registerSingletonWithDependencies<SignUpProvider>(
      () => SignUpProvider(
            sl<LoginRepositoryApi>(),
          ),
      dependsOn: [HabitRepositoryApi]);
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
