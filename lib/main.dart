import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/features/data/data_source/remote/network_client.dart';
import 'package:habit_maker/features/data/repository/repository.dart';
import 'package:habit_maker/features/data/data_source/remote/dio_interceptor/dio_interceptor.dart';
import 'package:habit_maker/features/presentation/habit_screen/habit_screen_provider.dart';
import 'package:habit_maker/features/presentation/profile_screen/profile_provider.dart';
import 'package:habit_maker/features/presentation/theme_screen/theme_provider.dart';
import 'package:habit_maker/injection_container.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'core/common/constants.dart';
import 'core/resources/router.dart';
import 'features/data/habit_keeper/habit_keeper.dart';
import 'features/data/data_source/local/hive_database/hive.box.dart';
import 'features/data/models/hive_habit_model.dart';
import 'features/data/models/log_out_state.dart';
import 'features/presentation/create_screen/create_provider.dart';
import 'features/presentation/home/home_provider.dart';
import 'features/presentation/login_screen/login_provider.dart';
import 'features/presentation/main_provider.dart';
import 'features/presentation/restore_password/restore_provider.dart';
import 'features/presentation/sign_up_screen/signup_provider.dart';

void configureDioForProxy(Dio dio) {
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (client) {
    client.findProxy = (uri) {
      return 'PROXY 192.168.100.3:8888';
    };
    return client;
  };
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDependencies();
  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation('Asia/Tashkent')); // Set your timezone
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  var directory = await getApplicationDocumentsDirectory();
  Hive.init(directory.path);
  Hive.registerAdapter(HiveHabitModelAdapter());
  Hive.registerAdapter(HiveRepetitionAdapter());
  Hive.registerAdapter(HiveDayAdapter());
  Hive.registerAdapter(HiveActivitiesAdapter());

  var habitBox = await Hive.openBox<HiveHabitModel>('habitBox');
  var secureStorage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  var token = await secureStorage.read(key: accessToken);
  await secureStorage.write(
      key: isUserLogged, value: token == null ? "false" : "true");
  final keeper = HabitStateKeeper();
  final dio = Dio();
  final database = Database(habitBox);
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 5);

  final networkClient = NetworkClient(dio: dio);
  final repository = Repository(
      database: database,
      networkClient: networkClient,
      secureStorage: secureStorage);

  dio.interceptors.add(CustomInterceptors(repository, dio));
  final logOutState = LogOutState();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => RestoreProvider(repository: repository)),
        ChangeNotifierProvider(
            create: (_) => MainProvider(
                  keeper,
                  logOutState,
                  repository,
                )),
        ChangeNotifierProvider(
            create: (_) => CreateProvider(logOutState, repository, keeper)),
        ChangeNotifierProvider(
            create: (_) => HabitPage(logOutState, repository, keeper)),
        ChangeNotifierProvider(create: (_) => ProfileProvider(logOutState,repository,keeper)),
        ChangeNotifierProvider(
            create: (_) => LogInProvider(logOutState, repository, keeper)),
        ChangeNotifierProvider(create: (_) => SignUpProvider(repository)),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(logOutState, repository, keeper),
        )
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: router,
      theme: Provider.of<ThemeProvider>(context).themeData,
      debugShowCheckedModeBanner: false,
    );
  }
}
