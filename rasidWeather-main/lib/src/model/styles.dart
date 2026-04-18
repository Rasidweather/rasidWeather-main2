import 'package:flutter/material.dart';

// UI Colors
const Color kColorBar = Colors.black;
const Color kColorText = Colors.white;
const Color kColorAccent = Color.fromRGBO(10, 115, 217, 1.0);
const MaterialColor kColorError = Colors.red;
const MaterialColor kColorSuccess = Colors.green;
const Color kColorNavIcon = Color.fromRGBO(131, 136, 139, 1.0);
const Color kColorBackground = Color.fromRGBO(30, 28, 33, 1.0);

// Weather Colors
const Color kWeatherReallyCold = Color.fromRGBO(3, 75, 132, 1);
const Color kWeatherCold = Color.fromRGBO(0, 39, 96, 1);
const Color kWeatherCloudy = Color.fromRGBO(51, 0, 58, 1);
const Color kWeatherSunny = Color.fromRGBO(212, 70, 62, 1);
const Color kWeatherHot = Color.fromRGBO(181, 0, 58, 1);
const Color kWeatherReallyHot = Color.fromRGBO(204, 0, 58, 1);

// Text Styles
const double kFontSizeSuperSmall = 10.0;
const double kFontSizeNormal = 16.0;
const double kFontSizeMedium = 18.0;
const double kFontSizeLarge = 96.0;

const TextStyle kDescriptionTextStyle = TextStyle(
  color: kColorText,
  fontWeight: FontWeight.normal,
  fontSize: kFontSizeNormal,
);

const TextStyle kTitleTextStyle = TextStyle(
  color: kColorText,
  fontWeight: FontWeight.bold,
  fontSize: kFontSizeMedium,
);

// Inputs
const double kButtonRadius = 10.0;

const InputDecoration userInputDecoration = InputDecoration(
  fillColor: Colors.black,
  filled: true,
  hintText: 'Enter App User ID',
  hintStyle: TextStyle(color: kColorText),
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 0),
    borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
  ),
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(kButtonRadius)),
  ),
);
