import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/provider/profile_provider.dart';
import 'package:habit_maker/login/signIn.dart';
import 'package:habit_maker/login/sign_in_controller.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:provider/provider.dart';

var kDarkColorScheme = ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 5, 99, 125),
    brightness: Brightness.dark);

void main() async {

  AndroidOptions _getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );
  var secureStorage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HabitProvider(secureStorage)),
        ChangeNotifierProvider(create: (_) => ProfileProvider(secureStorage)),
        ChangeNotifierProvider(create: (_) => SignInController(secureStorage)),
      ],
      child: MyApp(),
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
      darkTheme: ThemeData.dark()
          .copyWith(useMaterial3: true, colorScheme: kDarkColorScheme),
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: kDarkColorScheme,
        useMaterial3: true,
      ),
      home: SignInPage(),
    );
  }
}


