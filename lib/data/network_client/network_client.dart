import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:habit_maker/models/login_response.dart';
import 'package:habit_maker/models/registration_response.dart';
import 'package:habit_maker/models/verify_response.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../models/habit_model.dart';

class NetworkClient extends ChangeNotifier {
  Future<LoginResponse?> login(String email, String password) async {
   try{
     final response = await post(
       Uri.parse("https://api.habit.nodirbek.uz/v1/auth/login"),
       body: {
         "email": email,
         "password": password,
       });
      return LoginResponse.fromJson(jsonDecode(response.body));
    }catch(e){
     e.toString();
     return null;}

  }

  Future<SignUpResponse?> signUp_response(String login, String password) async {
    final response = await post(
        Uri.parse("http://38.242.252.210:6001/v1/auth/registration/otp"),
        body: {
          "email": login,
          "password": password,
        });
    return SignUpResponse.fromJson(jsonDecode(response.body));
  }

  Future<LoginResponse?> refreshToken(String refreshToken) async {
    final response = await post(
        Uri.parse("https://api.habit.nodirbek.uz/v1/auth/refresh-token"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: {
          "refreshToken": refreshToken,
        });
    return LoginResponse.fromJson(jsonDecode(response.body));
  }

  Future<VerifyResponse?> verify_response(String token, String otp) async {
    final response = await post(
        Uri.parse("http://38.242.252.210:6001/v1/auth/registration/verify"),
        body: {
          "token": token,
          "otp": otp,
        });
    return VerifyResponse.fromJson(jsonDecode(response.body));
  }

  Future<bool> createHabit(HabitModel habitModel, token) async {
    try {
      final response = await http.post(
        Uri.parse("https://api.habit.nodirbek.uz/v1/habits"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode(habitModel.toJson()),
      );
      return response.statusCode.isSuccessFull();
    } catch (e) {
      e.toString();
      return false;
    }
  }

  Future<List<HabitModel>> loadHabits(token) async {
    var list = <HabitModel>[];
    final response = await get(
        Uri.parse('https://api.habit.nodirbek.uz/v1/habits'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData['habits'].forEach((element) {
      if (element['repetition']['weekdays'] != null) {
        var item = HabitModel.fromJson(element);
        list.add(item);
      }
    });
    return list;
  }

  Future<bool> deleteHabits(String id, token) async {
    final response = await delete(
        Uri.parse('https://api.habit.nodirbek.uz/v1/habits/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    return response.statusCode.isSuccessFull();
  }

  Future<bool> updateHabits(String id, HabitModel habitModel, token) async {
    final response = await put(
        Uri.parse('https://api.habit.nodirbek.uz/v1/habits/$id'),
        body: jsonEncode(habitModel.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    return response.statusCode.isSuccessFull();
  }
}
