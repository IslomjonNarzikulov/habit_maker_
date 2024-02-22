import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/core/common/constants.dart';
import 'package:habit_maker/features/data/data_source/local/hive_database/hive.box.dart';
import 'package:habit_maker/features/data/data_source/remote/network_client.dart';
import 'package:habit_maker/features/data/models/login_response.dart';
import 'package:habit_maker/features/domain/repository/login_repository_api.dart';

class LoginRepository extends LoginRepositoryApi{
  NetworkClient networkClient;
  FlutterSecureStorage secureStorage;
  Database database;

  LoginRepository(
      {required this.secureStorage,
        required this.networkClient,
        required this.database,
      });

  @override
  Future<bool> signIn(
      String email,
      String password,
      ) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      var user = await networkClient.login(email, password);
      saveUserCredentials(user!);
      await secureStorage.write(key: isUserLogged, value: "true");
      return user != null;
    }
    return true;
  }

  @override
  Future<bool> signUp(
      String username,
      String password,
      ) async {
    if (username.isNotEmpty && password.isNotEmpty) {
      var user = await networkClient.signUpResponse(username, password);
      secureStorage.write(key: accessToken, value: user?.token);
      return user != null;
    } else {
      return false;
    }
  }

  @override
  Future<bool> verify(String otp) async {
    var token = await secureStorage.read(key: accessToken);
    if (token != null && otp.isNotEmpty) {
      var user = await networkClient.verifyResponse(token, otp);
      secureStorage.write(key: accessToken, value: user!.token!.accessToken);
      secureStorage.write(key: firstName, value: user.user!.firstName);
      secureStorage.write(key: lastName, value: user.user!.lastName);
      secureStorage.write(key: email, value: user.user!.email);
      secureStorage.write(key: userId, value: user.user!.id);
      return user != null;
    }
    return false;
  }

  @override
  Future<void> saveUserCredentials(LoginResponse user) async {
    await secureStorage.write(key: accessToken, value: user.token!.accessToken);
    await secureStorage.write(
        key: refreshToken, value: user.token!.refreshToken);
    await secureStorage.write(key: firstName, value: user.user!.firstName);
    await secureStorage.write(key: lastName, value: user.user!.lastName);
    await secureStorage.write(key: email, value: user.user!.email);
    await secureStorage.write(key: userId, value: user.user!.id);
  }

  @override
  Future<bool> restorePassword(String emailAddress) async {
    if (emailAddress.isNotEmpty) {
      var user = await networkClient.restorePassword(emailAddress);
      return user != null;
    }
    return false;
  }

  @override
  Future<void> refreshUserToken() async {
    var token = await secureStorage.read(key: refreshToken);
    var user = await networkClient.refreshToken(token!);
    if (user != null) {
      saveUserCredentials(user);
    }
  }
  @override
  Future<String?> getUserFirstName() async{
    return  secureStorage.read(key: firstName);
  }

  @override
  Future<String?> getUserLastName() async{
    return  secureStorage.read(key: lastName);
  }

  @override
  Future<String?> getUserEmail() {
    return secureStorage.read(key: email);
  }

  @override
  Future<String?> userRefreshToken() async {
    var tokenRefresh = await secureStorage.read(key: refreshToken);
    var user = await networkClient.refreshToken(tokenRefresh);
    await saveUserCredentials(user!);
    return await secureStorage.read(key: accessToken);
  }
  @override
  Future<bool> isLogged() async {
    var isLoggedIn = await secureStorage.read(key: isUserLogged);
    return isLoggedIn != null ? bool.parse(isLoggedIn) : false;
  }

  @override
  Future<void> logout() async {
    await secureStorage.deleteAll();
    await database.deleteAllHabits();
  }

}