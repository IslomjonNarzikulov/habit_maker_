import 'dart:convert';
import 'package:habit_maker/models/login_response.dart';
import 'package:http/http.dart';

class NetworkClient {
  Future<LoginResponse?> login(String login, String password) async {
    try {
      final response = await post(
          Uri.parse("https://api.habit.nodirbek.uz/v1/auth/login"),
          body: {
            "email": login,
            "password": password,
          });
      return LoginResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      e.toString();
      return null;
    }
  }
}
