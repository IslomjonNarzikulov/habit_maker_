import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/models/habit_model.dart';
import 'package:habit_maker/models/hive_habit_model.dart';
import 'package:habit_maker/presentation/create_screen/create_habit.dart';
import 'package:habit_maker/presentation/habit_screen/habit_screen.dart';
import 'package:habit_maker/presentation/home/home.dart';
import 'package:habit_maker/presentation/home/provider/logout_provider.dart';
import 'package:habit_maker/presentation/login/loginScreen.dart';
import 'package:habit_maker/presentation/otp_screen/otp_screen.dart';
import 'package:habit_maker/presentation/profile/profile.dart';
import 'package:habit_maker/presentation/restore_password/restore_password.dart';
import 'package:habit_maker/presentation/settings/settings.dart';
import 'package:habit_maker/presentation/signup/signUp.dart';
import 'package:habit_maker/presentation/splash_screen/splash_screen.dart';
import 'package:provider/provider.dart';

final GoRouter router =
    GoRouter(initialLocation: '/splash', routes: <RouteBase>[
  GoRoute(
      path: '/splash',
      onExit: (context) {
        context.pushReplacement('/home');
        return true;
      },
         builder: (BuildContext context, GoRouterState state) {
        return  const SplashScreen();
      }),
  GoRoute(
      path: '/home',
      builder: (BuildContext context, GoRouterState state) {
        return HomeScreen();
      },
      routes: <RouteBase>[
        GoRoute(
            path: 'profile',
            builder: (BuildContext context, GoRouterState state) {
              return ProfilePage();
            }),
        GoRoute(
            path: 'settings',
            builder: (BuildContext context, GoRouterState state) {
              return SettingPage();
            }),
        GoRoute(
            path: 'calendar',
            builder: (BuildContext context, GoRouterState state) {
              final habitModel = state.extra as HabitModel;
              return HabitScreen(habitModel: habitModel);
            }),
        GoRoute(
          path: 'create',
          builder: (BuildContext context, GoRouterState state) {
            final habitModel = state.extra as HiveHabitModel?;
            return CreateScreen(hiveHabitModel: habitModel);
          },
        ),
      ]),
  GoRoute(
      path: '/login',
      builder: (BuildContext context, GoRouterState state) {
        return LogInScreen();
      },
      routes: [
        GoRoute(
            path: 'signUp',
            builder: (BuildContext context, GoRouterState state) {
              return SignUp();
            }),
        GoRoute(
            path: 'verify',
            builder: (BuildContext context, GoRouterState state) {
              return OtpPage();
            }),
        GoRoute(
            path: 'restore',
            builder: (BuildContext context, GoRouterState state) {
              return RestorePassword();
            })
      ])
]);
