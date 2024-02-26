import 'package:habit_maker/features/data/network/habit_api/login_api_service/login_api_service.dart';
import 'package:habit_maker/features/data/network/models/login_response/login_response.dart';
import 'package:habit_maker/features/data/network/models/network_response/registration_response.dart';
import 'package:habit_maker/features/data/network/models/network_response/restore_response.dart';

class LoginNetworkDataSource {
  LoginApiService networkApiService;

  LoginNetworkDataSource({required this.networkApiService});

  Future<LoginResponse?> login(String email, String password) {
    return networkApiService.login(email, password);
  }

  Future<SignUpResponse?> signUp(String username, String password) {
    return networkApiService.signUp(username, password);
  }

  Future<LoginResponse?> verify(String token, String otp) {
    return networkApiService.verifyOtp(token, otp);
  }

  Future<RestorePassword> restorePassword(String emailAddress) {
    return networkApiService.restorePassword(emailAddress);
  }

  Future<LoginResponse?> refreshToken(String refreshToken) {
    return networkApiService.refreshToken(refreshToken);
  }
}
