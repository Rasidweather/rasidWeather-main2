import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../features/weather/data/models/weather_model.dart';
import '../../../../features/weather/presentation/cubit/weather_cubit.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/ui_utils.dart';
import '../../../../utils/utils.dart';
import '../../../../views/base/ui_widget.dart';
import '../../../../views/base/weather_container.dart';

/// A card widget that displays the current humidity level.
///
/// This widget shows the humidity percentage in a visually appealing card format
/// with an icon and the value. The humidity is displayed as a percentage and
/// uses a consistent styling that matches the app's theme.
class HumidityCard extends StatelessWidget {
  /// Creates a humidity card widget.
  ///
  /// Requires [current] parameter containing the current weather data
  /// with humidity information.
  const HumidityCard({super.key});

  /// Constants for styling and layout
  static const double _kHorizontalPadding = 10.0;
  static const double _kTopPadding = 15.0;
  static const double _kBottomPadding = 20.0;
  static const double _kSpacingHeight = 5.0;
  static const double _kIconPadding = 3.0;
  static const double _kIconBorderRadius = 5.0;
  static const double _kHorizontalSpacing = 8.0;
  static const double _kTitleFontSize = 11.24;
  static const double _kValueFontSize = 20.0;
  static const double _kIconSize = 30.0;
  static const double _kIconOpacity = 0.4;

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

  /// Builds the header section with the title "رطوبة" (Humidity).
  Widget _buildHeader(Color textColor) {
    return Text('weather.humidity.title'.tr(), style: TextStyle(color: textColor, fontSize: _kTitleFontSize.sp, fontWeight: FontWeight.w500));
  }

  /// Builds the main content section of the card.
  ///
  /// Contains the humidity icon and percentage value.
  Widget _buildContent(BuildContext context, Color textColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SizedBox(height: _kSpacingHeight),
        Row(children: <Widget>[_buildHumidityIcon(context, textColor), _buildHumidityValue(context, textColor)]),
      ],
    );
  }

  /// Builds the humidity icon with a colored background.
  Widget _buildHumidityIcon(BuildContext context, Color textColor) {
    return Container(
      width: _kIconSize.sp,
      height: _kIconSize.sp,
      padding: const EdgeInsets.all(_kIconPadding),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_kIconBorderRadius),
        color: Theme.of(context).primaryColor.withAlpha((_kIconOpacity * 255).round()),
      ),
      child: ImageView.svgAsset(Assets.svgHumidity, color: textColor),
    );
  }

  /// Builds the humidity percentage value display.
  Widget _buildHumidityValue(BuildContext context, Color textColor) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      buildWhen: (WeatherState previous, WeatherState current) => previous.current!.humidity != current.current!.humidity,
      builder: (BuildContext context, WeatherState state) {
        if (state.current != null) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: _kHorizontalSpacing),
            child: Text(
              state.current!.humidity.toString().convertToPercentage(),
              style: Theme.of(
                context,
              ).textTheme.titleSmall!.copyWith(fontSize: _kValueFontSize.sp, color: textColor.darken(), fontWeight: FontWeight.w500),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}
