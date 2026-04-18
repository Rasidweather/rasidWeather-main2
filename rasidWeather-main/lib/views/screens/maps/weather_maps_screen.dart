import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/map_view/map_view_cubit.dart';
import '../../../common/widgets/app_ui_overlay_style.dart';
import '../../../core/widgets/back_button.dart';
import '../../../features/weather/presentation/screens/weather_page/components/weather_maps_widget.dart';
import '../../base/weather_container.dart';
import 'view_map_widget.dart';

class FullMapScreen extends StatelessWidget {
  const FullMapScreen({super.key, required this.map});

  final WeatherMapItem map;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => MapViewCubit(),
      child: Scaffold(
      extendBodyBehindAppBar: true,
      extendBody: true,
      // drawer: const Drawer(child: RainViewerLegend()),
      appBar: AppBar(
        forceMaterialTransparency: true,
        automaticallyImplyLeading: false,
        centerTitle: true,
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarBrightness: Brightness.dark,
          statusBarIconBrightness: Brightness.light,
        ),
        title: WeatherContainer(
          color: Colors.white70,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: AdaptiveBackButton(
                    size: 16.sp,
                    padding: EdgeInsets.zero,
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Text(
                map.title,
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff3d3d3d),
                  fontSize: 12.sp,
                ),
              ),
              Container(
                width: 20.w,
                height: 20.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  image: DecorationImage(
                    image: AssetImage(map.icon),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: AppUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        child: SafeArea(
          top: false,
          bottom: false,
          child: Stack(
            children: <Widget>[
              ViewMapWidget(
                map: map.url,
                isFullScreen: true,
                isRadar: map.mapType == MapType.rainViewer,
              ),
              // Align(
              //   alignment: Alignment.bottomCenter,
              //   child: Container(
              //     color: Colors.black,
              //     height: 23,
              //     width: MediaQuery.of(context).size.width,
              //   ),
              // ),
            ],
          ),
        ),
      ),
    ));
  }
}
