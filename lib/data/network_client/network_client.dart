import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:habit_maker/data/exception/unauthorized_exception.dart';
import 'package:habit_maker/models/login_response.dart';
import 'package:habit_maker/models/registration_response.dart';
import 'package:habit_maker/models/verify_response.dart';
import 'package:habit_maker/provider/habit_provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../../common/constants.dart';
import '../../models/activities_model.dart';
import '../../models/habit_model.dart';

class NetworkClient extends ChangeNotifier {
  Future<LoginResponse?> login(String email, String password) async {
    try {
      final response = await post(Uri.parse("$baseUrl/v1/auth/login"), body: {
        "email": email,
        "password": password,
      });
      return LoginResponse.fromJson(jsonDecode(response.body));
    } catch (e) {
      e.toString();
      return null;
    }
  }

  Future<SignUpResponse?> signUp_response(String email, String password) async {
    final response =
        await post(Uri.parse("$baseUrl/v1/auth/registration/otp"), body: {
      "email": email,
      "password": password,
    });
    if (response.statusCode == 401) {
      throw UnAuthorizedException('');
    }
    return SignUpResponse.fromJson(jsonDecode(response.body));
  }

  Future<LoginResponse?> refreshToken(String? refreshToken) async {
    final response = await post(Uri.parse("$baseUrl/v1/auth/refresh-token"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'refreshToken': refreshToken}));

    return LoginResponse.fromJson(jsonDecode(response.body));
  }

  Future<VerifyResponse> verifyResponse(String token, String otp) async {
    final response =
        await post(Uri.parse("$baseUrl/v1/auth/registration/verify"),
            headers: {'Content-Type': 'application/json'},
            body: json.encode({
              "token": token,
              "otp": otp,
            }));
    if (response.statusCode.isSuccessFull()) {
      return VerifyResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to verify');
    }
  }

  Future<bool> createHabit(HabitModel habitModel, token) async {
    final response = await http.post(
      Uri.parse("$baseUrl/v1/habits"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode(habitModel.toJson()),
    );
    if (response.statusCode == 401) {
      throw UnAuthorizedException('');
    }
    return response.statusCode.isSuccessFull();
  }

  Future<List<HabitModel>> loadHabits(token) async {
    var list = <HabitModel>[];
    final response = await get(Uri.parse('$baseUrl/v1/habits'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });
    if (response.statusCode == 401) {
      throw UnAuthorizedException('');
    }
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
    final response = await delete(Uri.parse('$baseUrl/v1/habits/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    return response.statusCode.isSuccessFull();
  }

  Future<bool> updateHabits(String id, HabitModel habitModel, token) async {
    final response = await put(Uri.parse('$baseUrl/v1/habits/$id'),
        body: jsonEncode(habitModel.toJson()),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        });
    if (response.statusCode == 401) {
      throw UnAuthorizedException('');
    }
    return response.statusCode.isSuccessFull();
  }

  Future<Activities> createActivities(String id, String date, token) async {
    final response = await post(
      Uri.parse('$baseUrl/v1/activities'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
      body: jsonEncode({'habitId': id, 'date': date}),
    );
    if (response.statusCode.isSuccessFull()) {
      return Activities.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to get activities');
    }
  }

  Future<bool> deleteActivities(String id, String token) async {
    final response = await delete(
      Uri.parse('$baseUrl/v1/activities/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      },
    );
    return response.statusCode.isSuccessFull();
  }
}
