part of 'app_cubit.dart';

@immutable
abstract class AppStates {}

class AppInitial extends AppStates {}

class ChangePressureState extends AppStates {

  ChangePressureState(this.index);
  final int index;
}
