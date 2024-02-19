import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:habit_maker/features/data/models/habit_model.dart';
import 'package:habit_maker/features/presentation/create_screen/create_habit.dart';
import 'package:habit_maker/features/presentation/habit_screen/habit_screen.dart';
import 'package:habit_maker/features/presentation/home/home.dart';
import 'package:habit_maker/features/presentation/login_screen/log_in_screen.dart';
import 'package:habit_maker/features/presentation/otp_screen/otp_screen.dart';
import 'package:habit_maker/features/presentation/profile_screen/profile.dart';
import 'package:habit_maker/features/presentation/restore_password/restore_password.dart';
import 'package:habit_maker/features/presentation/settings_screen/settings.dart';
import 'package:habit_maker/features/presentation/sign_up_screen/sign_up.dart';
import 'package:habit_maker/features/presentation/splash_screen/splash_screen.dart';
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
              return ProfileScreen();
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
            final habitModel = state.extra as HabitModel?;
            return CreateScreen(habitModel: habitModel);
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
