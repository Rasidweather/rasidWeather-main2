import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constants/strings.dart';
import '../../core/network/dio_helper.dart';

import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base/api_response.dart';

class InquiriesRepo {
  InquiriesRepo({required this.sharedPreferences, required this.dioClient});
  final SharedPreferences sharedPreferences;
  final DioClient dioClient;

  Future<ApiResponse> getInquiries(String params) async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.inquiriesUrl + params);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> getInquiryChat(String params) async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.inquiryChatUrl + params);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<ApiResponse> sendMsgInquiry(String id, FormData data) async {
    try {
      final Response<dynamic> response = await dioClient.post(AppStrings.inquiryReplyUrl + id, data: data);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      if (e.response != null) {
        return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
      }
      return ApiResponse.withError(e.toString());
    } catch (e) {
      return ApiResponse.withError(e.toString());
    }
  }
}
