import 'package:habit_maker/features/data/database/habit_api_service/habit_api_service.dart';
import 'package:habit_maker/features/data/network/extensions/habit_ext.dart';
import 'package:habit_maker/features/data/network/habit_response/habit_response.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';

class HabitNetworkDataSource {
  HabitApiService habitApi;

  HabitNetworkDataSource(this.habitApi);

  Future<bool> createHabits(HabitModel habitModel) {
    try{
    var result = habitApi.createHabit(habitModel.toHabitResponse());
    }catch(e){
      e.toString();
    }
    return Future.value(false);
  }

  Future<List<HabitModel>> loadHabits() async {
    return (await habitApi.loadHabits())
        .habits!
        .map((e) => e.toHabitModel())
        .toList();
  }

  Future<bool> deleteHabits(String id) {
    var results = habitApi.deleteHabits(id);
    return results;
  }

  Future<bool> updateHabits(String id, HabitModel habitModel) {
    var result = habitApi.updateHabits(
       id, habitModel.toHabitResponse());
    return result;
  }

  Future<ActivitiesResponse> createActivities(String habitId, String date) {
    return habitApi.createActivities(habitId, date);
  }

  Future<bool> deleteActivities(String id) {
    var result = habitApi.deleteHabits(id);
    return result;
  }
}
