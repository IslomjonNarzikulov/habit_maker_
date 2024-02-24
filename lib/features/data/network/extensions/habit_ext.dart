import 'package:habit_maker/features/data/network/extensions/activities_ext.dart';
import 'package:habit_maker/features/data/network/extensions/repetition_ext.dart';
import 'package:habit_maker/features/data/network/habit_response/habit_response.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';

extension HabitModelExt on HabitModel{
  HabitResponse toHabitResponse(){
    return HabitResponse(
      id: id,
      title: title,
      color: color.toString(),
      repetition: repetition?.toRepetitionResponse(),
      activities: activities?.map((e) => e.toActivitiesResponse()).toList(),
    );
  }
}

extension HabitResponseExt on HabitResponse{
  HabitModel toHabitModel(){
    return HabitModel(
      id: id,
      title: title,
      color: int.parse('$color'),
      repetition: repetition?.toRepetition(),
      activities: activities?.map((activities) => activities.toActivities()).toList(),
    );
  }
}

