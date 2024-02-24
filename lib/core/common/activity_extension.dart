import 'package:habit_maker/features/data/database/db_habit_model/db_habit_model.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';
import 'package:table_calendar/table_calendar.dart';

//wttth
extension ActivityExtention on List<Activities> {
  Activities? getTheSameDay(DateTime date) {
    return where((element) => isSameDay(DateTime.parse(element.date!), date))
        .firstOrNull;
  }
}

extension ActivityDateExtention on List<DateTime> {
  bool isDateExist(DateTime date) {
    return where((element) => isSameDay(element, date)).isNotEmpty;
  }
}

extension ActivityExtension on List<HiveActivities> {
  HiveActivities? getTheSameDay(DateTime dateTime) {
    return where(
            (element) => isSameDay(DateTime.parse(element.date!), dateTime))
        .firstOrNull;
  }
}
