import 'package:habit_maker/features/data/network/extensions/habit_ext.dart';
import 'package:habit_maker/features/data/network/habit_api/habit_api_service/habit_api_service.dart';
import 'package:habit_maker/features/data/network/models/habit_response/habit_response.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';

class HabitNetworkDataSource {
  ///this is bridge for network response and repository. Extensions used here .
  HabitApiService habitApi;

  HabitNetworkDataSource(this.habitApi);

  Future<bool> createHabits(HabitModel habitModel) {
    try {
      var result = habitApi.createHabit(habitModel.toHabitResponse());
    } catch (e) {
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

  Future<void> syncHabits(List<HabitModel> habits) async {
    await Future.forEach(habits, (element) async {
      if (element.id == null) {
        var habitId =
            (await habitApi.createHabit(element.toHabitResponse())).id;
        if (habitId != null) {
          await Future.forEach(element.activities ?? <Activities>[],
                  (activity) async {
                await habitApi.createActivities(habitId, activity.date!);
              });
        }
      } else {
        await Future.forEach(element.activities ?? <Activities>[],
                (activity) async {
              await habitApi.createActivities(element.id!, activity.date!);
            });
      }
    });
  }

  Future<bool> deleteHabits(String id) {
    var results = habitApi.deleteHabits(id);
    return results;
  }

  Future<bool> updateHabits(String id, HabitModel habitModel) {
    var result = habitApi.updateHabits(id, habitModel.toHabitResponse());
    return result;
  }

  Future<ActivitiesResponse> createActivities(String habitId, String date) async{
    return await habitApi.createActivities(habitId, date);
  }

  Future<void> deleteActivities(String id) async {
      return await habitApi.deleteActivities(id);

  }
}
