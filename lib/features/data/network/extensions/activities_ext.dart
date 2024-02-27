import 'package:habit_maker/features/data/network/models/habit_response/habit_response.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';

extension ActivityModelExt on Activities {
  ActivitiesResponse toActivitiesResponse() {
    return ActivitiesResponse(
      date: date,
      id: id,
      habitId: null,
    );
  }
}

extension Activity on ActivitiesResponse {
  Activities toActivities() {
    return Activities(
      id: id,
      date: date,
      habitId: habitId,
    );
  }
}
