import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get_user_agent/get_user_agent.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constants/strings.dart';
import '../constants/app_keys.dart';
import 'logging_interceptor.dart';

class DioClient {
  DioClient(
    this.baseUrl,
    Dio dioC, {
    required this.loggingInterceptor,
    required this.sharedPreferences,
    required this.userAgent,
  }) {
    dio = dioC;
    _initializeDio();
  }

  Future<void> _initializeDio() async {
    try {
      token = sharedPreferences.getString(AppKeys.token);
      lang = sharedPreferences.getString(AppKeys.language) ?? 'ar';

      final Map<String, dynamic> headers = <String, dynamic>{
        'Accept': 'application/json',
        'ik': AppStrings.serverToken,
        'user_agent': userAgent.getUserAgent(),
        'lang': lang,
      };

      if (token != null && token!.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      dio
        ..options.baseUrl = baseUrl
        ..options.connectTimeout = const Duration(milliseconds: 60000)
        ..options.receiveTimeout = const Duration(milliseconds: 60000)
        ..options.headers = headers
        ..interceptors.add(loggingInterceptor)
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
              // Check if token exists in SharedPreferences
              final String? storedToken = sharedPreferences.getString(AppKeys.token);
              if (storedToken != null && storedToken != token) {
                // Update token if it changed
                token = storedToken;
                options.headers['Authorization'] = 'Bearer $storedToken';
              }
              handler.next(options);
            },
            onError: (DioException error, ErrorInterceptorHandler handler) async {
              if (error.response?.statusCode == 401) {
                // Clear token on unauthorized
                await sharedPreferences.remove(AppKeys.token);
                await sharedPreferences.setBool(AppKeys.loggedInKey, false);
                token = null;
              }
              handler.next(error);
            },
          ),
        );
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing Dio: $e');
      }
    }
  }

  final String baseUrl;
  final LoggingInterceptor loggingInterceptor;
  final SharedPreferences sharedPreferences;

  late Dio dio;
  String? token;
  String? lang;
  final UserAgent userAgent;

  Future<void> updateHeader({String? token, String? language}) async {
    try {
      if (token != null) {
        this.token = token;
        await sharedPreferences.setString(AppKeys.token, token);
      }
      if (language != null) {
        lang = language;
        await sharedPreferences.setString(AppKeys.language, language);
      }

      final Map<String, dynamic> headers = <String, dynamic>{
        'Accept': 'application/json',
        'ik': AppStrings.serverToken,
        'user_agent': userAgent.getUserAgent(),
        'lang': lang,
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      } else if (this.token != null && this.token!.isNotEmpty) {
        headers['Authorization'] = 'Bearer ${this.token}';
      }

      dio.options.headers = headers;
    } catch (e) {
      if (kDebugMode) {
        print('Error updating headers: $e');
      }
    }
  }

  Future<Response<dynamic>> get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> post(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );

      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> put(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      final Response<dynamic> response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }

  Future<Response<dynamic>> delete(
    String uri, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      final Response<dynamic> response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException catch (_) {
      throw const FormatException('Unable to process the data');
    } catch (e) {
      rethrow;
    }
  }
}
