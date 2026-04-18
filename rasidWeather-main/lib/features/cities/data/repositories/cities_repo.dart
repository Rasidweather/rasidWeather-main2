import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../common/constants/strings.dart';
import '../../../../core/constants/app_keys.dart';
import '../../../../core/network/dio_helper.dart';
import '../../../../data/model/search_model.dart';
import '../../../../data/models/countries_data.dart';
import '../../../../main.dart';
import '../../../../utils/ui_utils.dart';
import '../../domain/repositories/i_cities_repository.dart';
import '../models/city_model.dart';

class CitiesRepo implements ICitiesRepository {
  CitiesRepo(
      {required this.firebaseMessaging,
      required this.dioClient,
      required this.sharedPreferences});

  final SharedPreferences sharedPreferences;
  final DioClient dioClient;
  final FirebaseMessaging firebaseMessaging;

  Future<String> _getTimezone(String countryCode) async {
    return CountriesData.COUNTRIES_INFO[countryCode]!['timezone'].toString();
  }

  @override
  Future<List<CityModel>> getCities() async {
    try {
      final Object? locationsDecoded =
          sharedPreferences.get(AppKeys.locationList);
      final List<CityModel> locations =
          CityModel.decode(locationsDecoded.toString());

      // Check and update timezone for cities where it's null
      bool hasUpdates = false;
      for (final CityModel city in locations) {
        // if (city.timezone == null || city.timezone!.isEmpty) {
        // TODO(MohamedSleem): Update timezone for all cities is temporary solution for now
        /// this solution only updates timezone for cities added before.
        /// new cities will not need timezone update.
        ///
        final String timezone = await _getTimezone(city.countryCode!);

        final int index = locations.indexOf(city);
        locations[index] = city.copyWith(timezone: timezone);
        hasUpdates = true;
      }
      // }

      // Save updates if any timezone was updated
      if (hasUpdates) {
        await sharedPreferences.setString(
            AppKeys.locationList, CityModel.encode(locations));
      }

      return locations.reversed.toList();
    } catch (e) {
      return <CityModel>[];
    }
  }

  @override
  Future<void> removeCity(String id) async {
    final Object? locationsDecoded =
        sharedPreferences.get(AppKeys.locationList);
    final List<CityModel> locations =
        CityModel.decode(locationsDecoded.toString());
    for (final CityModel element in locations) {
      if (element.locationId == id) {
        locations.remove(element);
        firebaseMessaging
            .unsubscribeFromTopic(
                'country_${element.countryCode!.toLowerCase()}')
            .onError((Object? error, StackTrace stackTrace) => false)
            .then((value) {
          printLog(
              'topic unsubscribed country_${element.countryCode!.toLowerCase()}');
          return true;
        });
        sharedPreferences.setString(
            AppKeys.locationList, CityModel.encode(locations));
      }
    }
  }

  @override
  Future<void> addCity(CityModel geoname) async {
    final Object? locationsDecoded =
        sharedPreferences.get(AppKeys.locationList);
    final List<CityModel> locations;
    if (locationsDecoded == null) {
      locations = <CityModel>[];
    } else {
      locations = CityModel.decode(locationsDecoded.toString());
    }
    for (final CityModel item in locations) {
      if (item.locationId == geoname.id) {
        throw Exception('cities.exists'.tr());
      }
    }
    final CityModel location = CityModel(
      locationId: geoname.locationId.toString(),
      name: geoname.name,
      latitude: geoname.latitude,
      longitude: geoname.longitude,
      countryCode: geoname.countryCode,
      countryName: geoname.countryName,
      isSelected: false,
      createdAt: DateTime.now(),
      timezone: await _getTimezone(geoname.countryCode!),
    );
    locations.add(location);
    sharedPreferences.setString(
        AppKeys.locationList, CityModel.encode(locations));
  }

