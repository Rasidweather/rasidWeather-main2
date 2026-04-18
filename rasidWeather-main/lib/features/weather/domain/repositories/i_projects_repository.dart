import '../../../../core/repositories/base_repository.dart';
import '../../../../data/model/base/api_response.dart';
import '../../data/models/weather_model.dart';

abstract class IWeatherRepository extends BaseRepository<WeatherModel> {
  Future<ApiResponse> getWeatherApi(Map<String, dynamic> params);
  Future<ApiResponse> getChartApi(Map<String, dynamic> params);
}
