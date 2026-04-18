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
import '../../../../utils/utils.dart';
import '../../../../views/base/ui_widget.dart';
import '../../../../views/base/weather_container.dart';

/// A card widget that displays the sun's phase throughout the day.
///
/// This widget shows:
/// - A radial gauge representing the sun's position
/// - Sunrise and sunset times
/// - Total daylight duration
///
/// The widget uses a combination of text and visual elements to provide
/// an intuitive understanding of the sun's position and timing.
class SunPhaseCard extends StatelessWidget {
  /// Creates a sun phase card widget.
  ///
  /// Requires [current] parameter containing the current weather data
  /// with sun phase information.
  const SunPhaseCard({super.key});

  /// The current weather data containing sun phase information

  /// Constants for styling and layout
  static const double _kHorizontalPadding = 10.0;
  static const double _kTopPadding = 15.0;
  static const double _kBottomPadding = 20.0;
  static const double _kVerticalSpacing = 10.0;
  static const double _kTitleFontSize = 14.22;
  static const double _kSubtitleFontSize = 9.99;
  static const double _kTimeFontSize = 7.89;
  static const double _kGaugeHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    return UiWidget(
      child: (Appearance ui) {
        final Color textColor = convertHexaToColor(ui.textColor!);
        return WeatherContainer(
          padding: const EdgeInsets.fromLTRB(_kHorizontalPadding, _kTopPadding, _kHorizontalPadding, _kBottomPadding),
          header: _buildHeader(textColor),
          content: _buildContent(textColor),
        );
      },
    );
  }

  /// Builds the header section with the title "الشمس" (Sun).
  Widget _buildHeader(Color textColor) {
    return Text('weather.sun'.tr(),
        style: TextStyle(color: textColor, fontSize: _kTitleFontSize.sp, fontWeight: FontWeight.w400));
  }

  /// Builds the main content section including the gauge and timing information.
  Widget _buildContent(Color textColor) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      buildWhen: (WeatherState previous, WeatherState current) =>
          previous.current!.sunrise != current.current!.sunrise || previous.current!.sunset != current.current!.sunset,
      builder: (BuildContext context, WeatherState state) {
        if (state.current == null) {
          return const SizedBox();
        }
        return Column(
          children: <Widget>[
            _buildSunGauge(state.current!, textColor),
            _buildDurationTitle(textColor),
            const SizedBox(height: _kVerticalSpacing),
            _buildDurationValue(state.current!, textColor),
          ],
        );
      },
    );
  }

  /// Builds the radial gauge showing sun's position.
  Widget _buildSunGauge(CurrentWeather current, Color textColor) {
    return SizedBox(height: _kGaugeHeight.h, child: _SunPhaseGauge(current: current, textColor: textColor));
  }

  /// Builds the duration title text.
  Widget _buildDurationTitle(Color textColor) {
    return Text('weather.appearance_duration'.tr(),
        style: TextStyle(color: textColor, fontSize: _kSubtitleFontSize.sp, fontWeight: FontWeight.w500));
  }

  /// Builds the duration value display.
  Widget _buildDurationValue(CurrentWeather current, Color textColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: <Widget>[
        Text(
          getDifferenceTime(startTime: current.sunrise, endTime: current.sunset),
          style: TextStyle(color: textColor, fontSize: _kTimeFontSize.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}

/// A custom gauge widget that displays the sun's position throughout the day.
class _SunPhaseGauge extends StatelessWidget {
  const _SunPhaseGauge({required this.current, required this.textColor});

  final CurrentWeather current;
  final Color textColor;

  /// Constants for styling and layout
  static const double _kRadiusFactor = 0.9;
  static const double _kLineThickness = 0.04;
  static const double _kPointerSize = 25.0;
  static const double _kDotSize = 16.0;
  static const double _kAnnotationSpacing = 25.0;
  static const double _kShadowBlurRadius = 4.0;
  static const double _kBorderWidth = 0.0;

  @override
  Widget build(BuildContext context) {
    final double value =
        getSunPhasePercentage(sunset: current.sunset!, sunrise: current.sunrise!, now: current.meta!.asOf);

    return SfRadialGauge(
      axes: <RadialAxis>[
        RadialAxis(
          radiusFactor: _kRadiusFactor.sp,
          axisLineStyle: AxisLineStyle(
            cornerStyle: CornerStyle.bothCurve,
            color: Colors.white.withAlpha((0.3 * 255).round()),
            thickness: _kLineThickness,
            thicknessUnit: GaugeSizeUnit.factor,
          ),
          showLabels: false,
          showTicks: false,
          startAngle: 180,
          endAngle: 0,
          pointers: <GaugePointer>[_buildRangePointer(value), _buildSunPointer(value)],
          annotations: _buildTimeAnnotations(),
        ),
      ],
    );
  }

  /// Builds the range pointer showing progress.
  RangePointer _buildRangePointer(double value) {
    return RangePointer(
      width: _kLineThickness,
      value: value,
      cornerStyle: CornerStyle.bothCurve,
          color: textColor.withAlpha((0.8 * 255).round()),
          sizeUnit: GaugeSizeUnit.factor,
    );
  }

  /// Builds the sun pointer showing current position.
  WidgetPointer _buildSunPointer(double value) {
    return WidgetPointer(
      enableDragging: true,
      value: value,
      child: Container(
        decoration: BoxDecoration(
          color: _getSunPointerColor(value),
          shape: BoxShape.circle,
          boxShadow: <BoxShadow>[BoxShadow(color: Colors.white.withAlpha((0.2 * 255).round()), blurRadius: _kShadowBlurRadius)],
          border: Border.all(color: Colors.black.withAlpha((0.1 * 255).round()), width: _kBorderWidth),
        ),
        height: _kPointerSize,
        width: _kPointerSize,
        child: Center(
          child: value >= 100
              ? ImageView.svgAsset(Assets.svgDot, color: Colors.grey[800], width: _kDotSize)
              : ImageView.svgAsset(Assets.svgDot, width: _kDotSize),
        ),
      ),
    );
  }

  /// Returns the appropriate color for the sun pointer based on its position.
  Color _getSunPointerColor(double value) {
    if (value <= 20) {
      return Colors.transparent;
    }
    if (value > 80 && value < 100) {
      return Colors.transparent;
    }
    if (value == 100) {
      return Colors.black38.withAlpha((0.01 * 255).round());
    }
    return Colors.transparent;
  }

  /// Builds the time annotations for sunrise and sunset.
  List<GaugeAnnotation> _buildTimeAnnotations() {
    return <GaugeAnnotation>[_buildTimeAnnotation(0, current.sunset), _buildTimeAnnotation(180, current.sunrise)];
  }

  /// Builds a single time annotation.
  GaugeAnnotation _buildTimeAnnotation(double angle, DateTime? time) {
    return GaugeAnnotation(
      angle: angle,
      positionFactor: 1,
      widget: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          const SizedBox(height: _kAnnotationSpacing),
          Text(formatDateTime(time!, format: 'HH:mm')!,
              style: TextStyle(color: textColor, fontSize: 7.89.sp, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
