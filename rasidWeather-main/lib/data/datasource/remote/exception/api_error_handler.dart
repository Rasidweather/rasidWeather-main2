import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../../../model/base/error_response.dart';

class ApiErrorHandler {
  static String? getMessage(DioException error) {
    String? errorDescription = '';
    if (error is FirebaseException) {
      return errorDescription = error.message;
    } else {
      switch (error.type) {
        case DioExceptionType.cancel:
          errorDescription = 'Request was cancelled';
        case DioExceptionType.connectionTimeout:
          errorDescription = 'Connection timeout';
        case DioExceptionType.receiveTimeout:
          errorDescription = 'Receive timeout in connection with API server';
        case DioExceptionType.sendTimeout:
          errorDescription = 'Send timeout in connection with API server';
        case DioExceptionType.badCertificate:
          errorDescription = 'Bad Certificate';
        case DioExceptionType.connectionError:
          errorDescription = 'Connection to API server failed due to internet connection';
        case DioExceptionType.badResponse:
          switch (error.response!.statusCode) {
            case 401:
              errorDescription = 'No active account found with the given credentials';
            case 403:
            case 422:
              // final errorRe = ErrorResponse.fromJson(error.response!.data);
              final errorRe = error.response!.data['message'];
              print('Error >>>>> $errorRe');
             return errorDescription = errorRe.toString();
            case 404:
            case 500:
            case 503:
              errorDescription = error.response!.statusMessage;
            default:
              ErrorResponse? errorResponse;
              try {
                errorResponse = ErrorResponse.fromJson(error.response!.data as Map<String, dynamic>);
              } catch (e) {
                if (kDebugMode) {
                  print(e);
                }
              }
              if (errorResponse != null && errorResponse.message.isNotEmpty) {
                errorDescription = errorResponse.message;
              } else {
                errorDescription = 'Failed to load data - status code: ${error.response!.statusCode}';
              }
          }
          if (error.response!.statusCode == 400) {
            errorDescription = 'Bad request';
          } else if (error.response!.statusCode == 401) {
            errorDescription = 'Unauthorized request';
          } else if (error.response!.statusCode == 404) {
            errorDescription = 'Requested resource was not found';
          } else if (error.response!.statusCode == 500) {
            errorDescription = 'Internal server error';
          } else {
            errorDescription = 'Received invalid status code: ${error.response!.statusCode}';
          }
        case DioExceptionType.unknown:
          errorDescription = 'Unexpected error occurred';
      }
      return errorDescription;
    }
  }
}
