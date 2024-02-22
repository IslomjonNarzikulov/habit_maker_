import 'package:dio/dio.dart';


class ApiService{
  factory ApiService(Dio dio) = _ApiService;
}