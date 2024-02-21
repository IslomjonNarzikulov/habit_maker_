import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/features/domain/repository/repository_api.dart';
import 'package:habit_maker/injection_container.dart';

import '../../data_source/local/hive_database/hive.box.dart';
import '../repository.dart';

Future<void> repositoryModule() async {
  sl.registerSingletonWithDependencies<HabitRepositoryApi>(
      () => HabitRepository(
          database: sl(), networkClient: sl(), secureStorage: sl()),
      dependsOn: [Database, FlutterSecureStorage]);
  await sl.isReady<HabitRepositoryApi>();
}
