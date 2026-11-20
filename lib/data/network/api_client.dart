import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import 'api_exception.dart';

class ApiConfig {
  static const baseUrl = 'https://jsonplaceholder.typicode.com';
  static const timeout = Duration(seconds: 15);
}

/// Thin wrapper around Dio. Every request goes through [_request], so all
/// network errors come out as a single [ApiException] type.
class ApiClient {
  ApiClient() : _dio = Dio(BaseOptions(
            baseUrl: ApiConfig.baseUrl,
            connectTimeout: ApiConfig.timeout,
            receiveTimeout: ApiConfig.timeout,
            sendTimeout: ApiConfig.timeout,
            headers: {'Accept': 'application/json'})) {
    _dio.interceptors.addAll([
      // Attaches the auth token (if any) to every request.
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          handler.next(options);
        },
      ),
      // Logs requests/responses in debug builds only.
      if (kDebugMode) LogInterceptor(requestBody: true, responseBody: true),
    ]);
  }

  final Dio _dio;

  /// Set this after login; the interceptor above will send it.
  String? token;

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _request(() => _dio.get(path, queryParameters: query));

  Future<dynamic> post(String path, {Object? data}) =>
      _request(() => _dio.post(path, data: data));

  Future<dynamic> put(String path, {Object? data}) =>
      _request(() => _dio.put(path, data: data));

  Future<dynamic> delete(String path) => _request(() => _dio.delete(path));

  Future<dynamic> _request(Future<Response<dynamic>> Function() call) async {
    try {
      final response = await call();
      return response.data;
    } on DioException catch (e) {
      throw ApiException.fromDio(e);
    }
  }
}