  @override
  Future<void> selectCity(String id) async {
    final Object? locationsDecoded =
        sharedPreferences.get(AppKeys.locationList);
    final List<CityModel> locations =
        CityModel.decode(locationsDecoded.toString());
    for (final CityModel element in locations) {
      if (element.locationId == id) {
        if (element.timezone == null) {
          await _update(element);
        }
        element.isSelected = true;
        firebaseMessaging
            .subscribeToTopic('country_${element.countryCode!.toLowerCase()}')
            .onError((Object? error, StackTrace stackTrace) => false)
            .then((value) {
          printLog(
              'topic subscribed country_${element.countryCode!.toLowerCase()}');
          return true;
        });
      } else {
        element.isSelected = false;
        firebaseMessaging
            .unsubscribeFromTopic(
                'country_${element.countryCode!.toLowerCase()}')
            .onError((Object? error, StackTrace stackTrace) => false)
            .then((value) {
          printLog(
              'topic unsubscribed country_${element.countryCode!.toLowerCase()}');
          return true;
        });
      }
    }
    sharedPreferences.setString(
        AppKeys.locationList, CityModel.encode(locations));
  }

  @override
  Future<List<Geoname>> searchCity(String text) async {
    try {
      final String lang = Get.context?.locale.languageCode ?? 'en';
      final String url = AppStrings.searchUrl(text, lang);
      
      printLog('Searching cities with URL: $url'); // Add logging
      
      final http.Response response = await http.get(Uri.parse(url));
      
      if (response.statusCode != 200) {
        printLog('Search API error: ${response.statusCode} - ${response.body}');
        throw Exception('API Error: ${response.statusCode}');
      }
      
      final String body = const Utf8Decoder().convert(response.bodyBytes);
      final data = jsonDecode(body);
      
      if (data['status'] != null && data['status']['message'] != null) {
        printLog('Geonames API error: ${data['status']['message']}');
        throw Exception('Geonames API error: ${data['status']['message']}');
      }
      
      if (data['geonames'] == null) {
        printLog('No geonames data in response');
        return <Geoname>[];
      }
      
      final List<dynamic> geonamesData = data['geonames'] as List<dynamic>;
      final List<Geoname> geoname = geonamesData
          .map((dynamic item) => Geoname.fromJson(item as Map<String, dynamic>))
          .where((Geoname element) => element.countryCode != null)
          .toList();
      
      printLog('Found ${geoname.length} cities');
      return geoname;
    } catch (e, stackTrace) {
      printLog('Error searching cities: $e\n$stackTrace');
      // Return empty list instead of throwing to prevent app crashes
      return <Geoname>[];
    }
  }

  @override
  Future<CityModel> getCurrentLocation() async {
    try {
      // First, explicitly request location permission using Permission Handler
      // This is more reliable on Android than the Geolocator permission request
      final PermissionStatus status = await Permission.location.request();

      if (status.isDenied || status.isPermanentlyDenied) {
        // If permission is denied, guide the user
        if (status.isPermanentlyDenied) {
          // Open app settings if permanently denied
          await openAppSettings();
          return Future<CityModel>.error(
            'Location permissions are permanently denied. Please enable location permissions in app settings.',
          );
        } else {
          return Future<CityModel>.error('Location permissions are denied');
        }
      }

      // Now check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // On Android, this will open the location settings
        final bool opened = await Geolocator.openLocationSettings();

        // Give the user time to enable location services
        if (opened) {
          // Wait a moment for the user to potentially enable location
          await Future<void>.delayed(const Duration(seconds: 2));

          // Check again after user returns from settings
          serviceEnabled = await Geolocator.isLocationServiceEnabled();
          if (!serviceEnabled) {
            return Future<CityModel>.error('Location services are disabled.');
          }
        } else {
          return Future<CityModel>.error('Could not open location settings.');
        }
      }

      // Double-check location permission with Geolocator
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        permission = await Geolocator.requestPermission();

        if (permission == LocationPermission.denied ||
            permission == LocationPermission.deniedForever) {
          return Future<CityModel>.error(
              'Location permissions are denied after multiple requests.');
        }
      }

      printLog('Getting current position...');

