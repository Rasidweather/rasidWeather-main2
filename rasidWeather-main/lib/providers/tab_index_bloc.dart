import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../features/weather/data/models/weather_model.dart';

class TabIndexBloc extends ChangeNotifier {
  Day? _day;

  Day? get day => _day;

  Hour? _hour;

  Hour? get hour => _hour;

  void selectDayTab(Day day, List<Hour> hours) {
    _day = day;
    _hour = hours.firstWhere((Hour element) => element.forecastStart!.day == day.forecastStart!.day);
    notifyListeners();
  }

  void selectHourTab(Hour hour) {
    _hour = hour;
    notifyListeners();
  }
}
