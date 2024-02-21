import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_maker/features/presentation/habit_screen/habit_screen_provider.dart';
import 'package:habit_maker/features/presentation/profile_screen/profile_provider.dart';
import 'package:habit_maker/features/presentation/theme_screen/theme_provider.dart';
import 'package:habit_maker/injection_container.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'core/resources/router.dart';
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

  // dio.interceptors.add(CustomInterceptors(sl(), dio));
  final sl = GetIt.instance;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: sl<RestoreProvider>()),
        ChangeNotifierProvider.value(value: sl<MainProvider>()),
        ChangeNotifierProvider.value(value: sl<CreateProvider>()),
        ChangeNotifierProvider.value(value: sl<HabitScreenProvider>()),
        ChangeNotifierProvider.value(value: sl<ProfileProvider>()),
        ChangeNotifierProvider.value(value: sl<LogInProvider>()),
        ChangeNotifierProvider.value(value: sl<SignUpProvider>()),
        ChangeNotifierProvider.value(value: sl<ThemeProvider>()),
        ChangeNotifierProvider.value(value: sl<HomeProvider>())
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
