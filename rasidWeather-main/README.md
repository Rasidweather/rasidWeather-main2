# RASID Weather ☁️🌦️

A high-performance weather application built with Flutter, providing real-time weather data, forecasts, and interactive maps with optimized performance and beautiful UI.

## 🌟 Key Features

* **High-Performance Architecture**: Optimized for smooth scrolling and minimal memory usage
* **Beautiful Animations**: Dynamic backgrounds that change based on time of day and weather conditions
* **Real-Time Weather Data**: Current conditions with detailed metrics (temperature, humidity, wind, etc.)
* **Interactive Weather Maps**: View precipitation, temperature, and wind patterns on interactive maps
* **Location Management**: Save and manage multiple locations with smart geolocation
* **Detailed Forecasts**:
  * Hourly forecasts with temperature trends
  * 7-day detailed weather outlook
  * Sunrise/sunset times and moon phases
* **Weather Inquiry System**: Chat with weather forecasters for personalized information
* **Multi-language Support**: Full Arabic and English localization
* **Dark Mode**: Automatic and manual theme switching
* **Offline Support**: View previously loaded weather data when offline


## 🌐 Supported Languages

* 🇺🇸 English
* 🇸🇦 Arabic (العربية)

## 🚀 Performance Optimizations

### Memory Management
* Implemented WeakReferences for caching weather data to prevent memory leaks
* Added proper lifecycle management for background/foreground transitions
* Optimized image caching with specific dimensions

### UI Performance
* Used RepaintBoundary to isolate painting operations
* Implemented widget keys for proper recycling
* Converted complex StatefulWidgets to StatelessWidgets where appropriate
* Optimized BlocBuilder with precise buildWhen conditions

### Network Efficiency
* Added retry logic with exponential backoff for network failures
* Implemented caching strategies to show data during loading states
* Added proper error handling with meaningful error messages

### Resource Management
* Limited the number of items created to prevent excessive widget creation
* Optimized background animations with quality controls
* Implemented proper scroll controller management with disposal

## 🔧 Technical Stack

* **Framework**: Flutter
* **State Management**: BLoC/Cubit
* **APIs**: OpenWeatherMap API, Geonames API
* **Storage**: SQFLite, SharedPreferences
* **Localization**: easy_localization
* **Maps**: flutter_map
* **Animations**: Lottie

## 📋 Requirements

* Flutter 3.0+
* Dart 2.17+
* Android: minSdkVersion 21
* iOS: iOS 11+# weather

## 💳 RevenueCat Web Purchase Links (Android)

1) Generate your Web Purchase Links in the RevenueCat dashboard.
2) Update `androidWebPurchaseLinkBase` in `lib/constant.dart`.
3) If you have multiple plans, add a mapping in
   `androidWebPurchaseLinksById` keyed by package or product identifier.
4) The Android flow appends `app_user_id=user_{DB_ID}` automatically.
# weather
# weather
# weather
# weather
# rasidWeather-main2
# rasidWeather-main2
