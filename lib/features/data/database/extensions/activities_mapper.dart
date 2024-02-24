
import 'package:habit_maker/features/data/database/db_habit_model/db_habit_model.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';

extension ActivitiesToHive on Activities {
  HiveActivities toHiveActivities() {
    return HiveActivities(
        id: id,
        date: date,
        isSynced: isSynced ?? false,
        isDeleted: isDeleted ?? false);
  }
}

extension HivetoActivities on HiveActivities {
  Activities toActivities() {
    return Activities(
      isDeleted: isDeleted,
      isSynced: isSynced,
      id: id,
      date: date,
    );
  }
}
