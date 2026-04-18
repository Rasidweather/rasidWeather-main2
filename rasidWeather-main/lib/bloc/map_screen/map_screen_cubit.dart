import 'dart:isolate';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../features/cities/data/models/city_model.dart';
import 'map_screen_state.dart';

class MapScreenCubit extends Cubit<MapScreenState> {

  MapScreenCubit() : super(const MapScreenState());
  Isolate? _isolate;
  ReceivePort? _receivePort;

  void setWebViewReady(bool isReady) {
    emit(state.copyWith(isWebViewReady: isReady));
  }

  Future<void> processMapData(CityModel city) async {
    _receivePort = ReceivePort();

    try {
      _isolate = await Isolate.spawn(
        _isolateProcessMapData,
        _MapIsolateData(
          sendPort: _receivePort!.sendPort,
          cityLatitude: city.latitude!,
          cityLongitude: city.longitude!,
        ),
      );

      _receivePort!.listen((message) {
        if (message is String) {
          emit(state.copyWith(processedMapUrl: message));
        }
        _cleanupIsolate();
      });
    } catch (e) {
      debugPrint('Error starting isolate for map data: $e');
      final String fallbackUrl = 
          'https://www.meteoblue.com/ar/weather/maps#coords=4/${city.latitude}/${city.longitude}&map=windAnimation~rainbow~auto~10%20m%20above%20gnd~none';
      emit(state.copyWith(processedMapUrl: fallbackUrl));
    }
  }

  void _cleanupIsolate() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _receivePort?.close();
    _receivePort = null;
  }

  static Future<void> _isolateProcessMapData(_MapIsolateData data) async {
    try {
      final String url =
          'https://www.meteoblue.com/ar/weather/maps#coords=4/${data.cityLatitude}/${data.cityLongitude}&map=windAnimation~rainbow~auto~10%20m%20above%20gnd~none';

      await Future<void>.delayed(const Duration(milliseconds: 100));
      data.sendPort.send(url);
    } catch (e) {
      data.sendPort.send('https://www.meteoblue.com/ar/weather/maps');
    }
  }

  @override
  Future<void> close() {
    _cleanupIsolate();
    return super.close();
  }
}

class _MapIsolateData {
  _MapIsolateData({
    required this.sendPort,
    required this.cityLatitude,
    required this.cityLongitude,
  });

  final SendPort sendPort;
  final String cityLatitude;
  final String cityLongitude;
}
