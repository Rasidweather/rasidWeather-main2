import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:get_user_agent/get_user_agent.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'bloc/app_cubit/app_cubit.dart';
import 'bloc/articles_cubit/articles_cubit.dart';
import 'bloc/categories_cubit/categories_cubit.dart';
import 'bloc/inquiries_cubit/inquiries_cubit.dart';
import 'bloc/map_screen/map_screen_cubit.dart';
import 'bloc/map_view/map_view_cubit.dart';
import 'bloc/maps_cubit/maps_cubit.dart';
import 'bloc/profile_cubit/profile_cubit.dart';
import 'bloc/splash_cubit/splash_cubit.dart';
import 'bloc/ui_cubit/ui_cubit.dart';
import 'common/constants/strings.dart';
import 'core/network/dio_helper.dart';
import 'core/network/logging_interceptor.dart';
import 'core/services/dialog_service.dart';
import 'data/repository/articles_repo.dart';
import 'data/repository/inquiries_repo.dart';
import 'data/repository/maps_repo.dart';
import 'data/repository/profile_repo.dart';
import 'data/repository/splash_repo.dart';
import 'data/repository/weather_repo.dart';
import 'features/ads/data/repositories/ads_repository.dart';
import 'features/ads/domain/repositories/i_ads_repository.dart';
import 'features/ads/presentation/services/ads_service.dart';
import 'features/auth/data/repositories/auth_repo.dart';
import 'features/auth/domain/repositories/i_auth_repository.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/cities/data/repositories/cities_repo.dart';
import 'features/cities/domain/repositories/i_cities_repository.dart';
import 'features/cities/presentation/cubit/cities_cubit.dart';
import 'features/language/cubit/language_cubit.dart';
import 'features/notifications/data/repositories/notifications_repo.dart';
import 'features/notifications/domain/repositories/i_notifications_repository.dart';
import 'features/notifications/presentation/cubit/notifications_cubit.dart';
import 'features/weather/data/repositories/weather_repo.dart';
import 'features/weather/domain/repositories/i_projects_repository.dart';
import 'features/weather/presentation/cubit/weather_cubit.dart';
import 'providers/tab_index_bloc.dart';
import 'providers/theme_provider.dart';

final GetIt sl = GetIt.instance;

Future<void> setupLocator() async {
  // External Services
  await _setupExternalServices();

  // Core
  _setupCore();

  // Repositories
  _setupRepositories();

  // Providers and Cubits
  _setupProvidersAndCubits();
}

Future<void> _setupExternalServices() async {
  try {
    final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final FirebaseMessaging fcm = FirebaseMessaging.instance;
    // final DatabaseHelper databaseHelper = DatabaseHelper.instance;
    final InAppPurchase inAppPurchase = InAppPurchase.instance;

    sl.registerLazySingleton(() => sharedPreferences);
    sl.registerLazySingleton(() => fcm);
    // sl.registerLazySingleton(() => databaseHelper);
    sl.registerLazySingleton(() => inAppPurchase);
    sl.registerLazySingleton(() => Dio());
    sl.registerLazySingleton(() => LoggingInterceptor());
    sl.registerLazySingleton(() => GoogleSignIn());
    sl.registerLazySingleton(() => SignInWithApple());
    sl.registerLazySingleton(() => UserAgent());
  } catch (e) {
    print('Error setting up external services: $e');
  }
}

void _setupCore() {
  sl.registerLazySingleton(() => DioClient(
    AppStrings.baseUrl,
    sl(),
    loggingInterceptor: sl(),
    sharedPreferences: sl(),
    userAgent: sl(),
  ));
  sl.registerLazySingleton(() => GlobalKey<ScaffoldState>());
  sl.registerLazySingleton(() => DialogService());
  sl.registerLazySingleton(() => ThemeModeNotifier()..initTheme());
  sl.registerLazySingleton(() => TabIndexBloc());
}

void _setupRepositories() {
  sl.registerLazySingleton(() => WeatherRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => InquiriesRepo(sharedPreferences: sl(), dioClient: sl()));
  // sl.registerLazySingleton(() => CitiesRepo(firebaseMessaging: sl(), dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => SplashRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => ArticlesRepo(sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton<IAuthRepository>(() => AuthRepo(firebaseMessaging: sl(), googleSignIn: sl(), sharedPreferences: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => ProfileRepo(sharedPreferences: sl(), googleSignIn: sl(), dioClient: sl()));
  // sl.registerLazySingleton(() => NotificationRepo(databaseHelper: sl(), sharedPreferences: sl(), firebaseMessaging: sl(), dioClient: sl()));
  sl.registerLazySingleton(() => MapsRepo(sl()));
  sl.registerLazySingleton<IAdsRepository>(() => AdsRepository());
  sl.registerLazySingleton<IWeatherRepository>(() => WeathersRepo(sl()));
  sl.registerLazySingleton<INotificationsRepository>(() => NotificationsRepo(sl(),sl()));
  sl.registerLazySingleton<ICitiesRepository>(() => CitiesRepo(firebaseMessaging: sl(), dioClient: sl(), sharedPreferences: sl()));
  sl.registerLazySingleton(() => AdsService(sl()));
}

void _setupProvidersAndCubits() {
  sl.registerLazySingleton(() => LanguageCubit(sl(), sl()));
  sl.registerLazySingleton(() => ProfileCubit(sl()));
  sl.registerFactory(() => CitiesCubit(citiesRepo: sl()));
  sl.registerLazySingleton(() => WeatherCubit(sl(), sl()));
  // sl.registerFactory<SubscriptionCubit>(
  //       () => SubscriptionCubit(sl<ProfileRepo>()),
  // );
  sl.registerFactory(() => InquiriesBloc(sl()));
  // sl.registerFactory(() => ChartsCubit(sl()));
  sl.registerLazySingleton(() => UiCubit());
  sl.registerFactory(() => SplashCubit(sl()));
  sl.registerFactory(() => ArticlesBloc(sl()));
  sl.registerFactory(() => CategoriesCubit(sl()));
  sl.registerFactory(() => AuthCubit(sl()));
  // sl.registerFactory(() => NotificationCubit(sl(), sl()));
  sl.registerFactory(() => AppCubit());
  sl.registerFactory(() => MapsCubit(sl()));
  sl.registerFactory(() => NotificationsCubit(sl()));
  sl.registerFactory(() => MapScreenCubit());
  sl.registerFactory(() => MapViewCubit());
}
