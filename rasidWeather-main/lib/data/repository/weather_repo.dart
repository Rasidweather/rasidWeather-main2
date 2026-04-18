import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:geocoding/geocoding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest.dart' as tz;

import '../../core/network/dio_helper.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base/api_response.dart';
import '../model/timezone_model.dart';
import '../models/countries_data.dart';

/// Weather Repository - Handles all weather-related API requests
/// Provides functions to get weather data, charts, and timezone information
class WeatherRepo {

  WeatherRepo({
    required this.sharedPreferences,
    required this.dioClient,
  }) {
    _initializeTimezones();
  }
  static bool _timezonesInitialized = false;

  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  void _initializeTimezones() {
    if (!_timezonesInitialized) {
      tz.initializeTimeZones();
      _timezonesInitialized = true;
    }
  }

  /// Get weather data for a specific location
  /// @param countryCode Country code (optional)
  /// @param latitude Latitude (must be between -90 and 90)
  /// @param longitude Longitude (must be between -180 and 180)
  /// @return ApiResponse containing weather data
  Future<ApiResponse> getWeatherData({
    required String? countryCode,
    required double latitude,
    required double longitude,
  }) async {
    _initializeTimezones();

    // Validate coordinates
    assert(latitude >= -90 && latitude <= 90, 'Latitude must be between -90 and 90');
    assert(longitude >= -180 && longitude <= 180, 'Longitude must be between -180 and 180');

    try {
      // Get timezone for the location
      final TimezoneModel timezone = await getTimezone(latitude.toString(), longitude.toString());
      
      // Build URL with required parameters
      String url = '/weather?latitude=$latitude&longitude=$longitude&timezone=${timezone.timezoneId}';
      if (countryCode != null) {
        url = '$url&country_code=${countryCode.toLowerCase()}';
        if (kDebugMode) {
          print('Request URL: $url');
        }
      }

      final Response<dynamic> response = await dioClient.get(url);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  /// Get timezone using latitude and longitude
  /// @param lat Latitude
  /// @param lon Longitude
  /// @return TimezoneModel containing timezone information
  Future<TimezoneModel> getTimezone(String lat, String lon) async {
    try {
      _initializeTimezones();
      
      final double latitude = double.parse(lat);
      final double longitude = double.parse(lon);

      // Get location information using geocoding
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isEmpty) {
        return _getFallbackTimezone(lat, lon);
      }

      final Placemark place = placemarks.first;
      final String countryCode = place.isoCountryCode?.toUpperCase() ?? 'SA';
      
      // Get timezone info from CountriesData
      final Map<String, dynamic>? countryInfo = CountriesData.COUNTRIES_INFO[countryCode];
      
      if (countryInfo == null) {
        return _getFallbackTimezone(lat, lon);
      }

      return TimezoneModel(
        sunrise: DateTime.now().add(const Duration(hours: 6)).toString(),
        lng: longitude,
        countryCode: countryCode,
        gmtOffset: countryInfo['gmtOffset']?.toString() ?? '3',
        rawOffset: countryInfo['rawOffset']?.toString() ?? '3',
        sunset: DateTime.now().add(const Duration(hours: 18)).toString(),
        timezoneId: countryInfo['timezone']?.toString() ?? 'Asia/Riyadh',
        dstOffset: '0',
        countryName: place.country ?? countryInfo['arabic_name']?.toString() ?? 'السعودية',
        time: DateTime.now().toString(),
        lat: latitude,
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error getting timezone: $e');
      }
      return _getFallbackTimezone(lat, lon);
    }
  }

  TimezoneModel _getFallbackTimezone(String lat, String lon) {
    final DateTime now = DateTime.now();
    final Map<String, dynamic> saudiInfo = CountriesData.COUNTRIES_INFO['SA']!;
    
    return TimezoneModel(
      sunrise: now.add(const Duration(hours: 6)).toString(),
      lng: double.parse(lon),
      countryCode: 'SA',
      gmtOffset: saudiInfo['gmtOffset'].toString(),
      rawOffset: saudiInfo['rawOffset'].toString(),
      sunset: now.add(const Duration(hours: 18)).toString(),
      timezoneId: saudiInfo['timezone'].toString(),
      dstOffset: '0',
      countryName: saudiInfo['arabic_name'].toString(),
      time: now.toString(),
      lat: double.parse(lat),
    );
  }

  /// Get chart data for a specific location
  /// @param countryCode Country code (optional)
  /// @param latitude Latitude
  /// @param longitude Longitude
  /// @return ApiResponse containing chart data
  Future<ApiResponse> getChartData({
    required String? countryCode,
    required double latitude,
    required double longitude,
  }) async {
    _initializeTimezones();

    // Validate coordinates
    assert(latitude >= -90 && latitude <= 90, 'Latitude must be between -90 and 90');
    assert(longitude >= -180 && longitude <= 180, 'Longitude must be between -180 and 180');

    try {
      final TimezoneModel timezone = await getTimezone(latitude.toString(), longitude.toString());
      
      // Build chart URL
      String url = '/weather/chart?latitude=$latitude&longitude=$longitude&timezone=${timezone.timezoneId}';
      if (countryCode != null) {
        url = '$url&country_code=${timezone.countryCode!.toLowerCase()}';
      }

      final Response<dynamic> response = await dioClient.get(url);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }
}