      // Get current position with high accuracy but with a timeout
      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 20),
      );

      printLog(
          'Position obtained: ${position.latitude}, ${position.longitude}');

      // Get location details from coordinates
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      printLog('Placemarks obtained: ${placemarks.length}');

      if (placemarks.isEmpty) {
        return Future<CityModel>.error('Could not determine location name.');
      }

      final Placemark placemark = placemarks.first;
      printLog('Placemark: $placemark');

      // Determine the best name for the location
      String locationName = placemark.locality ?? '';
      printLog('Initial location name: $locationName');

      if (locationName.isEmpty) {
        locationName = placemark.subAdministrativeArea ?? '';
        printLog('Using subAdministrativeArea: $locationName');
      }
      if (locationName.isEmpty) {
        locationName = placemark.administrativeArea ?? '';
        printLog('Using administrativeArea: $locationName');
      }
      if (locationName.isEmpty) {
        locationName =
            '${position.latitude.toStringAsFixed(2)}, ${position.longitude.toStringAsFixed(2)}';
        printLog('Using coordinates as name: $locationName');
      }

      final String locationId =
          'lat=${position.latitude}&lon=${position.longitude}';
      printLog('Location ID: $locationId');

      // Check if this location already exists
      final Object? locationsDecoded =
          sharedPreferences.get(AppKeys.locationList);
      final List<CityModel> locations;
      if (locationsDecoded == null) {
        locations = <CityModel>[];
        printLog('No existing locations found');
      } else {
        locations = CityModel.decode(locationsDecoded.toString());
        printLog('Found ${locations.length} existing locations');
      }

      // Check if location already exists
      for (final CityModel item in locations) {
        if (item.locationId == locationId) {
          printLog('Location already exists, selecting it');
          // If it exists, just select it instead of throwing an error
          await selectCity(item.locationId!);
          return item;
        }
      }

      // Get country code, defaulting to 'SA' if not available
      final String countryCode = placemark.isoCountryCode ?? 'SA';
      printLog('Country code: $countryCode');

      // Create new city model
      final CityModel city = CityModel(
        locationId: locationId,
        name: locationName,
        isSelected: false,
        latitude: position.latitude.toString(),
        longitude: position.longitude.toString(),
        createdAt: DateTime.now(),
        countryCode: countryCode,
        countryName: placemark.country ?? 'Unknown',
        timezone: await _getTimezone(countryCode),
      );

      printLog('Created new city model: ${city.name}');

      // Add the new city and save
      locations.add(city);
      await sharedPreferences.setString(
          AppKeys.locationList, CityModel.encode(locations));
      printLog('Saved new city to preferences');

      // Select the new city
      await selectCity(city.locationId!);
      printLog('Selected the new city');

      return city;
    } catch (e, stackTrace) {
      printLog('Error getting current location: $e');
      printLog('Stack trace: $stackTrace');
      return Future<CityModel>.error('Failed to get location: $e');
    }
  }

  // get selected city from shared preferences
  @override
  Future<CityModel?> getSelectedCity() async {
    final Object? locationsDecoded =
        sharedPreferences.get(AppKeys.locationList);
    final List<CityModel> locations =
        CityModel.decode(locationsDecoded.toString());
    for (final CityModel element in locations) {
      if (element.isSelected!) {
        if (element.timezone == null) {
          await _update(element);
        }
        return element;
      }
    }
    return null;
  }

  Future<void> _update(CityModel item) async {
    final String timezone = await _getTimezone(item.countryCode!);
    CityModel().copyWith(timezone: timezone);
    await sharedPreferences.setString(
        AppKeys.locationList, CityModel.encode(<CityModel>[item]));
  }

  @override
  Future<void> update(CityModel item) async {
    final String timezone = await _getTimezone(item.countryCode!);
    CityModel().copyWith(timezone: timezone);
    await sharedPreferences.setString(
        AppKeys.locationList, CityModel.encode(<CityModel>[item]));
  }

  @override
  Future<void> delete(String id) {
    throw UnimplementedError();
  }

  @override
  Future<List<CityModel>> getAll() {
    throw UnimplementedError();
  }

  @override
  Future<CityModel?> getById(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> create(CityModel item) {
    throw UnimplementedError();
  }
}
