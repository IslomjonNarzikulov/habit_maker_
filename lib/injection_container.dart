import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_maker/core/common/constants.dart';
import 'package:habit_maker/features/data/data_source/local/hive_database/hive.box.dart';
import 'package:habit_maker/features/data/data_source/remote/network_client.dart';
import 'package:habit_maker/features/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/features/data/models/hive_habit_model.dart';
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
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  await initDataModule();
  await domainModule();
  await presentationModule();
}

Future<void> hiveModule() async {
  sl.registerSingletonAsync<Database>(() async {
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(HiveHabitModelAdapter());
    Hive.registerAdapter(HiveRepetitionAdapter());
    Hive.registerAdapter(HiveDayAdapter());
    Hive.registerAdapter(HiveActivitiesAdapter());

    var habitBox = await Hive.openBox<HiveHabitModel>('habitBox');
    return Database(habitBox);
  });
  await sl.isReady<Database>();
}

Future<void> networkModule() async {
  sl.registerSingleton<Dio>(Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5))));
  sl.registerSingleton<NetworkClient>(NetworkClient(dio: sl()));
}

Future<void> repositoryModule() async {
  sl.registerSingletonWithDependencies<Repository>(
          () =>
          Repository(database: sl(), networkClient: sl(), secureStorage: sl()),
      dependsOn: [Database, FlutterSecureStorage]);
  await sl.isReady<Repository>();
}

Future<void> initDataModule() async {
  await hiveModule();
  await networkModule();
  sl.registerSingletonAsync<FlutterSecureStorage>(() async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
      encryptedSharedPreferences: true,
    );
    var secureStorage = FlutterSecureStorage(aOptions: getAndroidOptions());
    var token = await secureStorage.read(key: accessToken);
    await secureStorage.write(
        key: isUserLogged, value: token == null ? "false" : "true");
    return secureStorage;
  });
  await repositoryModule();
}

Future<void> domainModule() async {
  sl.registerSingleton<HabitStateKeeper>(HabitStateKeeper());
  sl.registerSingleton<LogOutState>(LogOutState());
}

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
