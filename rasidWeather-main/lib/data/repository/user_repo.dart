import 'package:dio/dio.dart';

import '../../common/constants/strings.dart';
import '../../core/network/dio_helper.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base/api_response.dart';

class UserRepo {
  UserRepo({required this.dioClient});

  final DioClient dioClient;

  // search user by name
  Future<ApiResponse> searchUser(String name) async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.searchUserUrl + name);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  // get user by id
  Future<ApiResponse> getProfileDetails(String params) async {
    try {
      final Response<dynamic> response = await dioClient.get('${AppStrings.getProfileDetailsUrl}/$params');
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }
}
