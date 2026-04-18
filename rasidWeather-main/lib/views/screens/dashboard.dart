import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../common/widgets/app_ui_overlay_style.dart';
import '../../features/ads/presentation/services/ads_service.dart';
import '../../features/cities/presentation/cubit/cities_cubit.dart';
import '../../features/language/cubit/language_cubit.dart';
import '../../features/weather/data/models/weather_model.dart';
import '../../features/weather/presentation/cubit/weather_cubit.dart';
import '../../features/weather/presentation/screens/charts_page/charts_screen_body.dart';
import '../../features/weather/presentation/screens/weather_page/weather_page.dart';
import '../../helper/my_notification.dart';
import '../../helper/router_helper.dart';
import '../../locator.dart';
import '../../main.dart';
import '../../utils/ui_utils.dart';
import '../base/native_ad_widget.dart';
import '../base/ui_widget.dart';
import 'articles_screen/articles_tab/body.dart';
import 'maps/map_screen.dart';
import 'profile_screen/profile.dart';

/// Main dashboard widget that handles navigation between different app sections.
/// Optimized for performance with proper memory management and reduced rebuilds.
class Dashboard extends StatefulWidget {
  /// Creates a Dashboard with the specified initial page index.
  const Dashboard({super.key, required this.pageIndex});

  /// The initial page index to display.
  final int pageIndex;

  @override
  State<Dashboard> createState() => DashboardState();
}

class DashboardState extends State<Dashboard> with WidgetsBindingObserver {
  // Navigation state
  late int _currentIndex;
  DateTime? _lastBackPressTime;

  // UI constants
  static const double _navBarIconSize = 28.0;
  static const Duration _backPressThreshold = Duration(seconds: 2);
  static const double _selectedItemOpacity = 0.7;
  static const double _navBarElevation = 10.0;
  static const double _navLabelFontSize = 11.0;

