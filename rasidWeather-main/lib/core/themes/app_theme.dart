import 'package:flutter/material.dart';

import '../../common/helper/md2_tab_indicator.dart';
import '../../utils/common_utils.dart';


Color _primaryColor = const Color(0xff2BB0DD);
Color _secondaryColor = Colors.grey[900]!;
Color _disabledColor = Color.fromRGBO(
  _primaryColor.red,
  _primaryColor.green,
  _primaryColor.blue,
  0.5,
);
Color _disabledTextColor = const Color.fromRGBO(255, 255, 255, 0.3);
Color _successColor = AppTheme.primaryColor;
Color _warningColor = Colors.yellow[700]!;
Color _dangerColor = Colors.red[700]!;
Color _infoColor = Colors.lightBlue;
Color _whiteColor = Colors.white;

class AppTheme {
  static Color get primaryColor => _primaryColor;

  static Color get secondaryColor => _secondaryColor;

  static Color get disabledColor => _disabledColor;

  static Color get disabledTextColor => _disabledTextColor;

  static Color get successColor => _successColor;

  static Color get warningColor => _warningColor;

  static Color get dangerColor => _dangerColor;

  static Color get infoColor => _infoColor;

  static Color get whiteColor => _whiteColor;

  static List<Color> getComplimentaryColors({double opacity = 1.0}) => <Color>[
    Color.fromRGBO(35, 182, 230, opacity),
    Color.fromRGBO(2, 211, 154, opacity),
  ];

  static Color? getFadedTextColor({bool colorTheme = false}) =>
      colorTheme ? const Color.fromRGBO(255, 255, 255, 0.75) : Colors.grey[500];

  static Color getBorderColor(ThemeMode themeMode, {bool colorTheme = false}) =>
      (themeMode == ThemeMode.dark)
      ? const Color.fromRGBO(0, 0, 0, 0.05)
      : colorTheme
      ? const Color.fromRGBO(0, 0, 0, 0.1)
      : Color.fromRGBO(
          secondaryColor.red,
          secondaryColor.green,
          secondaryColor.blue,
          0.1,
        );

  static Color? getHintColor(ThemeMode themeMode, {bool colorTheme = false}) =>
      colorTheme
      ? const Color.fromRGBO(255, 255, 255, 0.7)
      : (themeMode == ThemeMode.dark)
      ? Colors.grey[500]
      : Colors.grey[400];

  static Color? getSectionColor(ThemeMode themeMode) =>
      (themeMode == ThemeMode.dark)
      ? const Color.fromRGBO(0, 0, 0, 0.3)
      : Colors.grey[200];

  static Color? getRadioActiveColor(ThemeMode themeMode) =>
      (themeMode == ThemeMode.dark) ? Colors.white : Colors.grey[700];

  static Color? getRadioInactiveColor(ThemeMode themeMode) =>
      (themeMode == ThemeMode.dark) ? Colors.grey[700] : Colors.grey[300];
}

ThemeData appLightThemeData(BuildContext context) {
  return ThemeData(
    fontFamily: 'DINNextLTArabic',
    primaryColor: const Color(0xff2BB0DD),
    secondaryHeaderColor: const Color(0xff52C6F6),
    primaryColorLight: Colors.white,
    scaffoldBackgroundColor: const Color(0xffF6F6F6),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xffF6F6F6),
      elevation: 0,
    ),
    shadowColor: Colors.black26,
    useMaterial3: true,
    cardTheme: CardThemeData(
      elevation: 5,
      shadowColor: Colors.black26,
      color: const Color(0xffffffff),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    ),
    tabBarTheme: TabBarThemeData(
      dividerColor: Colors.transparent,
      indicatorSize: TabBarIndicatorSize.label,
      labelColor: const Color(0xff3D3C3C),
      labelStyle: const TextStyle(
        fontFamily: 'DINNextLTArabic',
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelStyle: const TextStyle(
        fontFamily: 'DINNextLTArabic',
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
      unselectedLabelColor: const Color(0xff5f6368),
      indicator: MD2Indicator(
        indicatorHeight: 2,
        indicatorColor: Theme.of(context).primaryColor,
        indicatorSize: MD2IndicatorSize.normal,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(10.0),
      isDense: true,
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: AppTheme.primaryColor, width: 2.0),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color.fromRGBO(
            AppTheme.primaryColor.red,
            AppTheme.primaryColor.green,
            AppTheme.primaryColor.blue,
            0.1,
          ),
          width: 2.0,
        ),
      ),
      errorBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.red[800]!, width: 2.0),
      ),
      errorStyle: TextStyle(color: Colors.red[800]),
    ),
    colorScheme: ColorScheme.fromSeed(
      surfaceTint: Colors.white,
      seedColor: const Color(0xff2BB0DD),
    ).copyWith(surface: Colors.white),
  );
}

ThemeData appColorThemeData = ThemeData(
  hintColor: Colors.white,
  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: Colors.white,
    foregroundColor: AppTheme.secondaryColor,
    elevation: 0.0,
  ),
  iconTheme: const IconThemeData(color: Colors.white),
  textTheme: _lightTextTheme.copyWith(
    titleLarge: TextStyle(
      color: AppTheme.secondaryColor,
      fontSize: 16.0,
      height: 0.9,
    ),
    titleMedium: TextStyle(color: Colors.grey[700]),
  ),
);

TextTheme _lightTextTheme = TextTheme(
  displayLarge: TextStyle(
    fontFamily: 'DINNextLTArabic',
    color: Colors.white,
    fontSize: 70.0,
    fontWeight: FontWeight.w100,
    height: 0.9,
    shadows: commonTextShadow(),
  ),
  displaySmall: TextStyle(
    fontFamily: 'DINNextLTArabic',
    color: Colors.white,
    fontSize: 40.0,
    fontWeight: FontWeight.w300,
    shadows: commonTextShadow(),
  ),
  headlineMedium: TextStyle(
    fontFamily: 'DINNextLTArabic',
    color: const Color.fromRGBO(255, 255, 255, 0.9),
    fontSize: 24.0,
    fontWeight: FontWeight.w300,
    height: 0.9,
    shadows: commonTextShadow(),
  ),
  headlineSmall: const TextStyle(
    fontFamily: 'DINNextLTArabic',
    color: Color.fromRGBO(255, 255, 255, 0.9),
    fontSize: 16.0,
    height: 0.9,
    fontWeight: FontWeight.w400,
  ),
  titleLarge: const TextStyle(
    fontFamily: 'DINNextLTArabic',
    color: Colors.white,
    fontSize: 16.0,
    height: 0.9,
  ),
  titleMedium: const TextStyle(
    fontFamily: 'DINNextLTArabic',
    color: Colors.white,
  ),
  titleSmall: TextStyle(
    fontFamily: 'DINNextLTArabic',
    color: const Color.fromRGBO(255, 255, 255, 0.9),
    fontSize: 11.0,
    fontWeight: FontWeight.w400,
    shadows: commonTextShadow(color: Colors.black12, blurRadius: 0.1),
  ),
);
