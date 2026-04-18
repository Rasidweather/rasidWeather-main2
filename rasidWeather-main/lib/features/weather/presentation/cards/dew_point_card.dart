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
import '../widgets/forecast_display.dart';

/// A card widget that displays the current dew point temperature.
///
/// Dew point is the temperature at which water vapor in the air begins to condense.
/// This widget displays this information in a visually appealing card format with
/// an icon and the temperature value.
class DewPointCard extends StatelessWidget {
  /// Creates a dew point card widget.
  ///
  /// Requires [current] parameter containing the current weather data
  /// with dew point information.
  const DewPointCard({super.key});

  /// The current weather data containing dew point information

  /// Constants for styling and layout
  static const double _kHorizontalPadding = 10.0;
  static const double _kTopPadding = 15.0;
  static const double _kBottomPadding = 20.0;
  static const double _kIconPadding = 3.0;
  static const double _kIconBorderRadius = 5.0;
  static const double _kSpacingHeight = 5.0;
  static const double _kHorizontalSpacing = 8.0;
  static const double _kTitleFontSize = 11.24;
  static const double _kValueFontSize = 20.0;
  static const double _kIconSize = 30.0;
  static const double _kIconOpacity = 0.4;
  static const double _kUnitSizeFactor = 2;

  @override
  Widget build(BuildContext context) {
    return UiWidget(
      child: (Appearance ui) {
        final Color textColor = convertHexaToColor(ui.textColor!);
        return WeatherContainer(
          padding: const EdgeInsets.fromLTRB(
            _kHorizontalPadding,
            _kTopPadding,
            _kHorizontalPadding,
            _kBottomPadding,
          ),
          header: _buildHeader(textColor),
          content: _buildContent(context, textColor),
        );
      },
    );
  }

  /// Builds the header section of the card.
  ///
  /// Displays the title "قطرات الندى" (Dew Drops) with appropriate styling.
  Widget _buildHeader(Color textColor) {
    return Text(
      'weather.dew_point'.tr(),
      style: TextStyle(
        color: textColor,
        fontSize: _kTitleFontSize.sp,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  /// Builds the main content section of the card.
  ///
  /// Contains the dew point icon and temperature value.
  Widget _buildContent(BuildContext context, Color textColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: _kSpacingHeight),
        Row(
          children: <Widget>[
            _buildDewPointIcon(context, textColor),
            _buildDewPointValue(context, textColor),
          ],
        ),
      ],
    );
  }

  /// Builds the dew point icon with a colored background.
  Widget _buildDewPointIcon(BuildContext context, Color textColor) {
    return Container(
      width: _kIconSize.sp,
      height: _kIconSize.sp,
      padding: const EdgeInsets.all(_kIconPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_kIconBorderRadius),
        color: Theme.of(context).primaryColor.withOpacity(_kIconOpacity),
      ),
      child: ImageView.svgAsset(
        Assets.svgRain,
        color: textColor,
      ),
    );
  }

  /// Builds the dew point temperature value display.
  Widget _buildDewPointValue(BuildContext context, Color textColor) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      buildWhen: (WeatherState previous, WeatherState current) => previous.current!.dewPoint != current.current!.dewPoint,
      builder: (BuildContext context, WeatherState state) {
        if (state.current != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: _kHorizontalSpacing),
            child: ForecastDisplay(
              value: state.current!.dewPoint.toString(),
              unit: getUnitSymbol(TemperatureUnit.celsius),
              style: Theme.of(context).textTheme.titleSmall!.copyWith(
                    fontSize: _kValueFontSize.sp,
                    color: textColor.darken(),
                    fontWeight: FontWeight.w500,
                  ),
              unitSizeFactor: _kUnitSizeFactor,
            ),
          );
        }
        return const SizedBox();
      },
    );
  }
}
