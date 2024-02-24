import 'package:habit_maker/core/common/extension.dart';
import 'package:habit_maker/features/data/network/habit_response/habit_response.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';

extension DayExt on DayResponse{
  Day toDay() {
    return Day(
      isSelected: isSelected,
      weekday: weekday,
    );
  }
}

extension DayModelExt on Day{
  DayResponse toDayResponse() {
    return DayResponse(
      weekday: weekday,
      isSelected: isSelected,
    );
  }
}///why ???