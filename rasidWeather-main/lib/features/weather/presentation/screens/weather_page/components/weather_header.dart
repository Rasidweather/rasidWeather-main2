import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../core/core.dart';
import '../../../../../../enums/enums.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../../views/base/index.dart';
import '../../../../../../views/base/weather_container.dart';
import '../../../../../language/cubit/language_cubit.dart';
import '../../../../data/models/weather_model.dart';
import '../../../cubit/weather_cubit.dart';
import '../../../widgets/forecast_attributes.dart';
import '../../../widgets/forecast_display.dart';
import '../../../widgets/forecast_icon.dart';

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      buildWhen: (WeatherState previous, WeatherState current) {
        return previous.current != current.current ||
            previous.days != current.days;
      },
      builder: (BuildContext context, WeatherState state) {
        if (state.current != null) {
          final Day currentDay = state.days!.first;

          return UiWidget(
            child: (Appearance ui) {
              final Color color = convertHexaToColor(ui.textColor!);
              final bool isArabic = context.read<LanguageCubit>().isArabic();

              return Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ForecastIcon(
                          icon: state.current!.condition!.conditionImage!,
                          animatedIcon:
                              state.current!.condition!.conditionIsAnimated!,
                          color: Colors.white,
                          // resizeAnimation: resizeAnimation,
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            ForecastDisplay(
                              value: getTemperature(
                                state.current!.temperature,
                              ).toString(),
                              unit: getUnitSymbol(TemperatureUnit.celsius),
                              style: _getTemperatureTextStyle(context, color),
                            ),
                            ForecastDisplay(
                              description: 'weather.current.feels_like'.tr(),
                              value: getTemperature(
                                state.current!.temperatureApparent ?? 0,
                              ).toString(),
                              unit: getUnitSymbol(TemperatureUnit.celsius),
                              style: _getFeelsLikeTextStyle(context, color),
                            ),
                          ],
                        ),
                      ],
                    ),

                    Container(
                      padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
                      child: Text(
                        isArabic
                            ? state.current!.condition!.localizedName(
                                isArabic: true,
                              )
                            : state.current!.condition!
                                  .localizedName(isArabic: false)
                                  .toUpperCase(),
                        style: Theme.of(context).textTheme.headlineMedium!
                            .copyWith(
                              fontWeight: FontWeight.w300,
                              color: color,
                            ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(bottom: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Column(
                              children: <Widget>[
                                ForecastDisplay(
                                  value: getTemperature(
                                    currentDay.temperatureMax,
                                  ).toString(),
                                  unit: getUnitSymbol(TemperatureUnit.celsius),
                                  style: getHiLowTempTextStyle(context, color),
                                  unitSizeFactor: 2.5,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(
                                    'weather.hi'.tr(),
                                    style: getHiLowTextStyle(context, color),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 20.0),
                          Column(
                            children: <Widget>[
                              ForecastDisplay(
                                value: getTemperature(
                                  currentDay.temperatureMin,
                                ).toString(),
                                unit: getUnitSymbol(TemperatureUnit.celsius),
                                style: getHiLowTempTextStyle(context, color),
                                unitSizeFactor: 2.5,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Text(
                                  'weather.low'.tr(),
                                  style: getHiLowTextStyle(context, color),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const WeatherContainer(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.zero,
                      content: ForecastAttributes(),
                    ),
                  ],
                ),
              );
            },
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  TextStyle _getTemperatureTextStyle(BuildContext context, Color color) {
    final TextStyle style = Theme.of(context).textTheme.displayLarge!;

    return style.copyWith(
      color: color,
      fontSize: Tween<double>(
        begin: style.fontSize! - 6,
        end: style.fontSize,
      ).evaluate(const AlwaysStoppedAnimation<double>(1.5)),
    );
  }

  TextStyle _getFeelsLikeTextStyle(BuildContext context, Color color) {
    final TextStyle style = Theme.of(context).textTheme.headlineSmall!;

    return style.copyWith(
      color: color,
      fontSize: Tween<double>(
        begin: style.fontSize! - 6,
        end: style.fontSize,
      ).evaluate(const AlwaysStoppedAnimation<double>(1.5)),
    );
  }

  TextStyle getHiLowTextStyle(BuildContext context, Color color) {
    return TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 15.sp,
      color: color,
    );
  }

  TextStyle getHiLowTempTextStyle(BuildContext context, Color color) {
    return TextStyle(
      height: 0.85,
      fontSize: 18.sp,
      fontWeight: FontWeight.w400,
      color: color,
    );
  }
}
