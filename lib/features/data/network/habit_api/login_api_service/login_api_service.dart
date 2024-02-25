import 'package:dio/dio.dart';
import 'package:habit_maker/features/data/network/models/network_response/registration_response.dart';
import 'package:habit_maker/features/data/network/models/network_response/restore_response.dart';
import 'package:retrofit/http.dart';

import '../../models/login_response/login_response.dart';
part 'login_api_service.g.dart';

@RestApi(baseUrl: 'http://38.242.252.210:6001')
abstract class LoginApiService {
  factory LoginApiService(Dio dio) = _LoginApiService;

  @POST('/v1/auth/login')
  Future<LoginResponse?> login(@Field('email') String email,
      @Field('password') String password);

  @POST('/v1/auth/registration/otp')
  Future<SignUpResponse?> signUp(@Field('email') String email,
      @Field('password') String password);

  @POST('/v1/auth/refresh-token')
  Future<LoginResponse?> refreshToken(
      @Field('refreshToken') String refreshToken);

  @POST('/v1/auth/registration/verify')
  Future<LoginResponse?> verifyOtp(@Field('token') String token,
      @Field('otp') String otp);
  
  @POST('/v1/auth/restore/generate-link')
  Future<RestorePassword> restorePassword(
      @Field('emailAddress') String emailAddress
      );


}
