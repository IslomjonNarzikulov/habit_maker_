
import 'package:habit_maker/features/data/network/models/login_response/login_response.dart';

abstract class LoginRepositoryApi {
  Future<bool> signIn(String email, String password);

  Future<bool> signUp(String username, String password);

  Future<bool> verify(String otp);

  Future<void> refreshUserToken();

  Future<String?> getUserFirstName();

  Future<String?> getUserLastName();

  Future<String?> getUserEmail();

  Future<bool> restorePassword(String emailAddress);

  Future<String?> userRefreshToken();

  Future<void> saveUserCredentials(LoginResponse user);

  Future<bool> isLogged();

  Future<void> logout();
}
