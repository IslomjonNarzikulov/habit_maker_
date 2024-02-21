import 'package:flutter/material.dart';
import 'package:habit_maker/features/domain/repository/repository_api.dart';

class SignUpProvider extends ChangeNotifier {
  HabitRepositoryApi repository;

  SignUpProvider(this.repository);

  void signUp(String username, String password, void Function() success,
      void Function() failure) async {
    if (await repository.signUp(username, password)) {
      success();
    } else {
      failure();
    }
  }

  void verify(
      String otp, void Function() success, void Function() failure) async {
    if (await repository.verify(otp)) {
      success();
    } else {
      failure();
    }
  }
}
