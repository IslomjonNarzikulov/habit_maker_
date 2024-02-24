import 'package:dio/dio.dart';
import 'package:habit_maker/core/common/constants.dart';
import 'package:habit_maker/features/data/network/habit_response/habit_response.dart';
import 'package:retrofit/http.dart';
part 'habit_api_service.g.dart';

@RestApi(baseUrl: baseUrl)
abstract class HabitApiService{
  factory HabitApiService(Dio dio) = _HabitApiService;

  @POST('/v1/habits')
  Future<bool> createHabit(@Body() HabitResponse habitModel); //token

  @GET('/v1/habits')
  Future<HabitsWrapper> loadHabits();

  @DELETE('/v1/habits/{id}')
  Future<bool> deleteHabits(@Path('id') String id);

  @PUT('/v1/habits/{id}')
  Future<bool> updateHabits(@Path('id') String id,
      @Body() HabitResponse habitModel);

  @POST('/v1/activities')
  Future<ActivitiesResponse> createActivities(
      @Field('id') String id,@Field('date') String date
      );

  @DELETE('/v1/activities/{id}')
  Future<bool> deleteActivities(
      @Path('id') String id
      );
}