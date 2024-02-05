import 'package:flutter/material.dart';

import '../../data/repository/repository.dart';

class SignUpProvider extends ChangeNotifier {
  Repository repository;

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
