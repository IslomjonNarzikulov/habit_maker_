import 'package:dio/dio.dart';

import '../../data/repository/repository.dart';

class CustomInterceptors extends Interceptor {
 Repository habitRepository;
  Dio _dio;

  CustomInterceptors(this.habitRepository, this._dio);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  // Helper method to determine if the token should be refreshed
  bool _shouldRefreshToken(RequestOptions options) {
    // Prevent infinite loop if token refresh fails by checking a flag in request options
    return !(options.extra['tokenRefreshed'] == true);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      RequestOptions requestOptions = err.requestOptions;

      try {
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

        // Pass the new response to the handler
        handler.resolve(clonedRequest);
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