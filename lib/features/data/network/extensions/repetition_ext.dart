import 'package:habit_maker/features/data/network/extensions/day_ext.dart';
import 'package:habit_maker/features/data/network/habit_response/habit_response.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';

extension RepetitionExt on RepetitionResponse{
  Repetition toRepetition() {
    return Repetition(
      weekdays: weekdays?.map((day) => day.toDay()).toList(),
      showNotification: showNotification,
      numberOfDays: numberOfDays,
      notifyTime: notifyTime!=null&&notifyTime!=""? _formatHHMMtoDateTime(notifyTime!):null,
    );
  }
  DateTime _formatHHMMtoDateTime(String date) {
    List<String> parts = date.split(':');
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1]);

    DateTime now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

extension RepetitionResponseExt on Repetition{
  RepetitionResponse toRepetitionResponse() {
    return RepetitionResponse(
      showNotification: showNotification,
      weekdays: weekdays?.map((day) => day.toDayResponse()).toList(),
      numberOfDays: numberOfDays,
      notifyTime: notifyTime!=null? _formatDateTimeToHHMM(notifyTime!):null,
    );
  }
  String _formatDateTimeToHHMM(DateTime dateTime) {
    String hour = dateTime.hour.toString().padLeft(2, '0');
    String minute = dateTime.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}