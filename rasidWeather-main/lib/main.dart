// Dart imports
import 'dart:async';
import 'dart:io';
import 'dart:ui';

// Localization
import 'package:easy_localization/easy_localization.dart';
// Firebase packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
// Flutter imports
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// State management
import 'package:flutter_bloc/flutter_bloc.dart';
// Notifications
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// UI related
import 'package:flutter_screenutil/flutter_screenutil.dart';
// Navigation
import 'package:go_router/go_router.dart';
// Ads
import 'package:google_mobile_ads/google_mobile_ads.dart';
// State persistence
import 'package:hydrated_bloc/hydrated_bloc.dart';
// IAP (store_config + revenuecat + in_app_purchase)
import 'package:in_app_purchase/in_app_purchase.dart';
// Leak tracking
import 'package:leak_tracker/leak_tracker.dart';
// DI & storage & providers
import 'package:nested/nested.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

// App features - Blocs & Cubits
import 'bloc/app_cubit/app_cubit.dart';
import 'bloc/articles_cubit/articles_cubit.dart';
import 'bloc/categories_cubit/categories_cubit.dart';
import 'bloc/inquiries_cubit/inquiries_cubit.dart';
import 'bloc/maps_cubit/maps_cubit.dart';
import 'bloc/profile_cubit/profile_cubit.dart';
import 'bloc/splash_cubit/splash_cubit.dart';
import 'bloc/subscription_cuibt/subscription_cubit.dart';
import 'bloc/ui_cubit/ui_cubit.dart';
// Services & Repositories
import 'common/constants/strings.dart';
import 'common/helper/dialog_manager.dart';
import 'constant.dart';
import 'core/services/dialog_service.dart';
import 'core/themes/app_theme.dart';
import 'data/repository/profile_repo.dart';
// Ads
import 'features/ads/presentation/widgets/native_ad_factory.dart';
// Features
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/cities/presentation/cubit/cities_cubit.dart';
import 'features/language/cubit/language_cubit.dart';
import 'features/notifications/presentation/cubit/notifications_cubit.dart';
import 'features/weather/presentation/cubit/weather_cubit.dart';
// Helpers
import 'helper/my_notification.dart';
import 'helper/router_helper.dart';
// DI
import 'locator.dart';

// Services
import 'services/revenuecat_webhook_service.dart';
// Misc providers
import 'providers/tab_index_bloc.dart';
import 'providers/theme_provider.dart';
import 'src/model/singletons_data.dart';
// Store config / constants
import 'store_config.dart';

/// Global app instances
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
AndroidNotificationChannel? channel;

/// Request notification permissions for iOS
void _requestPermissions() {
  flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >()
      ?.requestPermissions(alert: true, badge: true, sound: true);
}

/// Custom shader warm-up implementation to improve first frame rendering
class MyShaderWarmUp extends ShaderWarmUp {
  @override
  Future<void> warmUpOnCanvas(Canvas canvas) async {
    const Rect rect = Rect.fromLTWH(0, 0, 100, 100);

    final Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: <Color>[Color(0xFF000000), Color(0xFFFFFFFF)],
      ).createShader(rect);

    canvas.drawRect(rect, paint);
  }
}

/// Application entry point
Future<void> main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();
  await AppStrings.init();

  // Enable memory leak tracking in debug mode
  if (kDebugMode) {
    LeakTracking.start();
  }

  // StoreConfig (RevenueCat API key per platform)
  if (kIsWeb) {
    StoreConfig(store: Store.rcBilling, apiKey: webApiKey);
  } else if (Platform.isIOS || Platform.isMacOS) {
    StoreConfig(store: Store.appStore, apiKey: appleApiKey);
  } else if (Platform.isAndroid) {
    const bool useAmazon = bool.fromEnvironment('amazon');
    StoreConfig(
      store: useAmazon ? Store.amazon : Store.playStore,
      apiKey: useAmazon ? amazonApiKey : googleApiKey,
    );
  }

  await configureRevenueCat();

  // Improve first frame rendering with shader warm-up
  PaintingBinding.shaderWarmUp = MyShaderWarmUp();

  // Initialize Firebase services
  await _initializeFirebase();

  // Initialize Mobile Ads with detailed logging and retry mechanism
  initializeAdMob();

  // Register native ad factories
  NativeAdFactory.registerNativeAdFactories();

  // Configure HydratedBloc storage for persistent state
  await _configureHydratedStorage();

  // Configure image cache size (50MB)
  PaintingBinding.instance.imageCache.maximumSizeBytes = 1024 * 1024 * 50;

  // Custom error widget for better UX during crashes
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return const Center(child: Text('Something went wrong!'));
  };

  // Initialize notifications (local notifications + channel)
  await _initializeNotifications();

  // Configure router
  GoRouter.optionURLReflectsImperativeAPIs = true;

  // Configure HTTP overrides for SSL handling
  HttpOverrides.global = MyHttpOverrides();

  // Setup dependency injection
  await setupLocator();

  // Request notification permissions
  _requestPermissions();

  // Initialize localization
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const <Locale>[Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      useOnlyLangCode: true,
      child: MultiBlocProvider(
        providers: _createProviders(),
        child: const App(),
      ),
    ),
  );
}

