import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'dew_point_card.dart';
import 'humidity_card.dart';
import 'sun_phase_card.dart';
import 'uv_index_card.dart';
import 'visibility_card.dart';
import 'wind_card.dart';

/// A widget that displays detailed weather information in a responsive grid layout,
/// including sun phase, UV index, wind conditions, visibility, dew point and humidity.
class WeatherDetailsGrid extends StatelessWidget {
  const WeatherDetailsGrid({super.key});

  static const double _kHorizontalPadding = 20.0;
  static const double _kBottomPadding = 50.0;
  static const int _kGridColumns = 2;
  static const double _kGridSpacing = 10.0;

  @override
  Widget build(BuildContext context) {
    return AlignedGridView.count(
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(_kHorizontalPadding, 0, _kHorizontalPadding, _kBottomPadding),
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: _kGridColumns,
      mainAxisSpacing: _kGridSpacing.sp,
      crossAxisSpacing: _kGridSpacing.sp,
      itemCount: _buildWeatherComponents().length,
      itemBuilder: (BuildContext context, int index) => _buildWeatherComponents()[index],
    );
  }

  List<Widget> _buildWeatherComponents() {
    return <Widget>[
      const SunPhaseCard(),
      const UVIndexCard(),
      const WindCard(),
      const VisibilityCard(),
      const DewPointCard(),
      const HumidityCard(),
    ];
  }
}
