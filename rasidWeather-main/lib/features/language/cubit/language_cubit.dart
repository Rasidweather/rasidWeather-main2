import 'dart:ui' as ui;
import 'package:bloc/bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/app_keys.dart';
import '../../../core/network/dio_helper.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit(this._prefs, this._dioClient) : super(const LanguageState(Locale('ar'))) {
    _initLanguage();
  }

  final SharedPreferences _prefs;
  final DioClient _dioClient;

  Future<void> _initLanguage() async {
    final String? savedLanguage = _prefs.getString(AppKeys.language);
    if (savedLanguage != null) {
      emit(LanguageState(Locale(savedLanguage)));
      _dioClient.updateHeader(language: savedLanguage);
    } else {
      // If no saved language, use device language
      final String deviceLanguage = getDeviceLanguage();
      emit(LanguageState(Locale(deviceLanguage)));
      await _prefs.setString(AppKeys.language, deviceLanguage);
      _dioClient.updateHeader(language: deviceLanguage);
    }
  }

  /// Detects the device's language and returns a supported language code
  String getDeviceLanguage() {
    // Get device locale from UI
    final Locale deviceLocale = ui.window.locale;
    final String languageCode = deviceLocale.languageCode;

    // Check if the device locale is supported (ar or en)
    if (languageCode == 'ar') {
      return 'ar';
    } else {
      // Default to English for any other language
      return 'en';
    }
  }

  Future<void> changeLanguage(BuildContext context, String languageCode) async {
    final Locale locale = Locale(languageCode);

    // Save the language preference
    await _prefs.setString(AppKeys.language, languageCode);

    // Update the locale in EasyLocalization
    await context.setLocale(locale);

    // Update the state and dio headers
    emit(LanguageState(locale));
    _dioClient.updateHeader(language: languageCode);

    // No need to force navigation or show snackbar for a smoother experience
  }

  String getCurrentLanguage() => state.locale.languageCode;

  bool isArabic() => getCurrentLanguage() == 'ar';

  bool isEnglish() => getCurrentLanguage() == 'en';
}
