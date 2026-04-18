import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../enums/enums.dart';
import '../../../../features/weather/data/models/weather_model.dart';
import '../../../../features/weather/presentation/cubit/weather_cubit.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/ui_utils.dart';
import '../../../../utils/utils.dart';
import '../../../../views/base/ui_widget.dart';
import '../../../../views/base/weather_container.dart';

/// A card widget that displays visibility information.
///
/// This widget shows:
/// - Current visibility distance in kilometers
/// - An icon representing visibility conditions
/// - A description of the current visibility conditions
///
/// The widget provides an intuitive way to understand current visibility
/// conditions using both numerical values and descriptive text.
class VisibilityCard extends StatelessWidget {
  /// Creates a visibility card widget.
  ///
  /// Requires [current] parameter containing the current weather data
  /// with visibility information.
  const VisibilityCard({super.key});

  /// Constants for styling and layout
  static const double _kHorizontalPadding = 10.0;
  static const double _kTopPadding = 15.0;
  static const double _kBottomPadding = 20.0;
  static const double _kVerticalSpacing = 5.0;
  static const double _kTitleFontSize = 14.22;
  static const double _kValueFontSize = 18.0;
  static const double _kUnitFontSize = 10.0;
  static const double _kDescriptionFontSize = 10.0;
  static const double _kIconSize = 30.0;
  static const double _kIconPadding = 3.0;
  static const double _kIconBorderRadius = 5.0;
  static const double _kDescriptionWidth = 146.0;
  static const double _kHorizontalIconSpacing = 8.0;

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

  /// Builds the header section with the title "الرؤية" (Visibility).
  Widget _buildHeader(Color textColor) {
    return Text('weather.visibility'.tr(), style: TextStyle(color: textColor, fontSize: _kTitleFontSize.sp, fontWeight: FontWeight.w400));
  }

  /// Builds the main content section with visibility information.
  Widget _buildContent(BuildContext context, Color textColor) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      buildWhen: (WeatherState previous, WeatherState current) => previous.current!.visibility != current.current!.visibility,
      builder: (BuildContext context, WeatherState state) {
        if (state.current != null) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: _kVerticalSpacing),
              _buildVisibilityInfo(context, state.current!, textColor),
              const SizedBox(height: _kVerticalSpacing),
              _buildDescription(state.current!, textColor),
            ],
          );
        }
        return const SizedBox();
      },
    );
  }

  /// Builds the row containing the visibility icon and value.
  Widget _buildVisibilityInfo(BuildContext context, CurrentWeather current, Color textColor) {
    return Row(
      children: <Widget>[
        _buildVisibilityIcon(context, textColor),
        _buildUnitLabel(context, textColor),
        _buildVisibilityValue(context, current, textColor),
      ],
    );
  }

  /// Builds the visibility icon with background.
  Widget _buildVisibilityIcon(BuildContext context, Color textColor) {
    return Container(
      width: _kIconSize.sp,
      height: _kIconSize.sp,
      padding: const EdgeInsets.all(_kIconPadding),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(_kIconBorderRadius), color: Theme.of(context).primaryColor.withAlpha((0.4 * 255).round())),
      child: ImageView.svgAsset(Assets.svgVisibility, color: textColor),
    );
  }

  /// Builds the unit label (km).
  Widget _buildUnitLabel(BuildContext context, Color textColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: _kHorizontalIconSpacing),
      child: Text(
        DistanceUnit.km.getText,
        style: Theme.of(context).textTheme.titleSmall!.copyWith(fontSize: _kUnitFontSize.sp, color: textColor.darken(), fontWeight: FontWeight.w500),
      ),
    );
  }

  /// Builds the visibility value display.
  Widget _buildVisibilityValue(BuildContext context, CurrentWeather current, Color textColor) {
    return Text(
      getDistance(current.visibility),
      style: Theme.of(context).textTheme.headlineMedium!.copyWith(color: textColor, fontSize: _kValueFontSize.sp, fontWeight: FontWeight.w500),
    );
  }

  /// Builds the visibility description text.
  Widget _buildDescription(CurrentWeather current, Color textColor) {
    return SizedBox(
      width: _kDescriptionWidth,
      child: Text(
        current.visibilityText.toString(),
        textAlign: TextAlign.right,
        style: TextStyle(color: textColor, fontSize: _kDescriptionFontSize.sp, fontWeight: FontWeight.w400),
      ),
    );
  }
}
