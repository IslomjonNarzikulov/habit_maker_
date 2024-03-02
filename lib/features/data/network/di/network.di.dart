import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/features/data/network/data_source/habit_network_source.dart';
import 'package:habit_maker/features/data/network/data_source/login_network_source.dart';
import 'package:habit_maker/features/data/network/data_source/habit_api/habit_api_service/habit_api_service.dart';
import 'package:habit_maker/features/data/network/data_source/habit_api/login_api_service/login_api_service.dart';
import 'package:habit_maker/features/data/network/remote/dio_interceptor/dio_interceptor.dart';
import 'package:habit_maker/injection_container.dart';

Future<void> networkModule() async {
  sl.registerSingleton<Dio>(
    Dio(
      BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5)),
    ),
  );
  sl.registerSingleton<LoginApiService>(LoginApiService(sl()));
  sl.registerSingleton<HabitApiService>(HabitApiService(sl()));
  sl.registerSingleton<HabitNetworkDataSource>(HabitNetworkDataSource(sl()));
  sl.registerSingleton<LoginNetworkDataSource>(LoginNetworkDataSource(networkApiService: sl()));
  sl.registerSingletonWithDependencies<CustomInterceptors>(
      () => CustomInterceptors(sl(), sl(), sl()),
      dependsOn: [FlutterSecureStorage]);
  await sl.isReady<CustomInterceptors>();
  sl<Dio>().interceptors.add(sl<CustomInterceptors>());
}
