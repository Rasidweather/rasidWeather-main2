
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'app_state.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitial());


  Future<void> changePressure(int index) async {
    emit(ChangePressureState(index));
  }
}
