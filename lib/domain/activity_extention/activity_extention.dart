

import 'package:habit_maker/models/activities_model.dart';
import 'package:table_calendar/table_calendar.dart';
//wttth
extension ActivityExtention on List<Activities>{
  Activities? getTheSameDay(DateTime date){
    return where((element) => isSameDay(DateTime.parse(element.date!),date)).firstOrNull;
  }
}

extension ActivityDateExtention on List<DateTime>{
  bool isDateExist(DateTime date){
    return where((element) => isSameDay(element,date)).isNotEmpty;
  }
}