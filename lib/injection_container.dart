import 'package:get_it/get_it.dart';
import 'features/data/database/di/data_di.dart';
import 'features/domain/di/domain_di.dart';
import 'features/presentation/presentation_di/presentation_di.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  await initDataModule();
  await domainModule();
  await presentationModule();
}




