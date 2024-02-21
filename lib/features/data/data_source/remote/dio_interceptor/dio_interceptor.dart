import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/core/common/constants.dart';
import 'package:habit_maker/features/data/data_source/remote/network_client.dart';
import 'package:habit_maker/features/data/models/login_response.dart';

import '../../../repository/repository.dart';

class CustomInterceptors extends Interceptor {
  FlutterSecureStorage secureStorage;
  NetworkClient networkClient;
  final Dio _dio;

  CustomInterceptors(this.secureStorage,this.networkClient, this._dio);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      handler.next(await updateUserToken(response.requestOptions));
    } else {
      handler.next(response);
    }
  }

  Future<Response> updateUserToken(RequestOptions requestOptions) async {
    final String newToken = (await userRefreshToken())!;
    _dio.options.headers['Authorization'] = 'Bearer $newToken';
    final opts = Options(
      method: requestOptions.method,
      headers: requestOptions.headers,
    );
    final clonedRequest = await _dio.request(
      requestOptions.path,
      options: opts,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );
    return clonedRequest;
  }

  Future<String?> userRefreshToken() async {
    var tokenRefresh = await secureStorage.read(key: refreshToken);
    var user = await networkClient.refreshToken(tokenRefresh);
    await saveUserCredentials(user!);
    return await secureStorage.read(key: accessToken);
  }

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
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        handler.resolve(await updateUserToken(err.requestOptions));
      } catch (e) {
        handler.next(err);
      }
    } else {
      handler.next(err);
    }
  }
}
