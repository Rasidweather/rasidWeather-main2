import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/constants/index.dart';
import '../../core/constants/app_keys.dart';
import '../../core/network/dio_helper.dart';
import '../datasource/remote/exception/api_error_handler.dart';
import '../model/base/api_response.dart';

class SplashRepo {
  SplashRepo({required this.sharedPreferences, required this.dioClient});
  final DioClient dioClient;
  final SharedPreferences sharedPreferences;

  Future<ApiResponse> getConfig() async {
    try {
      final Response<dynamic> response = await dioClient.get(AppStrings.configUrl);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  // save config data to shared preferences
  Future<bool> saveConfigData(Map<String, dynamic> data) {
    return sharedPreferences.setString(AppKeys.config, jsonEncode(data));
  }

  // get config data from shared preferences
  Map<String, dynamic>? getConfigData() {
    final String? data = sharedPreferences.getString(AppKeys.config);
    return jsonDecode(data!) as Map<String, dynamic>;
  }

  Future<bool> initSharedData() {
    if (!sharedPreferences.containsKey(AppKeys.theme)) {
      return sharedPreferences.setBool(AppKeys.theme, false);
    }
    if (!sharedPreferences.containsKey(AppKeys.countryCode)) {
      return sharedPreferences.setString(AppKeys.countryCode, 'EG');
    }
    // if(!sharedPreferences.containsKey(AppConstants.LANGUAGE_CODE)) {
    //   return sharedPreferences.setString(AppConstants.LANGUAGE_CODE, AppConstants.languages[0].languageCode);
    // }
    if (!sharedPreferences.containsKey(AppKeys.locationList)) {
      return sharedPreferences.setStringList(AppKeys.locationList, <String>[]);
    }
    return Future.value(true);
  }

  Future<bool> removeSharedData() {
    return sharedPreferences.clear();
  }

  // reportPost
  Future<ApiResponse> sendReport(Map<String, dynamic> params) async {
    try {
      final Response<dynamic> response = await dioClient.post(AppStrings.reportsUrl, data: params);
      return ApiResponse.withSuccess(response);
    } on DioException catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
    }
  }

  Future<bool> setIntroPageDone() async {
    await sharedPreferences.setBool(AppKeys.introPageDoneKey, true);
    return true;
  }

  // get intro page done
  bool getIntroPageDone() {
    final bool? data = sharedPreferences.getBool(AppKeys.introPageDoneKey);
    return data ?? false;
  }

  // Set language selection done
  Future<bool> setLanguageSelectionDone() async {
    await sharedPreferences.setBool(AppKeys.languageSelectionDoneKey, true);
    return true;
  }

  // Check if language selection is done
  bool getLanguageSelectionDone() {
    final bool? data = sharedPreferences.getBool(AppKeys.languageSelectionDoneKey);
    return data ?? false;
  }

  // Save the app language
  Future<bool> saveLanguage(String languageCode) async {
    return sharedPreferences.setString(AppKeys.language, languageCode);
  }
  
  // Get the saved language
  String? getSavedLanguage() {
    return sharedPreferences.getString(AppKeys.language);
  }
}
