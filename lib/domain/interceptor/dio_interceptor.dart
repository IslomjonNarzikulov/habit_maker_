import 'package:dio/dio.dart';

import '../../data/repository/repository.dart';

class CustomInterceptors extends Interceptor {
  Repository habitRepository;
  Dio _dio;

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
    // Attempt token refresh
    final String newToken = (await habitRepository.userRefreshToken())!;

    // Update Dio with the new token
    _dio.options.headers['Authorization'] = 'Bearer $newToken';

    // Clone the original request with updated options and headers
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
        // Token refresh failed or other error occurred, pass the original error
        handler.next(err);
      }
    } else {
      // Not a 401 error, pass it along
      handler.next(err);
    }
  }
}
