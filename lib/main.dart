import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/arch_provider/arch_provider.dart';
import 'package:habit_maker/common/constants.dart';
import 'package:habit_maker/data/database/db_helper.dart';
import 'package:habit_maker/data/habit_keeper/habit_keeper.dart';
import 'package:habit_maker/data/network_client/network_client.dart';
import 'package:habit_maker/data/repository/repository.dart';
import 'package:habit_maker/domain/interceptor/dio_interceptor.dart';
import 'package:habit_maker/models/log_out_state.dart';
import 'package:habit_maker/ui/create_habit/create_provider.dart';
import 'package:habit_maker/ui/habit_details/habit_screen_provider.dart';
import 'package:habit_maker/ui/login/login_provider.dart';
import 'package:habit_maker/ui/main_provider.dart';
import 'package:habit_maker/ui/profile/profile_provider.dart';
import 'package:habit_maker/ui/signup/restore_provider.dart';
import 'package:habit_maker/ui/signup/signup_provider.dart';
import 'package:habit_maker/ui/theme_data/theme_provider.dart';

import 'package:provider/provider.dart';

import 'UI/splash_screen/splash_screen.dart';

void configureDioForProxy(Dio dio) {
  (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
      (client) {
    client.findProxy = (uri) {
      // Replace localhost and 8888 with your proxy IP and port
      return 'PROXY 192.168.100.3:8888';
    };
    return client;
  };
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  var secureStorage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  var token = await secureStorage.read(key: accessToken);
  await secureStorage.write(
      key: isUserLogged, value: token == null ? "false" : "true");
  final dbHelper = DBHelper();
  final keeper=HabitStateKeeper();
  final dio = Dio();
  dio.options.connectTimeout = const Duration(seconds: 5);
  dio.options.receiveTimeout = const Duration(seconds: 5);

  final networkClient = NetworkClient(dio: dio);
  final repository = Repository(
      dbHelper: dbHelper,
      networkClient: networkClient,
      secureStorage: secureStorage);

  dio.interceptors.add(CustomInterceptors(repository, dio));
  final logOutState = LogOutState();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_)=>RestoreProvider(repository: repository)),
        ChangeNotifierProvider(
            create: (_) => MainProvider(keeper,logOutState,repository,)),
        ChangeNotifierProvider(
            create: (_) => CreateProvider(logOutState,repository,keeper)),
        ChangeNotifierProvider(create:(_)=> HabitPage(logOutState,repository,keeper)),
        ChangeNotifierProvider(create: (_) => ProfileProvider(secureStorage)),
        ChangeNotifierProvider(
            create: (_) => SignInProvider(logOutState,repository,keeper)),
        ChangeNotifierProvider(create: (_) => SignUpProvider(repository)),
        ChangeNotifierProvider(create: (_)=> ThemeProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme:Provider.of<ThemeProvider>(context).themeData,
      home: const SplashScreen(),
    );
  }
}
