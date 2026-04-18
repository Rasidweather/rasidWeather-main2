part of 'weather_cubit.dart';

@immutable
class WeatherState extends BaseState {

   const WeatherState({
    this.current,
    this.days,
    this.hours,
    // this.charts,
     this.thunderstormSummary,
    super.isLoading = false,
    super.error,
    this.totalRows,
    this.activeFilters,
  });
  final CurrentWeather? current;
  final List<Day>? days;
  final List<Hour>? hours;
  final List<ThunderstormSummary>? thunderstormSummary;
  // final ChartModel? charts;
  final int? totalRows;
  final ProjectFilters? activeFilters;

  @override
  List<Object?> get props => <Object?>[
        // charts,
        isLoading,
        error,
        totalRows,
        activeFilters,
        current,
        days,
        hours,
        thunderstormSummary,
      ];

  @override
  WeatherState copyWith({
    CurrentWeather? current,
    List<Day>? days,
    List<Hour>? hours,
    // final ChartModel? charts,
    bool? isLoading,
    bool? refresh,
    String? error,
    ProjectFilters? activeFilters,
    List<ThunderstormSummary>? thunderstormSummary,
  }) {
    return WeatherState(
      current: current ?? this.current,
      days: days ?? this.days,
      hours: hours ?? this.hours,
      // charts: charts ?? this.charts,
      thunderstormSummary: thunderstormSummary ?? this.thunderstormSummary,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      activeFilters: activeFilters ?? this.activeFilters,
    );
  }
}

class ProjectFilters {

  const ProjectFilters({
    this.name,
    this.before,
    this.after,
  });
  final String? name;
  final String? before;
  final String? after;

  bool get hasFilters => name != null || before != null || after != null;
}