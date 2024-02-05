import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/common/constants.dart';

class ProfileProvider extends ChangeNotifier {
  FlutterSecureStorage secureStorage;

  ProfileProvider(this.secureStorage);

  String? name;
  String? surname;

  void initData() async {
    print("initData: ");
    try {
      name = await secureStorage.read(key: firstName);
      surname = await secureStorage.read(key: lastName);
    } catch (e) {
      print("initData: ${e.toString()} ");
    }
    print("initData: $name $surname");
    notifyListeners();
  }
}
