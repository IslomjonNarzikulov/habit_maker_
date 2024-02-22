import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/features/data/database/data_source/remote/dio_interceptor/dio_interceptor.dart';
import 'package:habit_maker/features/data/database/data_source/remote/network_client.dart';
import 'package:habit_maker/injection_container.dart';

Future<void> networkModule() async {
  sl.registerSingleton<Dio>(
    Dio(
      BaseOptions(
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5)),
    ),
  );
  sl.registerSingleton<NetworkClient>(NetworkClient(dio: sl()));
  sl.registerSingletonWithDependencies<CustomInterceptors>(
      () => CustomInterceptors(sl(), sl(), sl()),
      dependsOn: [FlutterSecureStorage]);
  await sl.isReady<CustomInterceptors>();
  sl<Dio>().interceptors.add(sl<CustomInterceptors>());
}
