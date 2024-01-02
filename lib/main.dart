import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/data/database/db_helper.dart';
import 'package:habit_maker/data/network_client/network_client.dart';
import 'package:habit_maker/data/repository/repository.dart';
import 'package:habit_maker/login/sign_in_provider.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:habit_maker/provider/profile_provider.dart';
import 'package:provider/provider.dart';
import 'UI/splash_screen/splash_screen.dart';


void main() async {
  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  var secureStorage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  final dbHelper = DBHelper();
  final networkClient = NetworkClient();
  final repository = Repository(
      dbHelper: dbHelper,
      networkClient: networkClient,
      secureStorage: secureStorage);
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider(repository)),
        ChangeNotifierProvider(create: (_) => ProfileProvider(secureStorage)),
        ChangeNotifierProvider(create: (_) => SignInProvider(repository)),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: FlexThemeData.light(scheme: FlexScheme.cyanM3),
      // The Mandy red, dark theme.
      darkTheme: FlexThemeData.dark(scheme: FlexScheme.cyanM3),
      // Use dark or light theme based on system setting.
      themeMode: ThemeMode.system,
      home: const SplashScreen(),
    );
  }
}
