import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../enums/enums.dart';
import '../../../../generated/assets.dart';
import '../../../../utils/utils.dart';
import '../../data/models/weather_model.dart';
import '../cubit/weather_cubit.dart';
import 'forecast_attributes_info.dart';

class ForecastAttributes extends StatelessWidget {
  const ForecastAttributes({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      buildWhen: (WeatherState previous, WeatherState current) => previous.current! != current.current!,
      builder: (BuildContext context, WeatherState state) {
        final CurrentWeather current = state.current!;
        return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
          Row(children: <Widget>[
            ForecastAttributesInfo(
              title: 'weather.wind.subtitle'.tr(),
              icon: Assets.svgWindy,
              value: getWindSpeed(current.windGust).toString(),
              unit: WindSpeedUnit.kmh.getText(context),
            )
          ]),
          ImageView.svgAsset(Assets.svgDivider),
          Row(children: <Widget>[
            ForecastAttributesInfo(
                title: 'weather.humidity.title'.tr(), icon: Assets.svgHumidity, value: getPrecipitationIntensity(current.humidity), unit: ''),
          ]),
          ImageView.svgAsset(Assets.svgDivider),
          Row(children: <Widget>[
            ForecastAttributesInfo(
              title: 'weather.visibility.title'.tr(),
              icon: Assets.svgVisibility,
              value: getDistance(current.visibility),
              unit: const Units().distance.getText,
            ),
          ])
        ]);
      },
    );
  }
}
