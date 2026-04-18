import 'dart:async';
import 'package:easy_localization/easy_localization.dart';

import '../../../../core/cubits/base_cubit.dart';
import '../../../../core/states/base_state.dart';
import '../../../../data/model/search_model.dart';
import '../../data/models/city_model.dart';
import '../../domain/repositories/i_cities_repository.dart';

part 'cities_state.dart';

class CitiesCubit extends BaseCubit<CitiesState> {
  CitiesCubit({required this.citiesRepo}) : super(const CitiesInitial());

  final ICitiesRepository citiesRepo;

  Timer? _searchDebounce;

  Future<void> addCity(CityModel geoname) async {
    await handleAsync(() async {
      await citiesRepo.addCity(geoname);
      emit(const CitiesSuccess());
    });
  }

  Future<void> deleteCity(String id) async {
    await handleAsync(() async {
      await citiesRepo.removeCity(id);
      emit(const CitiesSuccess());
    });
  }

  Future<void> selectCity(CityModel city) async {
    await handleAsync(() async {
      await citiesRepo.selectCity(city.locationId!);
      emit(SelectedCitySuccess(selectedCity: city));
    });
  }

  Future<void> getCitiesList() async {
    await handleAsync(() async {
      final List<CityModel> cities = await citiesRepo.getCities();
      if (cities.isNotEmpty) {
        emit(CitiesListSuccess(cities: cities));
      } else {
        emit(state.copyWith(error: 'cities.no_cities'.tr()));
      }
    }, refresh: true);
  }

  void onChangedText(String value) {
    // Debounce the search to avoid too many API calls
    if (_searchDebounce?.isActive ?? false) {
      _searchDebounce!.cancel();
    }

    _searchDebounce = Timer(const Duration(milliseconds: 500), () {
      if (value.isNotEmpty) {
        if (value.length >= 2) { // Only search if at least 2 characters
          searchCity(value);
        }
      } else {
        getCitiesList();
      }
    });
  }

  // get selected city
  Future<CityModel?> getSelectedCity() async {
    try {
      final CityModel? city = await citiesRepo.getSelectedCity();
      return city;
    } catch (e) {
      return null;
    }
  }

  Future<void> getSelectedCityState() async {
    await handleAsync(() async {
      final List<CityModel> cities = await citiesRepo.getCities();
      final CityModel selectedCity = cities.firstWhere(
        (CityModel city) => city.isSelected!,
        orElse: () => throw Exception('لم يتم العثور على مدينة'),
      );
      emit(SelectedCitySuccess(selectedCity: selectedCity));
    });
  }

  Future<void> searchCity(String text) async {
    if (text.length < 2) return; // Skip short search terms
    
    emit(state.copyWith(isLoading: true));
    
    await handleAsync(() async {
      try {
        // Get search results from repository
        final List<Geoname> geonameResults = await citiesRepo.searchCity(text);
        
        // Convert Geoname objects to CityModel objects
        final List<CityModel> cityModels = geonameResults.map((Geoname geoname) => CityModel(
          locationId: geoname.id,
          name: geoname.name,
          latitude: geoname.lat,
          longitude: geoname.lng,
          countryCode: geoname.countryCode,
          countryName: geoname.countryName,
          isSelected: false,
        )).toList();
        
        // Emit state with CityModel results
        emit(SearchCitiesSuccess(searchResults: cityModels));
      } catch (e) {
        emit(state.copyWith(error: 'Error searching cities: $e'));
      }
    });
  }

  Future<void> getGPSCity() async {
    await handleAsync(() async {
      await citiesRepo.getCurrentLocation();
      emit(const CitiesSuccess());
    });
  }
}
