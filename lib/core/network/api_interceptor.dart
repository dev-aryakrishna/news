import 'package:dio/dio.dart';

class ApiInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    print(
      'REQUEST[${options.method}] => ${options.path}',
    );

    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) {
    print(
      'RESPONSE[${response.statusCode}] => ${response.requestOptions.path}',
    );

    super.onResponse(response, handler);
  }

  @override
  void onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) {
    print(
      'ERROR[${err.response?.statusCode}] => ${err.requestOptions.path}',
    );

    super.onError(err, handler);
  }
}