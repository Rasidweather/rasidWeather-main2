import '../../../../core/repositories/base_repository.dart';
import '../../../../data/model/search_model.dart';
import '../../data/models/city_model.dart';

abstract class ICitiesRepository extends BaseRepository<CityModel> {
  /// Get list of all cities
  Future<List<CityModel>> getCities();
  
  /// Add a new city
  Future<void> addCity(CityModel geoname);
  
  /// Remove a city by its ID
  Future<void> removeCity(String cityId);
  
  /// Select a city as current by its ID
  Future<void> selectCity(String cityId);
  
  /// Search for cities by query
  Future<List<Geoname>> searchCity(String query);
  
  /// Get the currently selected city
  Future<CityModel?> getSelectedCity();
  
  /// Get city from current GPS location
  Future<void> getCurrentLocation();
}
