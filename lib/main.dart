import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/common/constants.dart';
import 'package:habit_maker/data/database/db_helper.dart';
import 'package:habit_maker/data/network_client/network_client.dart';
import 'package:habit_maker/data/repository/repository.dart';
import 'package:habit_maker/models/log_out_state.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:habit_maker/provider/profile_provider.dart';
import 'package:habit_maker/ui/login/sign_in_provider.dart';
import 'package:habit_maker/ui/signup/signup_provider.dart';
import 'package:provider/provider.dart';
import 'UI/splash_screen/splash_screen.dart';


Future <void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  var secureStorage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  var token = await secureStorage.read(key: accessToken);
  await secureStorage.write(key: isUserLogged, value: token == null ? "false" : "true");
  final dbHelper = DBHelper();
  final logOutState = LogOutState();
  final networkClient = NetworkClient();
  final repository = Repository(
      dbHelper: dbHelper,
      networkClient: networkClient,
      secureStorage: secureStorage);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider(repository,logOutState,secureStorage)),
        ChangeNotifierProvider(create: (_) => ProfileProvider(secureStorage)),
        ChangeNotifierProvider(create: (_) => SignInProvider(repository,secureStorage)),
        ChangeNotifierProvider(create: (_)=> SignUpProvider(repository)),
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
      theme: FlexThemeData.light(scheme: FlexScheme.cyanM3),
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.cyanM3),
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
