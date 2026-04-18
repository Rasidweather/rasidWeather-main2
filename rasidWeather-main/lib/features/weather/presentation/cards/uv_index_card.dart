import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../features/weather/data/models/weather_model.dart';
import '../../../../features/weather/presentation/cubit/weather_cubit.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/ui_utils.dart';
import '../../../../views/base/ui_widget.dart';
import '../../../../views/base/weather_container.dart';

/// A card widget that displays UV index information.
///
/// This widget shows:
/// - A radial gauge representing the current UV index level
/// - A description of the current UV risk level
/// - Recommendations based on the UV index
///
/// The widget uses color gradients and visual indicators to help users
/// understand the current UV risk level at a glance.
class UVIndexCard extends StatelessWidget {
  /// Creates a UV index card widget.
  ///
  /// Requires [current] parameter containing the current weather data
  /// with UV index information.
  const UVIndexCard({super.key});

  /// Constants for styling and layout
  static const double _kHorizontalPadding = 10.0;
  static const double _kTopPadding = 15.0;
  static const double _kBottomPadding = 20.0;
  static const double _kTitleFontSize = 14.22;
  static const double _kValueFontSize = 18.0;
  static const double _kDescriptionFontSize = 9.99;
  static const double _kGaugeHeight = 100.0;
  static const double _kGaugeThickness = 0.05;
  static const double _kPointerWidth = 0.2;
  static const double _kPointerSize = 25.0;
  static const double _kDotSize = 14.0;

  /// UV index gradient colors
  static const List<Color> _kGradientColors = <Color>[Colors.green, Colors.amber, Colors.red];

  @override
  Widget build(BuildContext context) {
    return UiWidget(
      child: (Appearance ui) {
        final Color textColor = convertHexaToColor(ui.textColor!);
        return WeatherContainer(
          padding: const EdgeInsets.fromLTRB(_kHorizontalPadding, _kTopPadding, _kHorizontalPadding, _kBottomPadding),
          header: _buildHeader(textColor),
          content: _buildContent(context, textColor),
        );
      },
    );
  }

  /// Builds the header section with the title.
  Widget _buildHeader(Color textColor) {
    return Center(
      child: Text('weather.uv_index.title'.tr(), style: TextStyle(color: textColor, fontSize: _kTitleFontSize.sp, fontWeight: FontWeight.w400)),
    );
  }

  /// Builds the main content section with the gauge and description.
  Widget _buildContent(BuildContext context, Color textColor) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      buildWhen: (WeatherState previous, WeatherState current) => previous.current!.uvIndex != current.current!.uvIndex,
      builder: (BuildContext context, WeatherState state) {
        if (state.current != null) {
          final double uvPercentage = _calculateUVPercentage(state.current!.uvIndex!.uvIndex!);

          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              _buildUVGauge(context, textColor, uvPercentage, state.current!.uvIndex!.uvIndex!),
              _buildDescription(context, state.current!, textColor),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  /// Builds the UV index gauge with current value.
  Widget _buildUVGauge(BuildContext context, Color textColor, double uvPercentage, int uvIndex) {
    return SizedBox(
      height: _kGaugeHeight.h,
      child: SfRadialGauge(
        axes: <RadialAxis>[
          RadialAxis(
            radiusFactor: 1,
            axisLineStyle: AxisLineStyle(
              cornerStyle: CornerStyle.bothCurve,
              color: textColor,
              thickness: _kGaugeThickness,
              thicknessUnit: GaugeSizeUnit.factor,
              gradient: const SweepGradient(colors: _kGradientColors),
            ),
            showLabels: false,
            showTicks: false,
            startAngle: 180,
            endAngle: 0,
            annotations: <GaugeAnnotation>[_buildValueAnnotation(context, textColor, uvIndex)],
            pointers: <GaugePointer>[_buildRangePointer(uvPercentage), _buildDotPointer(uvPercentage)],
          ),
        ],
      ),
    );
  }

  /// Builds the UV index value annotation.
  GaugeAnnotation _buildValueAnnotation(BuildContext context, Color textColor, int uvIndex) {
    return GaugeAnnotation(
      angle: 0,
      widget: Text(
        uvIndex.toString(),
        style: Theme.of(context).textTheme.titleMedium!.copyWith(color: textColor, fontSize: _kValueFontSize.sp, fontWeight: FontWeight.w500),
      ),
    );
  }

  /// Builds the range pointer showing progress.
  RangePointer _buildRangePointer(double value) {
    return RangePointer(
      width: _kPointerWidth,
      value: value,
      gradient: const SweepGradient(colors: <Color>[Colors.transparent, Colors.transparent]),
      sizeUnit: GaugeSizeUnit.factor,
    );
  }

  /// Builds the dot pointer showing current position.
  WidgetPointer _buildDotPointer(double value) {
    return WidgetPointer(
      enableDragging: true,
      value: value,
      child: SizedBox(
        height: _kPointerSize,
        width: _kPointerSize,
        child: Center(
          child: value == 100 ? ImageView.svgAsset(Assets.svgDot, width: _kDotSize) : ImageView.svgAsset(Assets.svgDot, width: _kDotSize),
        ),
      ),
    );
  }

  /// Builds the description section with UV risk information.
  Widget _buildDescription(BuildContext context, CurrentWeather current, Color textColor) {
    return Positioned(
      bottom: 0,
      child: Container(
        width: MediaQuery.sizeOf(context).width / 3,
        alignment: Alignment.center,
        child: Text(
          _getUVTitle(current),
          textAlign: TextAlign.right,
          maxLines: 5,
          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: textColor, fontSize: _kDescriptionFontSize.sp, fontWeight: FontWeight.w400),
        ),
      ),
    );
  }

  /// Returns the appropriate title based on UV index and time of day.
  String _getUVTitle(CurrentWeather currentWeather) {
    final int uvi = currentWeather.uvIndex!.uvIndex!;
    final bool isDay = currentWeather.daylight!;

    if (!isDay) {
      return 'weather.uv_index.no_sun'.tr();
    }

    if (uvi <= 3) {
      return 'weather.uv_index.risk_levels.none'.tr();
    }
    if (uvi <= 6) {
      return 'weather.uv_index.risk_levels.low'.tr();
    }
    if (uvi <= 8) {
      return 'weather.uv_index.risk_levels.medium'.tr();
    }
    if (uvi <= 11) {
      return 'weather.uv_index.risk_levels.high'.tr();
    }
    return 'weather.uv_index.risk_levels.very_high'.tr();
  }

  /// Calculates the percentage for UV index display.
  double _calculateUVPercentage(int uvi) {
    if (uvi <= 1) {
      return 0;
    }
    if (uvi <= 2) {
      return 10;
    }
    if (uvi <= 3) {
      return 20;
    }
    if (uvi <= 4) {
      return 30;
    }
    if (uvi <= 5) {
      return 40;
    }
    if (uvi <= 6) {
      return 50;
    }
    if (uvi <= 7) {
      return 60;
    }
    if (uvi <= 8) {
      return 70;
    }
    if (uvi <= 9) {
      return 80;
    }
    if (uvi <= 10) {
      return 90;
    }
    if (uvi <= 11) {
      return 100;
    }
    return 0;
  }
}