  // Cached UI elements with lazy initialization
  late final _UiCache _uiCache = _UiCache();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.pageIndex;
    WidgetsBinding.instance.addObserver(this);
    _initializeData();
  }

  Future<void> _initializeData() async {
    // Use a post-frame callback to ensure the widget is fully built
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await loadData();
    });
    await MyNotification.getNotificationTerminate();
  }

  /// Loads initial data from APIs with optimized error handling
  /// Loads initial data from APIs with optimized error handling
  static FutureOr<void> loadData({bool refresh = false}) async {
    // Check if context is available
    final BuildContext? context = Get.context;
    if (context == null) {
      return;
    }

    try {
      final CitiesCubit citiesCubit = context.read<CitiesCubit>();
      await citiesCubit.getSelectedCityState();

      final CitiesState state = citiesCubit.state;
      if (state.error != null || state is CitiesInitial) {
        RouterHelper.getSelectLocationRoute();
        return;
      }
      if (state is! SelectedCitySuccess) {
        RouterHelper.getCitiesRoute();
        return;
      }

      final WeatherCubit weatherCubit = context.read<WeatherCubit>();

      // ✅ Load only what doesn't depend on /user subscription here
      await Future.wait<void>(<Future<void>>[
        weatherCubit.getWeatherData(state.selectedCity!, refresh: refresh),
        sl<AdsService>().initialize(),
      ]);
    } catch (e) {
      debugPrint('Error loading initial data: $e');
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    sl<AdsService>().dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _uiCache.invalidate();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _handleBackButton,
      child: UiWidget(child: (Appearance ui) => _buildScaffold(ui)),
    );
  }

  /// Handles back button press with double-tap to exit logic
  void _handleBackButton(bool didPop, Object? result) {
    if (didPop) {
      return;
    }

    // First navigate to home tab if on another tab
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
      return;
    }

    // Handle double-tap to exit
    final DateTime now = DateTime.now();
    if (_lastBackPressTime == null ||
        now.difference(_lastBackPressTime!) > _backPressThreshold) {
      _lastBackPressTime = now;
      showSnackBar(context, 'dashboard.press_again_to_exit'.tr());
      return;
    }

    // Exit the app
    SystemNavigator.pop();
  }

  Widget _buildScaffold(Appearance ui) {
    final _UiColors uiColors = _uiCache.getColors(context, ui, _currentIndex);
    
    return AppUiOverlayStyle(
      systemNavigationBarColor: uiColors.background,
      child: Scaffold(
        backgroundColor: uiColors.background,
        bottomNavigationBar: _buildBottomNavigation(uiColors),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildBottomNavigation(_UiColors colors) {
    return BottomNavigationBar(
      elevation: _navBarElevation,
      backgroundColor: colors.background,
      type: BottomNavigationBarType.fixed,
      onTap: _handleNavTap,
      currentIndex: _currentIndex,
      selectedFontSize: _navLabelFontSize,
      unselectedFontSize: _navLabelFontSize,
      selectedItemColor: colors.selected.withOpacity(_selectedItemOpacity),
      unselectedItemColor: colors.unselected,
      iconSize: _navBarIconSize,
      selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500),
      items: _uiCache.getNavigationItems(context),
    );
  }

  /// Handles navigation tab changes with optimized setState
  void _handleNavTap(int index) {
    if (index != _currentIndex) {
      setState(() {
        _currentIndex = index;
        _uiCache.invalidateColors(); // Only invalidate colors when changing tabs
      });
    }
  }



  Widget _buildBody() {
    final List<Widget> pages = _uiCache.getPages(context);
    
    // Use IndexedStack to preserve state of inactive tabs
    return Column(
      children: <Widget>[
        Expanded(
          child: IndexedStack(index: _currentIndex, children: pages),
        ),
        // Add native ad at the bottom of the screen
        const NativeAdWidget(
          size: AdSize.banner,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
      ],
    );
  }
}

/// Helper class to manage UI colors
class _UiColors {

  const _UiColors({
    required this.background,
    required this.selected,
    required this.unselected,
  });
  final Color background;
  final Color selected;
  final Color unselected;
}

/// Efficient UI caching system to prevent unnecessary rebuilds
class _UiCache {
  // Color caching
  _UiColors? _colors;
  
  // Navigation items caching
  List<BottomNavigationBarItem>? _navItems;
  bool? _isArabicNavItems;
  
  // Pages caching
  List<Widget>? _pages;
  bool? _isArabicPages;

  /// Get UI colors with caching
  _UiColors getColors(BuildContext context, Appearance ui, int currentIndex) {
    if (_colors != null) {
      return _colors!;
    }

    final bool isWeatherTab = currentIndex == 0 && ui.type != 'video';
    
    final Color backgroundColor = isWeatherTab
        ? convertHexaToColor(ui.background!.first)
        : Colors.white;
        
    final Color selectedColor = isWeatherTab
        ? convertHexaToColor(ui.buttonColor!)
        : Theme.of(context).primaryColor;
        
    final Color unselectedColor = isWeatherTab
        ? convertHexaToColor(ui.textColor!)
        : Colors.black;

    _colors = _UiColors(
      background: backgroundColor,
      selected: selectedColor,
      unselected: unselectedColor,
    );
    
    return _colors!;
  }

  /// Get navigation items with caching based on language
  List<BottomNavigationBarItem> getNavigationItems(BuildContext context) {
    final bool isArabic = context.read<LanguageCubit>().isArabic();
    
    // Return cached items if language hasn't changed
    if (_navItems != null && _isArabicNavItems == isArabic) {
      return _navItems!;
    }
    
    _isArabicNavItems = isArabic;
    
    const double iconSize = 15.0;
    final List<Map<String, Object>> navItems = <Map<String, Object>>[
      <String, Object>{
        'icon': FeatherIcons.sun,
        'label': 'dashboard.weather'.tr(),
      },
      <String, Object>{
        'icon': FeatherIcons.barChart2,
        'label': 'dashboard.charts'.tr(),
      },
      <String, Object>{'icon': FeatherIcons.map, 'label': 'dashboard.map'.tr()},
      if (isArabic)
        <String, Object>{
          'icon': FeatherIcons.bookOpen,
          'label': 'dashboard.articles'.tr(),
        },
      <String, Object>{
        'icon': FeatherIcons.user,
        'label': 'dashboard.profile'.tr(),
      },
    ];

    _navItems = navItems
        .map(
          (Map<String, Object> item) => BottomNavigationBarItem(
            icon: Icon(item['icon']! as IconData, size: iconSize),
            label: item['label']! as String,
          ),
        )
        .toList();

    return _navItems!;
  }

  /// Get page widgets with caching based on language
  List<Widget> getPages(BuildContext context) {
    final bool isArabic = context.read<LanguageCubit>().isArabic();
    
    // Return cached pages if language hasn't changed
    if (_pages != null && _isArabicPages == isArabic) {
      return _pages!;
    }
    
    _isArabicPages = isArabic;
    
    // Use const widgets with keys for better performance
    _pages = <Widget>[
      const WeatherFeature(key: ValueKey('weather_feature')),
      const ChartsPage(key: ValueKey('charts_page')),
      const MapsScreen(key: ValueKey('maps_screen')),
      if (isArabic) const ArticlePage(key: ValueKey('article_page')),
      const ProfilePage(key: ValueKey('profile_page')),
    ];
    
    return _pages!;
  }
  
  /// Invalidate all cached values
  void invalidate() {
    invalidateColors();
    _navItems = null;
    _isArabicNavItems = null;
    _pages = null;
    _isArabicPages = null;
  }
  
  /// Invalidate only color caches
  void invalidateColors() {
    _colors = null;
  }
}
