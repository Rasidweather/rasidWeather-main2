import 'weather_data.dart';

class AppData {

  factory AppData() {
    return _appData;
  }
  AppData._internal();
  static final AppData _appData = AppData._internal();

  bool entitlementIsActive = false;
  String appUserID = '';
  WeatherData currentData = WeatherData.testCold;
}

final AppData appData = AppData();
