import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:habit_maker/core/common/constants.dart';
import 'package:habit_maker/features/data/network/data_source/habit_api/login_api_service/login_api_service.dart';
import 'package:habit_maker/features/data/network/models/login_response/login_response.dart';

class CustomInterceptors extends Interceptor {
  FlutterSecureStorage secureStorage;
  LoginApiService networkApiService;
  final Dio _dio;
  bool isTokenRefreshInProgress = false;

  CustomInterceptors(this.secureStorage, this.networkApiService, this._dio);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      isTokenRefreshInProgress == true;
      handler.next(await updateUserToken(response.requestOptions));
    } else {
      handler.next(response);
    }
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    if (!isTokenRefreshInProgress) {
      var token = await secureStorage.read(key: accessToken);
      options.headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };
      super.onRequest(options, handler);
    }else{
      super.onRequest(options, handler);
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
    var user = await networkApiService.refreshToken(tokenRefresh ?? '');
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
