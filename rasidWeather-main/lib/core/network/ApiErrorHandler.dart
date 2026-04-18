import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../data/model/base/error_response.dart';

class ApiErrorHandler {
  static String? getMessage(DioException error) {
    debugPrint('getMessage error: ${error.type}');
    switch (error.type) {
      case DioExceptionType.cancel:
        return 'Request was cancelled';
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout';
      case DioExceptionType.receiveTimeout:
        return 'Receive timeout in connection with API server';
      case DioExceptionType.sendTimeout:
        return 'Send timeout in connection with API server';
      case DioExceptionType.badCertificate:
        return 'Bad Certificate';
      case DioExceptionType.connectionError:
        return 'Connection to API server failed due to internet connection';
      case DioExceptionType.badResponse:
        return _handleBadResponse(error.response);
      case DioExceptionType.unknown:
      return 'Unexpected error occurred';
    }
  }

  static String? _handleBadResponse(Response<dynamic>? response) {
    if (response == null) {
      return 'Failed to receive a response from the server';
    }
    debugPrint('_handleBadResponse statusCode: ${response.statusCode}');

    switch (response.statusCode) {
      case 400:
        return 'Bad request';
      case 401:
        return 'Unauthorized request';
      case 403:
        return _extractMessage(response, defaultMessage: 'Forbidden access');
      case 404:
        return 'Requested resource was not found';
      case 422:
        return _extractMessage(response, defaultMessage: 'Unprocessable Entity');
      case 500:
        return 'Internal server error';
      case 503:
        return 'Service unavailable';
      default:
        return _handleCustomErrorResponse(response) ?? 'Received invalid status code: ${response.statusCode}';
    }
  }

  static String? _extractMessage(Response<dynamic> response, {String? defaultMessage}) {
    try {
      final message = response.data['message'];
      return message is String && message.isNotEmpty ? message : defaultMessage;
    } catch (e) {
      if (kDebugMode) {
        print('Error extracting message: $e');
      }
      return defaultMessage;
    }
  }

  static String? _handleCustomErrorResponse(Response<dynamic> response) {
    try {
      final ErrorResponse errorResponse = ErrorResponse.fromJson(response.data as Map<String, dynamic>);
      if (errorResponse.message.isNotEmpty) {
        return errorResponse.message;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error parsing ErrorResponse: $e');
      }
    }
    return null;
  }
}
