import 'dart:math';

import 'package:flutter/material.dart';

import 'styles.dart';


enum TemperatureUnit { f, c }

enum Environment {
  mercury,
  venus,
  earth,
  mars,
  jupiter,
  saturn,
  uranus,
  neptune,
  pluto
}


class WeatherData {

  WeatherData({
    required this.emoji,
    required this.weatherColor,
    required this.temperature,
    required this.unit,
    required this.environment,
  });
  final String emoji;
  final Color weatherColor;
  final String temperature;
  final TemperatureUnit unit;
  final Environment environment;

  static WeatherData testCold = WeatherData(
    emoji: '🥶',
    weatherColor: kWeatherReallyCold,
    temperature: '14',
    unit: TemperatureUnit.f,
    environment: Environment.earth,
  );

  static WeatherData generateData() {
    const int min = -20;
    const int max = 120;
    final int randomTemperature = min + Random().nextInt(max - min);

    String emoji;
    Color weatherColor;

    if (randomTemperature < 0) {
      emoji = '🥶';
      weatherColor = kWeatherReallyCold;
    } else if (randomTemperature < 32) {
      emoji = '❄️';
      weatherColor = kWeatherCold;
    } else if (randomTemperature < 60) {
      emoji = '☁️';
      weatherColor = kWeatherCloudy;
    } else if (randomTemperature < 90) {
      emoji = '🌤';
      weatherColor = kWeatherSunny;
    } else if (randomTemperature < 129) {
      emoji = '🥵';
      weatherColor = kWeatherHot;
    } else {
      emoji = '☄️';
      weatherColor = kWeatherReallyHot;
    }

    return WeatherData(
      emoji: emoji,
      weatherColor: weatherColor,
      temperature: randomTemperature.toString(),
      unit: TemperatureUnit.f,
      environment: Environment.earth,
    );
  }
}
