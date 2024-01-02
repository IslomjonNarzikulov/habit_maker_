import 'package:flutter/cupertino.dart';
import 'package:habit_maker/common/constants.dart';

import '../data/repository/repository.dart';

class SignInProvider extends ChangeNotifier {
  Repository repository;

  SignInProvider(this.repository);

  void signIn(String email, String password, void Function() success,
      void Function() failure) async {
    if (await repository.signIn(email, password)) {
      success();
    }
    failure();
    notifyListeners();
  }
}
