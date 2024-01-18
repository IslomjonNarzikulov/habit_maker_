import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/common/constants.dart';

import '../../data/repository/repository.dart';

class SignInProvider extends ChangeNotifier {
  Repository repository;
  FlutterSecureStorage secureStorage;

  SignInProvider(this.repository, this.secureStorage);

  void signIn(String email, String password, void Function() success,
      void Function() failure) async {
    if (await repository.signIn(email, password)) {
      await secureStorage.write(key: isUserLogged, value: "true");
      success();
    }
    failure();
    notifyListeners();
  }
}
