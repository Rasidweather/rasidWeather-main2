import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../helper/router_helper.dart';
import '../../../../../../utils/ui_utils.dart';
import '../../../../../../views/base/ui_widget.dart';
import '../../../../../../views/base/weather_container.dart';
import '../../../../data/models/weather_model.dart';
import '../../../cubit/weather_cubit.dart';
import '../../../widgets/daily_forecast_item.dart';

/// A widget that displays a weekly weather forecast.
///
/// This widget shows a list of daily weather forecasts for up to 8 days,
/// with each day being clickable to show more detailed information.
/// It includes a divider between days for better visual separation.
class WeeklyForecastWidget extends StatefulWidget {
  /// Creates a weekly weather forecast widget.
  ///
  /// Requires [days] parameter containing the weather data for all days.
  const WeeklyForecastWidget({super.key});

  /// The weather model containing forecast data for multiple days

  @override
  State<WeeklyForecastWidget> createState() => _WeeklyForecastWidgetState();
}

/// The state class for [WeeklyForecastWidget].
///
/// Handles the building and interaction of the weekly weather forecast list.
class _WeeklyForecastWidgetState extends State<WeeklyForecastWidget> {
  /// Constants for styling and layout
  static const double _kHorizontalMargin = 20.0;
  static const double _kDividerHeight = 5.0;
  static const double _kDividerThickness = 0.3;
  static const double _kDividerOpacity = 0.2;

  // Static caches for expensive objects
  static final Map<String, Color> _dividerColorCache = <String, Color>{};
  static const EdgeInsets _containerMargin = EdgeInsets.symmetric(horizontal: _kHorizontalMargin);
  
  // Memoized divider widget
  static final Map<String, Widget> _dividerCache = <String, Widget>{};

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      buildWhen: (WeatherState previous, WeatherState current) => previous.days != current.days,
      builder: (BuildContext context, WeatherState state) {
        return UiWidget(
          child: (Appearance ui) {
            final Color textColor = convertHexaToColor(ui.textColor!);

            // Pre-compute daily items to avoid rebuilds
            final List<Widget> items = _buildDailyItems(state.days!, textColor);
            
            return RepaintBoundary(
              child: WeatherContainer(
                margin: _containerMargin,
                content: Column(children: items),
              ),
            );
          },
        );
      },
    );
  }

  /// Generates a list of daily weather items with dividers
  List<Widget> _buildDailyItems(List<Day> days, Color textColor) {
    final List<Widget> items = <Widget>[];
    final int lastIndex = days.length - 1;
    
    for (int index = 0; index < days.length; index++) {
      // Add day item with a unique key
      items.add(_buildDayItem(index, days[index], textColor));
      
      // Add divider if not the last item
      if (index != lastIndex) {
        items.add(_getDivider(textColor));
      }
    }
    
    return items;
  }

  /// Builds an interactive day item
  Widget _buildDayItem(int index, Day day, Color textColor) {
    final ValueKey<String> itemKey = ValueKey<String>('day_item_${day.forecastStart?.millisecondsSinceEpoch}');
    
    return RepaintBoundary(
      key: itemKey,
      child: GestureDetector(
        onTap: () => _onDayTap(index),
        child: ColoredBox(
          color: Colors.transparent,
          child: DailyForecastItem(
            key: itemKey,
            day: day,
            textColor: textColor,
          ),
        ),
      ),
    );
  }

  /// Gets a cached divider widget
  Widget _getDivider(Color textColor) {
    final String colorKey = textColor.value.toString();
    
    return _dividerCache.putIfAbsent(colorKey, () {
      final Color dividerColor = _dividerColorCache.putIfAbsent(
        colorKey,
        () => textColor.withOpacity(_kDividerOpacity)
      );
      
      return RepaintBoundary(
        child: Divider(
          height: _kDividerHeight,
          thickness: _kDividerThickness,
          color: dividerColor,
        ),
      );
    });
  }

  /// Handles tap events on day items
  void _onDayTap(int index) {
    RouterHelper.getDaysScreenRoute(index: index);
  }
}
