import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/core/common/constants.dart';
import 'package:habit_maker/features/data/database/local/di/db_di.dart';
import 'package:habit_maker/features/data/network/di/network.di.dart';
import 'package:habit_maker/features/data/repository/di/repository_di.dart';
import 'package:habit_maker/injection_container.dart';

Future<void> initDataModule() async {
  sl.registerSingletonAsync<FlutterSecureStorage>(() async {
    AndroidOptions getAndroidOptions() => const AndroidOptions(
          encryptedSharedPreferences: true,
        );
    var secureStorage = FlutterSecureStorage(aOptions: getAndroidOptions());
    var token = await secureStorage.read(key: accessToken);
    await secureStorage.write(
        key: isUserLogged, value: token == null ? "false" : "true");
    return secureStorage;
  });
  await hiveModule();
  await networkModule();
  await repositoryModule();
}
