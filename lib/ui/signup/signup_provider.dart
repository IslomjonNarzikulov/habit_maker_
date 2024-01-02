import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/data/network_client/network_client.dart';
import '../../data/repository/repository.dart';

class SignUpProvider extends ChangeNotifier {
  Repository repository;
  SignUpProvider(this.repository);

  void signUp(String username, String password, void Function() success,
      void Function() failure) async {
    await repository.signUp(username,password);
  }

  void verify(
      String otp, void Function() success, void Function() failure) async {
    await repository.verify(otp);
  }
}