/// RevenueCat / Purchases configuration
Future<void> configureRevenueCat() async {
  await Purchases.setLogLevel(LogLevel.debug);

  late PurchasesConfiguration configuration;
  if (StoreConfig.isForAmazonAppstore()) {
    configuration = AmazonConfiguration(StoreConfig.instance.apiKey);
  } else {
    configuration = PurchasesConfiguration(StoreConfig.instance.apiKey);
  }

  await Purchases.configure(configuration);

  // تحديث الفلاجز عند أي تغيّر بالاِشتراك مع إرسال webhook
  Purchases.addCustomerInfoUpdateListener((CustomerInfo info) async {
    try {
      final String appUserId = await Purchases.appUserID;
      print('🔔 CustomerInfo updated - User: $appUserId');
      print('🔔 Active entitlements: ${info.entitlements.active.keys}');
      print('🔔 All entitlements: ${info.entitlements.all.keys}');

      await RevenueCatWebhookService.syncCustomerInfo(
        customerInfo: info,
        appUserId: appUserId,
      );
    } catch (e) {
      print('❌ Error handling customer info update: $e');
    }
  });

  // ريفريش مبدئي عند تشغيل التطبيق
  try {
    await Purchases.getCustomerInfo();
  } catch (_) {}
}

/// Initialize AdMob with retry logic
void initializeAdMob() {
  int retryAttempt = 0;
  const int maxRetries = 3;

  Future<void> attemptInitialize() async {
    try {
      final InitializationStatus status = await MobileAds.instance.initialize();

      final Map<String, AdapterStatus> statusMap = status.adapterStatuses;
      statusMap.forEach((String key, AdapterStatus value) {
        debugPrint('Adapter status for $key: ${value.state}');
      });

      debugPrint('Mobile Ads SDK initialized successfully');
    } catch (e) {
      debugPrint('Error initializing AdMob: $e');

      if (retryAttempt < maxRetries) {
        retryAttempt++;
        debugPrint(
          'Retrying AdMob initialization (attempt $retryAttempt of $maxRetries)',
        );
        await Future<void>.delayed(Duration(seconds: 2 * retryAttempt));
        attemptInitialize();
      } else {
        debugPrint('Failed to initialize AdMob after $maxRetries attempts');
      }
    }
  }

  attemptInitialize();
}

/// Initialize Firebase services
Future<void> _initializeFirebase() async {
  await Firebase.initializeApp();

  // Configure Crashlytics
  FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(!kDebugMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
}

/// Configure HydratedBloc storage
Future<void> _configureHydratedStorage() async {
  final Directory directory = await getApplicationDocumentsDirectory();

  final HydratedStorageDirectory hydratedDir = HydratedStorageDirectory(
    directory.path,
  );

  final HydratedStorage storage = await HydratedStorage.build(
    storageDirectory: hydratedDir,
  );

  HydratedBloc.storage = storage;
}

/// Initialize notification channels and settings
Future<void> _initializeNotifications() async {
  try {
    channel = const AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      importance: Importance.high,
    );

    await MyNotification.initialize(flutterLocalNotificationsPlugin);

    final AndroidFlutterLocalNotificationsPlugin? androidNotifications =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();

    if (androidNotifications != null && channel != null) {
      await androidNotifications.createNotificationChannel(channel!);
    }
  } catch (e) {
    debugPrint('Error initializing notifications: $e');
  }
}

