import 'package:habit_maker/features/data/network/extensions/habit_ext.dart';
import 'package:habit_maker/features/data/network/data_source/habit_api/habit_api_service/habit_api_service.dart';
import 'package:habit_maker/features/data/network/models/habit_response/habit_response.dart';
import 'package:habit_maker/features/domain/models/habit_model/habit_model.dart';

class HabitNetworkDataSource {
  ///this is bridge for network response and repository. Extensions used here .
  HabitApiService habitApi;

  HabitNetworkDataSource(this.habitApi);

  Future<bool> createHabits(HabitModel habitModel) async {
    await habitApi.createHabit(habitModel.toHabitResponse());
    return true;
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
        if (element.isDeleted == false) {
          var habitId =
              (await habitApi.createHabit(element.toHabitResponse())).id;
          if (habitId != null) {
            var sortUnSyncedActivities = element.activities
                    ?.where((element) => element.isSynced == false)
                    .toList() ??
                [];
            await Future.forEach(sortUnSyncedActivities, (activity) async {
              if (activity.isDeleted == false) {
                await habitApi.createActivities(habitId, activity.date!);
              } else if (activity.id != null) {
                await habitApi.deleteActivities(activity.id!);
              }
            });
          }
        }
      } else {
        try {
          if (element.isDeleted == false) {
            await habitApi.updateHabits(element.id!, element.toHabitResponse());
          } else {
            await habitApi.deleteHabits(element.id!);
          }
          await syncActivities(element);
        } catch (e) {
          print(e.toString());
        }
      }
    });
  }

  Future<void> syncActivities(HabitModel element) async {
    var sortUnSyncedActivities = element.activities
            ?.where((element) => element.isSynced == false)
            .toList() ??
        [];
    await Future.forEach(sortUnSyncedActivities, (activity) async {
      if (activity.isDeleted == false) {
        await habitApi.createActivities(element.id!, activity.date!);
      } else if (activity.id != null) {
        await habitApi.deleteActivities(activity.id!);
      }
    });
  }

  Future<void> deleteHabits(String id) {
    var results = habitApi.deleteHabits(id);
    return results;
  }

  Future<bool> updateHabits(String id, HabitModel habitModel) async {
    await habitApi.updateHabits(id, habitModel.toHabitResponse());
    return Future.value(true);
  }

  Future<ActivitiesResponse> createActivities(
      String habitId, String date) async {
    return await habitApi.createActivities(habitId, date);
  }

  Future<void> deleteActivities(String id) async {
    return await habitApi.deleteActivities(id);
  }
}
