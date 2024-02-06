import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:habit_maker/domain/restore_model/restore_response.dart';
import 'package:habit_maker/models/login_response.dart';
import 'package:habit_maker/models/registration_response.dart';
import 'package:habit_maker/models/verify_response.dart';

import '../../common/constants.dart';
import '../../models/activities_model.dart';
import '../../models/habit_model.dart';

class NetworkClient {
  final Dio dio;

  NetworkClient({required this.dio});

  Future<LoginResponse?> login(String email, String password) async {
    try {
      final response = await dio.post("$baseUrl/v1/auth/login", data: {
        "email": email,
        "password": password,
      });
      return LoginResponse.fromJson(response.data);
    } catch (e) {
      e.toString();
      return null;
    }
  }

  Future<SignUpResponse?> signUpResponse(String email, String password) async {
    try {
      final response =
          await dio.post("$baseUrl/v1/auth/registration/otp", data: {
        "email": email,
        "password": password,
      });
      return SignUpResponse.fromJson(response.data);
    } catch (e) {
      e.toString();
      return null;
    }
  }

  Future<LoginResponse?> refreshToken(String? refreshToken) async {
    final response = await dio.post("$baseUrl/v1/auth/refresh-token",
        options: Options(
          validateStatus: (_) => true,
          headers: {
            'Content-Type': 'application/json',
          },
        ),
        data: {'refreshToken': refreshToken});

    return LoginResponse.fromJson(response.data);
  }

  Future<VerifyResponse> verifyResponse(String token, String otp) async {
    final response = await dio.post("$baseUrl/v1/auth/registration/verify",
        options: Options(
            validateStatus: (_) => true,
            headers: {'Content-Type': 'application/json'}),
        data: {
          "token": token,
          "otp": otp,
        });
    if (response.statusCode!.isSuccessFull()) {
      return VerifyResponse.fromJson(jsonDecode(response.data));
    } else {
      throw Exception('Failed to verify');
    }
  }

  Future<bool> createHabit(HabitModel habitModel, token) async {
    final response = await dio.post(
      "$baseUrl/v1/habits",
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
      data: jsonEncode(habitModel.toJson()),
    );
    return response.statusCode!.isSuccessFull();
  }

  Future<List<HabitModel>> loadHabits(String token) async {
    var list = <HabitModel>[]; //
    try {
      var response = await dio.get(
        "$baseUrl/v1/habits",
        options: Options(
          validateStatus: (_) => true,
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
        ),
      );
      Map<String, dynamic> jsonData = response.data;
      if (jsonData.containsKey('habits')) {
        for (var element in jsonData['habits']) {
          if (element['repetition']['weekdays'] != null) {
            var item = HabitModel.fromJson(element);
            list.add(item);
          }
        }
      }
    } catch (e) {
      e.toString();
    }

    return list;
  }

  Future<bool> deleteHabits(String id, token) async {
    final response = await dio.delete('$baseUrl/v1/habits/$id',
        options: Options(validateStatus: (_) => true, headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        }));
    return response.statusCode!.isSuccessFull();
  }

  Future<bool> updateHabits(HabitModel habitModel, token) async {
    final response = await dio.put(
      '$baseUrl/v1/habits/${habitModel.id}',
      options: Options(validateStatus: (_) => true, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      }),
      data: (habitModel.toJson()),
    );

    return response.statusCode!.isSuccessFull();
  }

  Future<Activities> createActivities(String id, String date, token) async {
    final response = await dio.post(
      '$baseUrl/v1/activities',
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
      data: {'habitId': id, 'date': date},
    );
    if (response.statusCode!.isSuccessFull()) {
      return Activities.fromJson(response.data);
    } else {
      throw Exception('Failed to get activities');
    }
  }

  Future<bool> deleteActivities(String id, String token) async {
    final response = await dio.delete(
      '$baseUrl/v1/activities/$id',
      options: Options(
        validateStatus: (_) => true,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      ),
    );
    return response.statusCode!.isSuccessFull();
  }

  Future<RestorePassword> restorePassword(String emailAddress) async {
    var response = await dio.post(
      '$baseUrl/v1/auth/restore/generate-link',
      options: Options(
        validateStatus: (_) => true,
        headers: {'Content-Type': 'application/json'},
      ),
      data: {'email': emailAddress},
    );
    if (response.statusCode!.isSuccessFull()) {
      return RestorePassword.fromJson(response.data);
    } else {
      throw Exception('Request failed');
    }
  }
}

extension StatusParsing on int {
  bool isSuccessFull() {
    var res = this >= 200 && this < 300;
    return res;
  }
}
