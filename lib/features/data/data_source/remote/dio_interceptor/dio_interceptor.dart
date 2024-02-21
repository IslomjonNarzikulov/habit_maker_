import 'package:dio/dio.dart';

import '../../../repository/repository.dart';

class CustomInterceptors extends Interceptor {
  Repository habitRepository;
  final Dio _dio;

  CustomInterceptors(this.habitRepository, this._dio);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    if (response.statusCode == 401) {
      handler.next(await updateUserToken(response.requestOptions));
    } else {
      handler.next(response);
    }
  }

  Future<Response> updateUserToken(RequestOptions requestOptions) async {
    final String newToken = (await habitRepository.userRefreshToken())!;
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
