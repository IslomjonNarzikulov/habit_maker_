import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:habit_maker/features/data/data_source/remote/network_client.dart';
import 'package:habit_maker/features/data/models/habit_model.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies()async{
  sl.registerLazySingleton<Dio>(() => Dio());

  sl.registerLazySingleton<HabitModel>(() => HabitModel());

  sl.registerLazySingleton<NetworkClient>(() => NetworkClient(dio: Dio()));
}