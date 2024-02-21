import 'package:flutter/foundation.dart';
import 'package:habit_maker/features/domain/repository/repository_api.dart';

class RestoreProvider extends ChangeNotifier {
  HabitRepositoryApi repository;

  RestoreProvider({required this.repository});

  void newPassword(String emailAddress, void Function() success,
      void Function() failure) async {
    if (await repository.changePassword(emailAddress)) {
      success();
    } else {
      failure();
    }
  }
}
