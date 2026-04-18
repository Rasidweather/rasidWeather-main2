import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../bloc/map_screen/map_screen_cubit.dart';
import '../../../features/cities/presentation/cubit/cities_cubit.dart';
import '../../base/native_ad_widget.dart';
import 'view_map_widget.dart' show ViewMapWidget;

class MapsScreen extends StatefulWidget {
  const MapsScreen({super.key});

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen>
    with AutomaticKeepAliveClientMixin {
  // Keep the WebView alive when switching tabs
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return BlocProvider<MapScreenCubit>(
      create: (BuildContext context) => MapScreenCubit(),
      child: BlocConsumer<CitiesCubit, CitiesState>(
        listener: (BuildContext context, CitiesState state) {
          if (state is SelectedCitySuccess) {
            context.read<MapScreenCubit>().processMapData(state.selectedCity!);
          }
        },
        builder: (BuildContext context, CitiesState state) {
          if (state is SelectedCitySuccess) {
            return SafeArea(
              bottom: false,
              child: Scaffold(
                body: Column(
                  children: <Widget>[
                    const NativeAdWidget(
                      size: AdSize.banner,
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.0,
                        vertical: 8.0,
                      ),
                    ),
                    Expanded(
                      child: ViewMapWidget(
                        map:
                            'https://www.meteoblue.com/ar/weather/maps#coords=4/${state.selectedCity!.latitude}/${state.selectedCity!.longitude}&map=windAnimation~rainbow~auto~10%20m%20above%20gnd~none',
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        },
      ),
    );
  }
}
