import 'package:habit_maker/features/data/models/habit_model.dart';
import 'package:habit_maker/features/data/models/login_response.dart';

abstract class HabitRepositoryApi {
  Future<void> createHabits(HabitModel habitModel, bool isDailySelected);

  Future<bool> updateHabits(HabitModel habitModel, bool isDailySelected);

  Future<List<HabitModel>> loadHabits();

  Future<void> createActivity(HabitModel model, List<DateTime> date);

  Future<void> deleteActivity(HabitModel model, List<DateTime> date);

  Future<void> deleteHabits(HabitModel model);

  Future<bool> signIn(String email, String password);

  Future<bool> signUp(String username, String password);

  Future<bool> verify(String otp);

  Future<void> refreshUserToken();

  Future<String?> getUserFirstName();

  Future<String?> getUserLastName();

  Future<String?> getUserEmail();

  Future<String?> userRefreshToken();

  Future<void> saveUserCredentials(LoginResponse user);

  Future<bool> isLogged();

  Future<void> logout();

  Future<bool> changePassword(String emailAddress);
}
