import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../features/weather/data/models/weather_model.dart';

part 'ui_state.dart';

class UiCubit extends Cubit<UiState> {
  UiCubit() : super(const UiInitial());
  
  Appearance? _lastAppearance;

  static const Appearance defaultAppearance = Appearance(
    background: <String>['#1E88E5', '#1565C0'],
    stops: <double>[0.0, 1.0],
    cardBackground: '#ffffff',
    textColor: '#ffffff',
    buttonColor: '#ffffff',
  );

  static const Appearance defaultVideoAppearance = Appearance(
    background: <String>['#1E88E5', '#1565C0'],
    backgroundVideo: 'https://rasidweather.com/images/svg/lottie/clear-day.json',
    type: 'video',
    stops: <double>[0.0, 1.0],
    cardBackground: '#ffffff',
    textColor: '#ffffff',
    buttonColor: '#ffffff',
  );
  
  void changeAppTheme(Appearance colorModel) {
    if (_lastAppearance != null && _lastAppearance == colorModel) {
      debugPrint('UiCubit: Skipping identical appearance update');
      return;
    }
    
    _lastAppearance = colorModel;
    
    emit(UiThemeChanged(colorModel));
  }
  
  void resetTheme() {
    changeAppTheme(defaultAppearance);
  }
  
  Appearance get currentAppearance {
    final UiState state = this.state;
    return state is UiThemeChanged ? state.colorModel : defaultAppearance;
  }
}
