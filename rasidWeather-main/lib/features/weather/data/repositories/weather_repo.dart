import 'package:dio/dio.dart';

import '../../../../core/core.dart';
import '../../../../data/model/base/api_response.dart';
import '../../domain/repositories/i_projects_repository.dart';
import '../models/weather_model.dart';

class WeathersRepo implements IWeatherRepository {

  WeathersRepo(this.dio);
  final DioClient dio;

  @override
  Future<ApiResponse> getWeatherApi(Map<String, dynamic> params) async {
    try {
      final Response<dynamic> response = await dio.get(
        AppStrings.getWeatherEndpoint,
        queryParameters: params,
        options: Options(
          receiveTimeout: const Duration(milliseconds: 30000), // 30 seconds timeout for weather requests
          sendTimeout: const Duration(milliseconds: 30000),
        ),
      );
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      print('Weather API error: ${e.type} - ${e.message}');
      
      // Handle different error types
      if (e.type == DioExceptionType.connectionTimeout || 
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        return ApiResponse.withError('Connection timeout. Please check your internet connection and try again.');
      } else if (e.type == DioExceptionType.connectionError) {
        return ApiResponse.withError('Connection error. Please check your internet connection and try again.');
      } else {
        return ApiResponse.withError(e.response?.data?.toString() ?? e.message ?? 'Unknown error');
      }
    } catch (e) {
      print('Unexpected error in weather API: $e');
      return ApiResponse.withError('An unexpected error occurred. Please try again later.');
    }
  }
  
  @override
  Future<void> delete(String id) async {}

  @override
  Future<List<WeatherModel>> getAll() async {
    // final ApiResponse response = await getWeatherApi(<String, dynamic>{});
    // if (response.response?.statusCode == 200) {
    //   final Map<String, dynamic> data = response.response!.data['data'] as Map<String, dynamic>;
    //   final WeatherModel projectsData = WeathersData.fromJson(data);
    //   return projectsData.projects ?? <Weather>[];
    // }
    // return <WeatherModel>[];
    return <WeatherModel>[];
  }

  @override
  Future<WeatherModel?> getById(String id) async {
    return null;
  }

  @override
  Future<void> update(WeatherModel item) async {}

  @override
  Future<void> create(WeatherModel item) {
    throw UnimplementedError();
  }

  @override
  Future<ApiResponse> getChartApi(Map<String, dynamic> params)async {
    try {
      final Response<dynamic> response = await dio.get(
        AppStrings.getChartsEndpoint,
        queryParameters: params,
      );

      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(e.response!.data['detail'].toString());
    }
  }
  
}
