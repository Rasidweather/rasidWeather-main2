import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/ui_cubit/ui_cubit.dart';
import '../../features/weather/data/models/weather_model.dart';

/// A widget that provides UI appearance data to its child based on the current theme.
///
/// This widget is optimized for performance and only rebuilds when the appearance
/// actually changes, not on every state change.
class UiWidget extends StatelessWidget {
  const UiWidget({super.key, required this.child});

  final Widget Function(Appearance) child;

  // Static constant for default appearance to avoid recreating it on each build
  static const Appearance _defaultAppearance = Appearance(
    background: <String>['#ffffff', '#ffffff'],
    stops: <double>[0.0, 1.0],
    cardBackground: '#ffffff',
    textColor: '#000000',
    buttonColor: '#000000',
  );

  /// Determines if the widget should rebuild based on state changes.
  /// Only rebuilds when the appearance properties actually change.
  bool _shouldRebuild(UiState previous, UiState current) {
    if (identical(previous, current)) {
      return false;
    }

    final Appearance? prevAppearance = previous is UiThemeChanged ? previous.colorModel : null;
    final Appearance? currAppearance = current is UiThemeChanged ? current.colorModel : null;

    if (identical(prevAppearance, currAppearance)) {
      return false;
    }
    if (prevAppearance == null || currAppearance == null) {
      return true;
    }

    return prevAppearance.textColor != currAppearance.textColor ||
        prevAppearance.buttonColor != currAppearance.buttonColor ||
        prevAppearance.cardBackground != currAppearance.cardBackground ||
        !listEquals(prevAppearance.background, currAppearance.background) ||
        !listEquals(prevAppearance.stops, currAppearance.stops);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UiCubit, UiState>(
      buildWhen: _shouldRebuild,
      builder: (BuildContext context, UiState state) {
        final Appearance appearance = state is UiThemeChanged
            ? state.colorModel
            : _defaultAppearance;

        return RepaintBoundary(
          child: child(appearance),
        );
      },
    );
  }
}