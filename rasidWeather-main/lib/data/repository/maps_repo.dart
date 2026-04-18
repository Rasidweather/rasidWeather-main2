import 'package:dio/dio.dart';

import '../../core/network/dio_helper.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base/api_response.dart';

class MapsRepo {
  MapsRepo(this.dioClient);

  final DioClient dioClient;

  Future<ApiResponse> getRainViewerMaps() async {
    try {
      final Response<dynamic> response = await dioClient.get('https://api.rainviewer.com/public/weather-maps.json');
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }
}
