import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class WeatherConditionLocalizer {
  // ✅ ضيف هون كل احتمالاتكم (عربي -> إنجليزي)
  static const Map<String, String> _arToEn = <String, String>{
    'صافي': 'Clear',
    'مشمس': 'Sunny',
    'غائم': 'Cloudy',
    'غائم كلياً': 'Overcast',
    'جزئياً غائم': 'Partly Cloudy',
    'غيوم متفرقة': 'Scattered Clouds',

    'أمطار': 'Rain',
    'مطر': 'Rain',
    'زخات': 'Showers',
    'زخات مطر': 'Rain Showers',
    'رذاذ': 'Drizzle',

    'عاصف': 'Stormy',
    'عواصف رعدية': 'Thunderstorms',
    'رعد': 'Thunder',

    'ضباب': 'Fog',
    'غبار': 'Dust',
    'عاصفة ترابية': 'Dust Storm',

    'ثلج': 'Snow',
    'تساقط ثلوج': 'Snowfall',
    'برد': 'Hail',

    'رياح': 'Windy',
    'رياح شديدة': 'Very Windy',
    'معتدل': 'Mild',
    'بارد': 'Cold',
    'حار': 'Hot',
  };

  static bool _isArabic(BuildContext context) {
    return context.locale.languageCode.toLowerCase().startsWith('ar');
  }

  static String localize(BuildContext context, String? backendName) {
    if (backendName == null) return '';

    final String raw = backendName.trim();
    if (raw.isEmpty) return '';

    if (_isArabic(context)) return raw;

    return _arToEn[raw] ?? raw;
  }

  static String localizeUpperIfEnglish(BuildContext context, String? backendName) {
    final String text = localize(context, backendName);
    if (_isArabic(context)) return text;
    return text.toUpperCase();
  }
}
