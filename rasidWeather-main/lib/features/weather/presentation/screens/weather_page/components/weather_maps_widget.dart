import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../helper/router_helper.dart';
import '../../../../../../utils/utils.dart';
import '../../../../../../views/base/weather_container.dart';
import '../../../../../cities/data/models/city_model.dart';
import '../../../../../cities/presentation/cubit/cities_cubit.dart';

/// A widget that displays various weather map options including radar and wind data
/// from different providers like Windy, RainViewer, and NCM.
class WeatherMapsWidget extends StatefulWidget {
  const WeatherMapsWidget({super.key});

  @override
  State<WeatherMapsWidget> createState() => _WeatherMapsWidgetState();
}

class _WeatherMapsWidgetState extends State<WeatherMapsWidget> {
  /// Constants for layout dimensions
  static const double _kHorizontalMargin = 20.0;
  static const double _kMapHeight = 180.0;
  static const double _kIconSize = 20.0;
  static const double _kBorderRadius = 10.0;

  late final PageController _pageController;
  int _currentIndex = 0;
  int _itemsCount = 0;
  static final Uri _moreMapsUrl = Uri.parse(
    'https://share.google/AxR8qvCYeXhpSabF4',
  );

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CitiesCubit, CitiesState>(
      buildWhen: (CitiesState previous, CitiesState current) {
        // Only rebuild if the selected city changes
        return previous.selectedCity?.locationId != current.selectedCity?.locationId;
      },
      builder: (BuildContext context, CitiesState state) {
        if (state.selectedCity == null) {
          return const SizedBox.shrink();
        }

        final CityModel city = state.selectedCity!;

        // نبني الليست حسب المدينة
        final List<WeatherMapItem> items = <WeatherMapItem>[
          _createSaudiRadar(city),
          // _createGulfRadar(city),
          _createWindyMap(city),
          _createRainViewerMap(city),
          _createNCMMap(),
        ];

        _itemsCount = items.length;

        if (items.isEmpty) {
          return const SizedBox.shrink();
        }

        return SizedBox(
          height: (_kMapHeight + 90).h, // ارتفاع الكروسل كامل
          child: Column(
            children: <Widget>[
              // الكروسل
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: items.length,
                  onPageChanged: (int index) {
                    setState(() => _currentIndex = index);
                  },
                  itemBuilder: (BuildContext context, int index) {
                    final WeatherMapItem item = items[index];
                    final bool isActive = index == _currentIndex;

                    return AnimatedPadding(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                      // بس عمودي عشان ما يغيّر العرض
                      padding: EdgeInsets.symmetric(
                        vertical: isActive ? 4.h : 1.h,
                      ),
                      child: AnimatedScale(
                        duration: const Duration(milliseconds: 400),
                        curve: Curves.easeOutCubic,
                        scale: isActive ? 1.0 : 0.97,
                        child: AnimatedOpacity(
                          duration: const Duration(milliseconds: 350),
                          opacity: isActive ? 1.0 : 0.85,
                          child: _buildMapItem(item),
                        ),
                      ),
                    );
                  },
                ),
              ),

              SizedBox(height: 10.h),

              Padding(
                padding: EdgeInsets.only(right: 16.w),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: _launchMoreMaps,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withOpacity(0.85),
                      padding: EdgeInsets.zero,
                      minimumSize: const Size(0, 0),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      alignment: Alignment.centerRight,
                    ),
                    child: Text(
                      'weather.maps.view_more'.tr(),
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.white.withOpacity(0.85),
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              // النقاط المؤشّرة أسفل الكروسل
              _buildDots(items.length),
            ],
          ),
        );
      },
    );
  }

  /// Indicator dots under the carousel
  Widget _buildDots(int length) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List<Widget>.generate(length, (int index) {
        final bool isActive = index == _currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 8.h,
          width: isActive ? 18.w : 8.w,
          decoration: BoxDecoration(
            color: isActive
                ? Colors.white
                : Colors.white.withOpacity(0.45),
            borderRadius: BorderRadius.circular(20),
          ),
        );
      }),
    );
  }

  Future<void> _launchMoreMaps() async {
    await launchUrl(
      _moreMapsUrl,
      mode: LaunchMode.externalApplication,
    );
  }

  // ==================== Map Item Creators ====================

  WeatherMapItem _createWindyMap(CityModel city) {
    return WeatherMapItem(
      title: 'weather.maps.windy.title'.tr(),
      label: 'weather.maps.windy.label'.tr(),
      icon: 'assets/windy.png',
      cover: 'assets/wind-background.jpeg',
      url: 'https://www.windy.com/?${city.latitude},${city.longitude},4',
      mapType: MapType.windy,
    );
  }

  /// Creates the Saudi Radar map configuration
  WeatherMapItem _createSaudiRadar(CityModel city) {
    return WeatherMapItem(
      title: 'weather.maps.saudi.title'.tr(),
      label: 'weather.maps.saudi.label'.tr(),
      icon: 'assets/subscribe-cover.png', // أيقونة/لوجو
      cover: 'assets/map_s.jpg', // صورة خلفية
      url: 'https://www.radar-flask.xyz/',
      mapType: MapType.meteoBlue,
    );
  }

  /// Creates the Gulf mixed radar
  WeatherMapItem _createGulfRadar(CityModel city) {
    return WeatherMapItem(
      title: 'weather.maps.gulf.title'.tr(),
      label: 'weather.maps.gulf.label'.tr(),
      icon: 'assets/subscribe-cover.png',
      cover: 'assets/map_r.png',
      url: 'https://radar-flask.xyz/mixed',
      mapType: MapType.meteoBlue,
    );
  }

  /// Creates the RainViewer map configuration
  WeatherMapItem _createRainViewerMap(CityModel city) {
    return WeatherMapItem(
      title: 'weather.maps.rainviewer.title'.tr(),
      label: 'weather.maps.rainviewer.label'.tr(),
      icon: 'assets/rainviewer.png',
      cover: 'assets/rainviewe-background.jpeg',
      url: MapsUtil.rainViewer(city),
      mapType: MapType.meteoBlue,
    );
  }

  /// Creates the NCM map configuration for UAE and Oman
  WeatherMapItem _createNCMMap() {
    return WeatherMapItem(
      title: 'weather.maps.ncm.title'.tr(),
      label: 'weather.maps.ncm.label'.tr(),
      icon: 'assets/ncm.png',
      cover: 'assets/ghit-background.jpeg',
      url: 'https://ghaith.ncm.ae/#radar-Merge-UAE',
      mapType: MapType.ncm,
    );
  }

  // ==================== UI Builders ====================

  /// Builds an individual weather map item with image and details
  Widget _buildMapItem(WeatherMapItem model) {
    return GestureDetector(
      onTap: () => RouterHelper.getFullMaps(model),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          _buildMapContainer(model),
          _buildMapDetailsOverlay(model),
        ],
      ),
    );
  }

  /// Builds the main container showing the map image
  Widget _buildMapContainer(WeatherMapItem model) {
    return WeatherContainer(
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.symmetric(horizontal: _kHorizontalMargin),
      content: Container(
        height: _kMapHeight.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(_kBorderRadius),
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(model.cover),
          ),
        ),
      ),
    );
  }

  /// Builds the overlay with map details and provider information
  Widget _buildMapDetailsOverlay(WeatherMapItem model) {
    return WeatherContainer(
      color: Colors.white70,
      radius: _kBorderRadius,
      padding: const EdgeInsets.symmetric(
        horizontal: _kHorizontalMargin,
        vertical: 10,
      ),
      margin: const EdgeInsets.symmetric(
        horizontal: 25.0,
        vertical: 10.0,
      ),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            model.label,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: const Color(0xff3d3d3d),
              fontSize: 12.sp,
            ),
          ),
          const Spacer(),
          Text(
            model.title,
            style: TextStyle(
              fontSize: 13.sp,
              fontFamily: 'DINNextLTArabic',
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(width: 4),
          _buildProviderIcon(model.icon),
        ],
      ),
    );
  }

  /// Builds the provider icon with consistent styling
  Widget _buildProviderIcon(String iconPath) {
    return Container(
      width: _kIconSize.w,
      height: _kIconSize.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(_kBorderRadius / 2),
        image: DecorationImage(
          image: AssetImage(iconPath),
        ),
      ),
    );
  }
}

