import 'package:dio/dio.dart';
import 'package:habit_maker/features/data/data_source/remote/network_client.dart';
import 'package:habit_maker/injection_container.dart';

import '../dio_interceptor/dio_interceptor.dart';

Future<void> networkModule() async {
  sl.registerSingleton<Dio>(Dio(BaseOptions(
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 5))));
  sl.registerSingleton<NetworkClient>(NetworkClient(dio: sl()));
  sl.registerLazySingleton(() => CustomInterceptors(sl(), sl()));
}