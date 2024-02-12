import 'package:habit_maker/models/habit_model.dart';

enum WeekDay { MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY }

final defaultRepeat = [
  Day(weekday: WeekDay.MONDAY, isSelected: false),
  Day(weekday: WeekDay.TUESDAY, isSelected: false),
  Day(weekday: WeekDay.WEDNESDAY, isSelected: false),
  Day(weekday: WeekDay.THURSDAY, isSelected: false),
  Day(weekday: WeekDay.FRIDAY, isSelected: false),
  Day(weekday: WeekDay.SATURDAY, isSelected: false),
  Day(weekday: WeekDay.SUNDAY, isSelected: false),
];

extension NormalDay on WeekDay {
  String get name {
    switch (this) {
      case WeekDay.MONDAY:
        return 'MONDAY';
      case WeekDay.TUESDAY:
        return 'TUESDAY';
      case WeekDay.WEDNESDAY:
        return 'WEDNESDAY';
      case WeekDay.THURSDAY:
        return 'THURSDAY';
      case WeekDay.FRIDAY:
        return 'FRIDAY';
      case WeekDay.SATURDAY:
        return 'SATURDAY';
      case WeekDay.SUNDAY:
        return 'SUNDAY';
      default:
        return 'Unknown';
    }
  }
}

extension ReverseDay on String {
  WeekDay weekDayFromName() {
    switch (this) {
      case 'MONDAY':
        return WeekDay.MONDAY;
      case 'TUESDAY':
        return WeekDay.TUESDAY;
      case 'WEDNESDAY':
        return WeekDay.WEDNESDAY;
      case 'THURSDAY':
        return WeekDay.THURSDAY;
      case 'FRIDAY':
        return WeekDay.FRIDAY;
      case 'SATURDAY':
        return WeekDay.SATURDAY;
      case 'SUNDAY':
        return WeekDay.SUNDAY;
      default:
        return WeekDay.MONDAY;
    }
  }
}

extension DisplayDateFormat on DateTime {
  String toHHMM() {
    String hours = this.hour.toString().padLeft(2, '0');
    String minutes = this.minute.toString().padLeft(2, '0');
    return "$hours:$minutes";
  }
}
