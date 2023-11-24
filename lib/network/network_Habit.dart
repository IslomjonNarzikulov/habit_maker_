
import 'dart:convert';
import 'package:habit_maker/models/habit_model.dart';
import 'package:http/http.dart';

class NetworkHabit {
  Future<HabitModel?> createHabit(String title, String description) async {
    try {
      final response = await post(
          Uri.parse("https://api.habit.nodirbek.uz/v1/habits"),
          body: {
            "title": title,
            "description": description,
          });
      //return HabitModel().fromJson(jsonDecode(response.body));
    } catch (e) {
      return null;
    }
  }
}
