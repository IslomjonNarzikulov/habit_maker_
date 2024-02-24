import 'package:flutter/material.dart';
import 'package:habit_maker/features/domain/repository/login_repository_api.dart';
import 'package:habit_maker/features/domain/repository/habit_repository_api.dart';

class SignUpProvider extends ChangeNotifier {
  LoginRepositoryApi loginRepository;

  SignUpProvider(this.loginRepository);

  void signUp(String username, String password, void Function() success,
      void Function() failure) async {
    if (await loginRepository.signUp(username, password)) {
      success();
    } else {
      failure();
    }
  }

  void verify(
      String otp, void Function() success, void Function() failure) async {
    if (await loginRepository.verify(otp)) {
      success();
    } else {
      failure();
    }
  }
}
