import 'package:dio/dio.dart';

final dio = Dio();

void configureDio() {
  // Set default configs
  dio.options.connectTimeout = Duration(seconds: 5);
  dio.options.receiveTimeout = Duration(seconds: 3);
}


