import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/features/data/data_source/local/hive_database/hive.box.dart';
import 'package:habit_maker/features/data/repository/habit_repository/habit_repository.dart';
import 'package:habit_maker/features/data/repository/login_repository/login_repository.dart';
import 'package:habit_maker/features/domain/repository/login_repository_api.dart';
import 'package:habit_maker/features/domain/repository/repository_api.dart';
import 'package:habit_maker/injection_container.dart';

Future<void> repositoryModule() async {
  sl.registerSingletonWithDependencies<HabitRepositoryApi>(
      () => HabitRepository(
          database: sl(), networkClient: sl(), secureStorage: sl()),
      dependsOn: [Database, FlutterSecureStorage]);
  await sl.isReady<HabitRepositoryApi>();
  sl.registerSingletonWithDependencies<LoginRepositoryApi>(
      () => LoginRepository(
          database: sl(), networkClient: sl(), secureStorage: sl()),
      dependsOn: [Database, FlutterSecureStorage]);
  await sl.isReady<LoginRepositoryApi>();
}
