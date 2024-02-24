import 'package:habit_maker/features/data/network/login_api_service/login_api_service.dart';
import 'package:habit_maker/features/data/network/login_response/login_response.dart';
import 'package:habit_maker/features/data/network/network_response/registration_response.dart';
import 'package:habit_maker/features/data/network/network_response/restore_response.dart';

class LoginNetworkDataSource {
  LoginApiService networkApiService;

  LoginNetworkDataSource({required this.networkApiService});

  Future<LoginResponse?> login(String email, String password) {
    return networkApiService.login(email, password);
  }

  Future<SignUpResponse?> signUp(String email, String password) {
    return networkApiService.signUp(email, password);
  }

  Future<LoginResponse?> verify(String otp, String token) {
    return networkApiService.verifyOtp(token, otp);
  }

  Future<RestorePassword> restorePassword(String emailAddress) {
    return networkApiService.restorePassword(emailAddress);
  }

  Future<LoginResponse?> refreshToken(String refreshToken) {
    return networkApiService.refreshToken(refreshToken);
  }
}