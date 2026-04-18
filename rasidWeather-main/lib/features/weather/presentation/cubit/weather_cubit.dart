import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../core/states/base_state.dart';
import '../../../../data/model/base/api_response.dart';
import '../../../cities/data/models/city_model.dart';
import '../../../language/cubit/language_cubit.dart';
import '../../data/models/weather_model.dart';
import '../../domain/repositories/i_projects_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._weatherRepository, this._languageCubit) : super(const WeatherState());

  final IWeatherRepository _weatherRepository;
  final LanguageCubit _languageCubit;
  
  static const String _lastUpdateKey = 'weather_last_update_time';
  
  static const int _maxRetryAttempts = 3;
  
  static const int _baseRetryDelaySeconds = 2;
  
  CurrentWeather? _lastCurrentWeather;
  List<Hour>? _lastHourlyWeather;
  List<Day>? _lastDailyWeather;
  
  Future<DateTime?> getLastUpdate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final int? timestamp = prefs.getInt(_lastUpdateKey);
    if (timestamp != null) {
      return DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    return null;
  }
  
  Future<void> _saveUpdateTime() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastUpdateKey, DateTime.now().millisecondsSinceEpoch);
  }

  Future<void> getWeatherData(CityModel city, {
    bool refresh = false,

  }) async {

    final Map<String, dynamic> params = <String, dynamic>{
      'latitude': city.latitude,
      'longitude': city.longitude,
      'timezone': city.timezone,
      'country_code': city.countryCode,
      'lang': _languageCubit.getCurrentLanguage(),
      'units': 'metric',
    };

    if (refresh) {
      emit(state.copyWith(isLoading: true, refresh: true));
    } else {
      if (_lastCurrentWeather != null) {
        emit(state.copyWith(
          isLoading: true,
          current: _lastCurrentWeather,
          hours: _lastHourlyWeather,
          days: _lastDailyWeather,
        ));
      } else {
        emit(state.copyWith(isLoading: true));
      }
    }

    try {
      final WeatherModel result = await _fetchWithRetry(params);
      
      _lastCurrentWeather = result.current;
      _lastHourlyWeather = result.hours;
      _lastDailyWeather = result.days;

      await _saveUpdateTime();

      print(
        'WEATHER_DEBUG hours=${result.hours?.length} '
        'thunder=${result.thunderstormSummary?.length} '
        'hasAppearance=${result.current?.appearance != null}',
      );
      print(
        'WEATHER_DEBUG firstHour='
        '${result.hours?.isNotEmpty ?? false ? result.hours!.first.forecastStart : 'none'}',
      );

      emit(state.copyWith(
        isLoading: false,
        refresh: false,
        current: result.current,
        hours: result.hours,
        days: result.days,
        thunderstormSummary: result.thunderstormSummary,
      ));
    } catch (e) {
      debugPrint('Error fetching weather data: $e');
      
      if (_lastCurrentWeather != null) {
        emit(state.copyWith(
          isLoading: false,
          refresh: false,
          current: _lastCurrentWeather,
          hours: _lastHourlyWeather,
          days: _lastDailyWeather,
          error: _getErrorMessage(e),
        ));
      } else {
        emit(state.copyWith(
          isLoading: false,
          refresh: false,
          error: _getErrorMessage(e),
        ));
      }
    }
  }
  
  Future<WeatherModel> _fetchWithRetry(Map<String, dynamic> params, {int attempt = 1}) async {
    try {
      debugPrint('Fetching weather data, attempt $attempt');
      final ApiResponse apiResponse = await _weatherRepository.getWeatherApi(params);
      
      if (apiResponse.response != null && apiResponse.response!.statusCode == 200) {
        final dynamic responseData = apiResponse.response!.data;
        Map<String, dynamic> weatherData;
        
        if (responseData is Map<String, dynamic>) {
          if (responseData.containsKey('body')) {
            weatherData = responseData['body'] as Map<String, dynamic>;
          } else {
            weatherData = responseData;
          }
          debugPrint('Weather data fetched successfully');
          return WeatherModel.fromJson(weatherData);
        } else {
          throw Exception('Invalid response format: ${responseData.runtimeType}');
        }
      } else {
        throw Exception('Failed to load weather data: ${apiResponse.error}');
      }
    } catch (e) {
      debugPrint('Error in attempt $attempt: $e');
      
      if (_shouldRetry(e) && attempt < _maxRetryAttempts) {
        final int delaySeconds = _baseRetryDelaySeconds * attempt;
        debugPrint('Retry attempt $attempt after $delaySeconds seconds');
        
        await Future<void>.delayed(Duration(seconds: delaySeconds));
        
        return _fetchWithRetry(params, attempt: attempt + 1);
      }
      
      rethrow;
    }
  }
  
  bool _shouldRetry(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
             error.type == DioExceptionType.receiveTimeout ||
             error.type == DioExceptionType.sendTimeout ||
             error.type == DioExceptionType.unknown; // Network errors
    }
    
    if (error is SocketException) {
      return true;
    }
    
    return false;
  }
  
  String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.receiveTimeout:
        case DioExceptionType.sendTimeout:
          return 'Connection timed out. Please check your internet connection and try again.';
        case DioExceptionType.badResponse:
          return 'Server error (${error.response?.statusCode}). Please try again later.';
        case DioExceptionType.cancel:
          return 'Request was cancelled. Please try again.';
        case DioExceptionType.unknown:
          if (error.error is SocketException) {
            return 'No internet connection. Please check your network and try again.';
          }
          return 'An unexpected error occurred. Please try again.';
        default:
          return 'An unexpected error occurred. Please try again.';
      }
    }
    
    return error.toString();
  }
}
