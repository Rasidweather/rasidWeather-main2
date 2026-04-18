import 'package:flutter/material.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../generated/assets.dart';

// TODO(mohamedSleem): not used yet.
class ForecastWindDirection extends StatelessWidget {
  const ForecastWindDirection({
    super.key,
    this.icon = Icons.navigation,
    this.size = 20.0,
    this.color,
    this.shadowColor = Colors.black38,
    this.degree,
  });
  final IconData icon;
  final double size;
  final Color? color;
  final Color shadowColor;
  final num? degree;

  @override
  Widget build(
    BuildContext context,
  ) {
    // AppState state = context.watch<AppBloc>().state;
    // if ((state.themeMode == ThemeMode.light) && !state.colorTheme) {
    //   return _rotate(
    //     degree ?? 0.0,
    //     Icon(
    //       Icons.navigation,
    //       color: color,
    //       size: size,
    //     ),
    //   );
    // }

    return Align(
      child: Stack(children: <Widget>[
        Positioned(
          top: 1.0,
          left: 1.0,
          child: _rotate(
            degree ?? 0.0,
            ImageView.svgAsset(
              Assets.svgWindDirection,
              // color: color,
              width: size,
            ),
          ),
        ),
        _rotate(
          degree ?? 0.0,
          ImageView.svgAsset(
            Assets.svgWindDirection,
            // color: color,
            width: size,
          ),
        ),
      ]),
    );
  }

  Widget _rotate(num degree, Widget child) => RotationTransition(
        turns: AlwaysStoppedAnimation(degree / 360.0),
        child: child,
      );
}