/// Model class representing a weather map item with its associated data
class WeatherMapItem {
  const WeatherMapItem({
    required this.title,
    required this.label,
    required this.icon,
    required this.cover,
    required this.url,
    required this.mapType,
  });

  /// Creates a WeatherMapItem instance from a map structure
  ///
  /// This factory constructor is used for deserializing map data,
  /// particularly when receiving data from route parameters
  factory WeatherMapItem.fromMap(Map<String, dynamic> map) {
    return WeatherMapItem(
      title: map['title']?.toString() ?? '',
      label: map['label']?.toString() ?? '',
      icon: map['icon']?.toString() ?? '',
      cover: map['cover']?.toString() ?? map['map']?.toString() ?? '',
      url: map['url']?.toString() ?? '',
      mapType: _parseMapType(map['mapType']?.toString()),
    );
  }

  static MapType _parseMapType(String? value) {
    switch (value) {
      case 'windy':
        return MapType.windy;
      case 'rainViewer':
        return MapType.rainViewer;
      case 'ncm':
        return MapType.ncm;
      default:
        return MapType.meteoBlue;
    }
  }

  /// The title of the map display
  final String title;

  /// The provider label (e.g., 'windy', 'RainViewer')
  final String label;

  /// Path to the provider's icon asset
  final String icon;

  /// URL for the map cover image
  final String cover;

  /// URL to the full map view
  final String url;

  /// Type of map (windy, rainViewer, ncm, meteoBlue)
  final MapType mapType;

  /// Converts the model to a map representation
  ///
  /// This method is used for serializing the model data,
  /// particularly when passing data through route parameters
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'label': label,
      'icon': icon,
      'cover': cover,
      'url': url,
      'mapType': mapType.name,
    };
  }
}

/// Enum defining the different types of weather maps available
enum MapType {
  /// Windy.com weather radar and wind map
  windy,

  /// RainViewer precipitation radar
  rainViewer,

  /// National Center of Meteorology (UAE) radar
  ncm,

  /// MeteoBlue weather map
  meteoBlue,
}