/// Create all providers for state management
List<SingleChildWidget> _createProviders() {
  return <SingleChildWidget>[
    BlocProvider<AppCubit>.value(value: sl<AppCubit>()),
    BlocProvider<LanguageCubit>.value(value: sl<LanguageCubit>()),
    BlocProvider<ProfileCubit>.value(value: sl<ProfileCubit>()),
    BlocProvider<WeatherCubit>.value(value: sl<WeatherCubit>()),
    BlocProvider<CitiesCubit>.value(value: sl<CitiesCubit>()),
    BlocProvider<UiCubit>.value(value: sl<UiCubit>()),
    BlocProvider<InquiriesBloc>(
      create: (BuildContext context) => InquiriesBloc(sl()),
    ),

    /// ✅ SubscriptionCubit موجود هنا على مستوى التطبيق كله
    BlocProvider<SubscriptionCubit>(
      create: (_) => SubscriptionCubit(
        InAppPurchase.instance, // الأول: inAppPurchase
        sl<ProfileRepo>(), // الثاني: profileRepo
      )..fetchSubscriptions(),
    ),

    BlocProvider<SplashCubit>(
      create: (BuildContext context) => SplashCubit(sl()),
    ),
    BlocProvider<ArticlesBloc>(
      create: (BuildContext context) => ArticlesBloc(sl()),
    ),
    BlocProvider<CategoriesCubit>(
      create: (BuildContext context) => CategoriesCubit(sl()),
    ),
    BlocProvider<AuthCubit>(create: (BuildContext context) => AuthCubit(sl())),
    BlocProvider<NotificationsCubit>(
      create: (BuildContext context) => NotificationsCubit(sl()),
    ),
    BlocProvider<MapsCubit>(create: (BuildContext context) => MapsCubit(sl())),
    ChangeNotifierProvider<ThemeModeNotifier>(
      create: (BuildContext context) => sl<ThemeModeNotifier>()..initTheme(),
    ),
    ChangeNotifierProvider<TabIndexBloc>(
      create: (BuildContext context) => sl<TabIndexBloc>(),
    ),
  ];
}

/// Main application widget
class App extends StatefulWidget {
  const App({super.key});

  @override
  AppState createState() => AppState();
}

/// Application state that handles lifecycle events and builds the main UI
class AppState extends State<App> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();

    // Lock orientation to portrait mode only
    SystemChrome.setPreferredOrientations(<DeviceOrientation>[
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // Register observer for app lifecycle events
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);

    // عند الرجوع من الخلفية نحدّث حالة الـ VIP
    if (state == AppLifecycleState.resumed) {
      await _refreshRevenueCatOnResume();
      try {
        final SubscriptionCubit subCubit = context.read<SubscriptionCubit>();
        await subCubit.fetchSubscriptions();
      } catch (_) {
        // لو لأي سبب الـ Cubit مش موجود ما نخلي التطبيق ينهار
      }
    }
  }

  Future<void> _refreshRevenueCatOnResume() async {
    try {
      final CustomerInfo info = await Purchases.getCustomerInfo();
      appData.appUserID = await Purchases.appUserID;
      appData.entitlementIsActive =
          info.entitlements.all[entitlementID]?.isActive ?? false;
    } catch (_) {}
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(
        MediaQuery.sizeOf(context).width,
        MediaQuery.sizeOf(context).height,
      ),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return MaterialApp.router(
          key: ValueKey<String>(context.locale.languageCode),
          routerConfig: RouterHelper.goRoutes,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          locale: context.locale,
          title: 'Rasid Weather',
          debugShowCheckedModeBanner: false,
          theme: _getThemeData(),
          builder: (BuildContext context, Widget? child) {
            return Navigator(
              key: sl<DialogService>().dialogNavigationKey,
              onGenerateRoute: (RouteSettings settings) {
                return MaterialPageRoute<Widget>(
                  builder: (BuildContext context) {
                    return DialogManager(child: child!);
                  },
                );
              },
            );
          },
          scrollBehavior: const MaterialScrollBehavior().copyWith(
            dragDevices: <PointerDeviceKind>{
              PointerDeviceKind.mouse,
              PointerDeviceKind.touch,
              PointerDeviceKind.stylus,
            },
          ),
        );
      },
    );
  }

  /// Get the app theme data
  ThemeData _getThemeData() => appLightThemeData(context);
}

/// Custom HTTP client that accepts all SSL certificates
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

/// Utility class for accessing global navigator context
class Get {
  static BuildContext? get context => navigatorKey.currentContext;
  static NavigatorState? get navigator => navigatorKey.currentState;
}

// ===================== IAP Demo (لو محتاجها) =====================

// حدّث هذه المجموعة لو أضفت أو غيّرت معرّفات المنتجات من المتجر
const Set<String> kProductIds = <String>{
  'annual_package', // Gold Package
  'annual_package_2', // Premium Package
  'rasid_999_m1',
  'trial_package',
};

// باقي كود IapDemoApp / IapHomePage نفس ما عندك (ما له علاقة مباشرة بالكرش الأساسي)
