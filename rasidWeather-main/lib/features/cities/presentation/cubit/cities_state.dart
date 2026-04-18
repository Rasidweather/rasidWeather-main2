
part of 'cities_cubit.dart';


abstract class CitiesState extends BaseState {
  const CitiesState({
    super.isLoading,
    super.refresh,
    super.error,
    this.cities,
    this.searchResults,
    this.selectedCity,
  });
  
  final List<CityModel>? cities;
  final List<CityModel>? searchResults;
  final CityModel? selectedCity;
  
  @override
  List<Object?> get props => <Object?>[isLoading, refresh, error, cities, searchResults, selectedCity];
  
  @override
  CitiesState copyWith({
    bool? isLoading,
    bool? refresh,
    String? error,
    List<CityModel>? cities,
    List<CityModel>? searchResults,
    CityModel? selectedCity,
  });
}

class CitiesInitial extends CitiesState {
  const CitiesInitial() : super();
  
  @override
  CitiesState copyWith({
    bool? isLoading,
    bool? refresh,
    String? error,
    List<CityModel>? cities,
    List<CityModel>? searchResults,
    CityModel? selectedCity,
  }) {
    return const CitiesInitial();
  }
}

// CitiesLoading is no longer needed as loading state is handled by BaseState

class CitiesSuccess extends CitiesState {
  const CitiesSuccess({
    super.isLoading = false,
    super.refresh = false,
  });
  
  @override
  CitiesState copyWith({
    bool? isLoading,
    bool? refresh,
    String? error,
    List<CityModel>? cities,
    List<CityModel>? searchResults,
    CityModel? selectedCity,
  }) {
    return CitiesSuccess(
      isLoading: isLoading ?? this.isLoading,
      refresh: refresh ?? this.refresh,
    );
  }
}

// CitiesError is no longer needed as error state is handled by BaseState

class CitiesListSuccess extends CitiesState {
  const CitiesListSuccess({
    required List<CityModel> cities,
    super.isLoading = false,
    super.refresh = false,
  }) : super(cities: cities);
  
  @override
  CitiesState copyWith({
    bool? isLoading,
    bool? refresh,
    String? error,
    List<CityModel>? cities,
    List<CityModel>? searchResults,
    CityModel? selectedCity,
  }) {
    return CitiesListSuccess(
      cities: cities ?? this.cities!,
      isLoading: isLoading ?? this.isLoading,
      refresh: refresh ?? this.refresh,
    );
  }
}

class SearchCitiesSuccess extends CitiesState {
  const SearchCitiesSuccess({
    required List<CityModel> searchResults,
    super.isLoading = false,
    super.refresh = false,
  }) : super(searchResults: searchResults);
  
  @override
  CitiesState copyWith({
    bool? isLoading,
    bool? refresh,
    String? error,
    List<CityModel>? cities,
    List<CityModel>? searchResults,
    CityModel? selectedCity,
  }) {
    return SearchCitiesSuccess(
      searchResults: searchResults ?? this.searchResults!,
      isLoading: isLoading ?? this.isLoading,
      refresh: refresh ?? this.refresh,
    );
  }
}

class CitiesEmpty extends CitiesState {
  const CitiesEmpty({
    super.isLoading = false,
    super.refresh = false,
  });
  
  @override
  CitiesState copyWith({
    bool? isLoading,
    bool? refresh,
    String? error,
    List<CityModel>? cities,
    List<CityModel>? searchResults,
    CityModel? selectedCity,
  }) {
    return CitiesEmpty(
      isLoading: isLoading ?? this.isLoading,
      refresh: refresh ?? this.refresh,
    );
  }
}

class SelectedCitySuccess extends CitiesState {
  const SelectedCitySuccess({
    required CityModel selectedCity,
    super.isLoading = false,
    super.refresh = false,
  }) : super(selectedCity: selectedCity);
  
  @override
  CitiesState copyWith({
    bool? isLoading,
    bool? refresh,
    String? error,
    List<CityModel>? cities,
    List<CityModel>? searchResults,
    CityModel? selectedCity,
  }) {
    return SelectedCitySuccess(
      selectedCity: selectedCity ?? this.selectedCity!,
      isLoading: isLoading ?? this.isLoading,
      refresh: refresh ?? this.refresh,
    );
  }
}
