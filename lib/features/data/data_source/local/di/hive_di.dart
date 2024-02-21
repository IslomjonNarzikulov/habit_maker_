import 'package:habit_maker/features/data/data_source/local/hive_database/hive.box.dart';
import 'package:habit_maker/features/data/models/hive_habit_model.dart';
import 'package:habit_maker/injection_container.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> hiveModule() async {
  sl.registerSingletonAsync<Database>(() async {
    var directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    Hive.registerAdapter(HiveHabitModelAdapter());
    Hive.registerAdapter(HiveRepetitionAdapter());
    Hive.registerAdapter(HiveDayAdapter());
    Hive.registerAdapter(HiveActivitiesAdapter());

    var habitBox = await Hive.openBox<HiveHabitModel>('habitBox');
    return Database(habitBox);
  });
  await sl.isReady<Database>();
}
