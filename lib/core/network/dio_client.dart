import 'package:dio/dio.dart';

import '../constants/env_constants.dart';
import 'api_interceptor.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    dio = Dio(
      BaseOptions(
        baseUrl: 'https://newsapi.org/v2',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'X-Api-Key': EnvConstants.newsApiKey,
        },
      ),
    );

    dio.interceptors.add(
      ApiInterceptor(),
    );
  }
}