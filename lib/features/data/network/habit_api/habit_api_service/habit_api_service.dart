import 'package:dio/dio.dart';
import 'package:habit_maker/core/common/constants.dart';
import 'package:habit_maker/features/data/network/models/create_habit_response/create_habit_response.dart';
import 'package:habit_maker/features/data/network/models/habit_response/habit_response.dart';
import 'package:retrofit/http.dart';

part 'habit_api_service.g.dart';

/// This is  similar to network client which we used with http request. It is used with retrofit and dio for clean code.
@RestApi(baseUrl: baseUrl)
abstract class HabitApiService {
  factory HabitApiService(Dio dio) = _HabitApiService;

  @POST('/v1/habits')
  Future<CreateHabitResponse> createHabit(@Body() HabitResponse habitModel); //token

  @GET('/v1/habits')
  Future<HabitsWrapper> loadHabits();

  @DELETE('/v1/habits/{id}')
  Future<bool> deleteHabits(@Path('id') String id);

  @PUT('/v1/habits/{id}')
  Future<CreateHabitResponse> updateHabits(
      @Path('id') String id, @Body() HabitResponse habitModel);

  @POST('/v1/activities')
    Future<ActivitiesResponse> createActivities(
      @Field('habitId') String habitId, @Field('date') String date);

  @DELETE('/v1/activities/{id}')
  Future<void> deleteActivities(@Path('id') String id);
}
