import 'dart:io';
import 'dart:math';

import 'package:geocoding/geocoding.dart';

class LocationUtils {
  static String generateLocationPreviewImage({required double latitude, required double longitude}) {
    return 'https://maps.googleapis.com/maps/api/staticmap?center=&$latitude,$longitude&zoom=14&size=600x300&maptype=roadmap&marker color=blue%7Clabel:S%7C$latitude,$longitude';
  }

  // convert distance form meter to km
  static String convertDistance(double distance) {
    if (distance < 20) return 'Nearby';
    if (distance < 1000) {
      return '${distance.toStringAsFixed(0)} M';
    } else {
      return '${(distance / 1000).toStringAsFixed(1)} KM';
    }
  }

  // convert distance from lat and long to meter
  static double distanceBetween(double startLatitude, double startLongitude, double endLatitude, double endLongitude) {
    const double p = 0.017453292519943295;
    const double Function(num radians) c = cos;
    final double a =
        0.5 - c((endLatitude - startLatitude) * p) / 2 + c(startLatitude * p) * c(endLatitude * p) * (1 - c((endLongitude - startLongitude) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  static Future<Placemark> locationName(String latitude, String longitude) async {
    try {
      final List<Placemark> address = await placemarkFromCoordinates(
        double.parse(latitude),
        double.parse(longitude),
      );
      final Placemark first = address.first;
      return first;
    } catch (e) {
      return throw '$e';
    }
  }

  static String getGoogleMapUrl(String latitude, String longitude) {
    if (Platform.isAndroid) {
      return 'google.navigation:q=$latitude,$longitude&mode=d';
    } else {
      return 'maps://?saddr=&daddr=$latitude,$longitude&directionsmode=driving';
    }
  }
}
