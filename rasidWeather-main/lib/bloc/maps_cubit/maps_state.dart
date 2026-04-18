part of 'maps_cubit.dart';

@immutable
abstract class MapsState {}

class MapsInitial extends MapsState {}

class MapsLoading extends MapsState {}

class MapsSuccess extends MapsState {}

class MapsError extends MapsState {

  MapsError(this.message);
  final String message;
}
