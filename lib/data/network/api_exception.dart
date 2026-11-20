import 'package:dio/dio.dart';

/// One error type for the whole app, with a message that is safe to show users.
class ApiException implements Exception {
  ApiException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  factory ApiException.fromDio(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return ApiException('The connection timed out. Please try again.');
      case DioExceptionType.connectionError:
        return ApiException('No internet connection. Check your network.');
      case DioExceptionType.badResponse:
        final code = e.response?.statusCode;
        return ApiException(_messageFor(code), statusCode: code);
      case DioExceptionType.cancel:
        return ApiException('The request was cancelled.');
      default:
        return ApiException('Something went wrong. Please try again.');
    }
  }

  static String _messageFor(int? code) {
    switch (code) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Your session has expired. Please log in again.';
      case 403:
        return 'You do not have permission to do this.';
      case 404:
        return 'The requested resource was not found.';
      case 500:
      case 502:
      case 503:
        return 'Server error. Please try again later.';
      default:
        return 'Unexpected error (code $code).';
    }
  }

  @override
  String toString() => message;
}
