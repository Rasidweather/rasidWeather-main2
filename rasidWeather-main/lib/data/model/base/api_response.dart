import 'package:dio/dio.dart';

class ApiResponse {
  ApiResponse(this.response, this.error);

  ApiResponse.withSuccess(Response<dynamic> responseValue)
      : response = responseValue,
        error = null;

  ApiResponse.withError(String errorValue)
      : response = null,
        error = errorValue;
  final Response<dynamic>? response;
  final String? error;
}
