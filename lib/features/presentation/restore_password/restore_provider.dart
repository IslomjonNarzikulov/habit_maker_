import 'package:flutter/foundation.dart';
import 'package:habit_maker/features/domain/repository/login_repository_api.dart';
import 'package:habit_maker/features/domain/repository/habit_repository_api.dart';

class RestoreProvider extends ChangeNotifier {
  LoginRepositoryApi loginRepository;

  RestoreProvider({required this.loginRepository});

  void newPassword(String emailAddress, void Function() success,
      void Function() failure) async {
    if (await loginRepository.restorePassword(emailAddress)) {
      success();
    } else {
      failure();
    }
  }
}
