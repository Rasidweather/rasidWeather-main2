import 'package:flutter_bloc/flutter_bloc.dart';

import '../states/base_state.dart';

abstract class BaseCubit<T extends BaseState> extends Cubit<T> {
  BaseCubit(super.initialState);

  Future<void> handleAsync(Future<void> Function() operation, {bool? refresh = false}) async {
    try {
      emit(state.copyWith(isLoading: refresh ?? true, refresh: refresh) as T);
      await operation();
    } catch (e) {
      emit(state.copyWith(isLoading: false, error: e.toString()) as T);
    } finally {
      emit(state.copyWith(isLoading: false) as T);
    }
  }
}
