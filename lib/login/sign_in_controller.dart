import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/common/constants.dart';
import 'package:habit_maker/network/network_client.dart';

class SignInController extends ChangeNotifier {
  var hasLoginValidationError = false;
  final networkClient = NetworkClient();
  FlutterSecureStorage secureStorage;

  SignInController(this.secureStorage);

  void signIn(String username, String password, void Function() success,
      void Function() failure) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      var user = await networkClient.login(username, password);
      if (user != null) {
        secureStorage.write(key: accessToken, value: user.token!.accessToken);
        secureStorage.write(key: firstName, value: user.user!.firstName);
        secureStorage.write(key: lastName, value: user.user!.lastName);
        secureStorage.write(key: email, value: user.user!.email);
        secureStorage.write(key: userId, value: user.user!.id);
        success();
      } else {
        failure();
      }
    } else {
      hasLoginValidationError = true;
      notifyListeners();
    }
  }

  void resolveNavigation(void Function() openHome) async {
    var token = await secureStorage.read(key: accessToken);
    if (token != null && token != '') {
      openHome();
    }
  }
}
