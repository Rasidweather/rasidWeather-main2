import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../bloc/splash_cubit/splash_cubit.dart';
import '../core/guards/login_gate.dart';
import '../data/model/article_model.dart';
import '../data/model/user_model.dart';
import '../enums/html_type.dart';
import '../features/auth/presentation/screens/login_screen.dart';
import '../features/auth/presentation/screens/request_reset_password.dart';
import '../features/auth/presentation/screens/reset_password.dart';
import '../features/auth/presentation/screens/signup_screen.dart';
import '../features/cities/presentation/screens/saved_cities_screen.dart';
import '../features/language/presentation/screens/language_selection_screen.dart';
import '../features/notifications/presentation/screens/notifications_body.dart';
import '../features/weather/data/models/weather_model.dart';
import '../features/weather/presentation/screens/days_weather_screen/daily_forecast_screen.dart';
import '../features/weather/presentation/screens/weather_page/components/weather_maps_widget.dart';
import '../main.dart';
import '../views/base/maintenance_screen.dart';
import '../views/base/not_found_page.dart';
import '../views/screens/articles_screen/article_details/article_details.dart';
import '../views/screens/articles_screen/article_details/comments/comments.dart';
import '../views/screens/articles_screen/article_details/video_article_details.dart';
import '../views/screens/articles_screen/articles_components/index.dart';
import '../views/screens/dashboard.dart';
import '../views/screens/html/html_viewer_screen.dart';
import '../views/screens/inquiries_screen/inquiries_screen.dart';
import '../views/screens/maps/weather_maps_screen.dart';
import '../views/screens/no_city_screen/no_city_screen.dart';
import '../views/screens/profile_screen/contact_us.dart';
import '../views/screens/profile_screen/delete_account.dart';
import '../views/screens/profile_screen/edit_profile.dart';
import '../views/screens/splash/intro.dart';
import '../views/screens/splash/splash.dart';
import '../views/screens/subscription_screen/subscription_intro.dart';
import '../views/screens/subscription_screen/subscription_screen.dart';
import '../views/screens/subscription_screen/sucsess_subscription.dart';

enum RouteAction { push, pushReplacement, popAndPush, pushNamedAndRemoveUntil }

class RouterHelper {
  static const String splashScreen = '/splash';
  static const String onBoardingScreen = '/on_boarding';
  static const String languageSelectionScreen = '/language-selection';
  static const String welcomeScreen = '/welcome';
  static const String loginScreen = '/login';
  static const String signupScreen = '/sign-up';
  static const String forgotPassScreen = '/forgot-password';
  static const String resetPassScreen = '/reset-password';
  static const String dashboard = '/';
  static const String maintain = '/maintain';
  static const String searchScreen = '/search';
  static const String notificationScreen = '/notification';
  static const String articleDetailsScreen = '/article/:articleId';
  static const String articleCommentsScreen = '/article-comments';
  static const String rateScreen = '/rate-review';
  static const String removeAccountScreen = '/remove-account';
  static const String bookmarkScreen = '/bookmark-screen';
  static const String editProfileScreen = '/profile';
  static const String editInquiriesScreen = '/inquiries';
  static const String premiumRadar = '/premium-radar';

  static const String citiesScreen = '/address';
  // static const String addCityScreen = '/add-address';
  static const String selectLocationScreen = '/select-location';
  static const String couponScreen = '/coupons';
  static const String supportScreen = '/support';
  static const String termsScreen = '/terms';
  static const String policyScreen = '/privacy-policy';
  static const String aboutUsScreen = '/about-us';
  static const String imageDialog = '/image-dialog';
  static const String menuScreenWeb = '/menu_screen_web';
  static const String homeScreen = '/home';
  static const String returnPolicyScreen = '/return-policy';
  static const String refundPolicyScreen = '/refund-policy';
  static const String cancellationPolicyScreen = '/cancellation-policy';
  static const String fullMapsScreen = '/full-maps-screen';
  static const String subscriptionScreen = '/subscription-screen';
  static const String subscriptionIntroScreen = '/subscription-intro-screen';
  static const String successSubscriptionScreen = '/success-subscription-screen';
  static const String daysScreen = '/days-screen';

  static String getFullMaps(WeatherMapItem model, {RouteAction? action}) {
    final String data = Uri.encodeComponent(jsonEncode(model.toMap()));
    return _navigateRoute('$fullMapsScreen?map=$data', route: action);
  }

  static String getSplashRoute({RouteAction? action}) => _navigateRoute(splashScreen, route: action);

  static String getOnBoardingRoute({RouteAction? action}) => _navigateRoute(onBoardingScreen, route: action);

  static String getWelcomeRoute() => _navigateRoute(welcomeScreen, route: RouteAction.pushReplacement);

  static String getLoginRoute({RouteAction? action}) => _navigateRoute(loginScreen, route: action);

  static String getSignUpRoute() => _navigateRoute(signupScreen);

  static String getForgetPassRoute() => _navigateRoute(forgotPassScreen);

  static String getResetPassRoute(String email, String otp) => _navigateRoute('$resetPassScreen?email=$email&otp=$otp');

  // static String getMainRoute({RouteAction? action}) => _navigateRoute(homeScreen, route: action);

  static String getMaintainRoute({RouteAction? action}) => _navigateRoute(maintain, route: RouteAction.pushReplacement);

  static String getDashboardRoute(String page, {RouteAction? action}) => _navigateRoute('$homeScreen?page=$page', route: action);

  static String getSearchRoute() => _navigateRoute(searchScreen);

  static String getNotificationRoute() => _navigateRoute(notificationScreen);

  static String getArticleDetailsRoute(String articleId, {ArticleModel? article, RouteAction? action}) {
    final String data = Uri.encodeComponent(jsonEncode(article));
    return _navigateRoute('$articleDetailsScreen?article=$data&articleId=${Uri.encodeComponent(articleId)}', route: action);
  }

  static String getDaysScreenRoute({int? index, WeatherModel? weather, RouteAction? action}) {
    final String data = Uri.encodeComponent(jsonEncode(weather));
    return _navigateRoute('$daysScreen?index=$index&weather=$data', route: action);
  }

  static String getSuccessSubscriptionRoute({RouteAction? action}) => _navigateRoute(successSubscriptionScreen, route: action);

  static String getSubscriptionIntroRoute() => _navigateRoute(subscriptionIntroScreen);

  static String getSubscriptionRoute({RouteAction? action}) => _navigateRoute(subscriptionScreen, route: action);

  static String getRateReviewRoute() => _navigateRoute(rateScreen);

  static String getRemoveAccountRoute() => _navigateRoute(removeAccountScreen);

  static String getBookmarkRoute() => _navigateRoute(bookmarkScreen);

  static String getEditProfileRoute(UserModel user) {
    final String data = Uri.encodeComponent(jsonEncode(user));
    return _navigateRoute('$editProfileScreen?user=$data');
  }

  static String getInquiriesRoute(UserModel user) {
    final String data = Uri.encodeComponent(jsonEncode(user));
    return _navigateRoute('$editInquiriesScreen?user=$data');
  }

  static String getCitiesRoute({bool? isFirstTime = false}) => _navigateRoute('$citiesScreen?isFirstTime=$isFirstTime');

  // static String getAddCityRoute() => _navigateRoute(addCityScreen);

  static String getSelectLocationRoute() => _navigateRoute(selectLocationScreen);

  static String getCouponRoute() => _navigateRoute(couponScreen);

  static String getSupportRoute() => _navigateRoute(supportScreen);

  static String getTermsRoute() => _navigateRoute(termsScreen);

  static String getPolicyRoute() => _navigateRoute(policyScreen);

  static String getAboutUsRoute() => _navigateRoute(aboutUsScreen);

  static String getReturnPolicyRoute() => _navigateRoute(returnPolicyScreen);

  static String getCancellationPolicyRoute() => _navigateRoute(cancellationPolicyScreen);

  static String getRefundPolicyRoute() => _navigateRoute(refundPolicyScreen);

  static String getLandingScreenRoute() => _navigateRoute(languageSelectionScreen);

  static String getArticleComments(String articleId) => _navigateRoute('$articleCommentsScreen?articleId=$articleId');

  static String _navigateRoute(String path, {RouteAction? route = RouteAction.push}) {
    print('path =======>>>>  : $path , route : $route');
    if (route == RouteAction.pushNamedAndRemoveUntil) {
      Get.context?.go(path);
    } else if (route == RouteAction.pushReplacement) {
      Get.context?.pushReplacement(path);
    } else {
      Get.context?.push(path);
    }
    return path;
  }

  static Widget _routeHandler(BuildContext context, Widget route, {bool isBranchCheck = false}) {
    if (Provider.of<SplashCubit>(context, listen: false).maintenanceMode) {
      return const MaintenanceScreen();
    }
    return route;
  }

  static final GoRouter goRoutes = GoRouter(
    navigatorKey: navigatorKey,
    initialLocation: getSplashRoute(),
    errorBuilder: (BuildContext ctx, GoRouterState state) {
      print('errorBuilder =======>>>>  : ${state.uri.path}');
      return const NotFound();
    },
    routes: <RouteBase>[
      GoRoute(path: successSubscriptionScreen, builder: (BuildContext context, GoRouterState state) => const SuccessSubscriptionScreen()),
      GoRoute(path: subscriptionIntroScreen, builder: (BuildContext context, GoRouterState state) => const SubscriptionIntroScreen()),
      GoRoute(path: subscriptionScreen, builder: (BuildContext context, GoRouterState state) => const SubscriptionScreen()),
      GoRoute(path: splashScreen, builder: (BuildContext context, GoRouterState state) => const SplashScreen()),
      GoRoute(path: languageSelectionScreen, builder: (BuildContext context, GoRouterState state) => const LanguageSelectionScreen()),
      GoRoute(path: maintain, builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const MaintenanceScreen())),
      GoRoute(path: onBoardingScreen, builder: (BuildContext context, GoRouterState state) => const OnBoardingScreen()),
      GoRoute(path: loginScreen, builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const LoginScreen())),
      GoRoute(path: signupScreen, builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const SignUpScreen())),
      GoRoute(path: forgotPassScreen, builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const RequestResetPasswordScreen())),
      GoRoute(
          path: resetPassScreen,
          builder: (BuildContext context, GoRouterState state) {
            final String email = state.uri.queryParameters['email'].toString();
            final String otp = state.uri.queryParameters['otp'].toString();
            return _routeHandler(context, ResetPasswordScreen(email: email, otp: otp));
          }),
      GoRoute(
          path: fullMapsScreen,
          builder: (BuildContext context, GoRouterState state) {
            final Map<String, dynamic> map = jsonDecode('${state.uri.queryParameters['map']}') as Map<String, dynamic>;
            final WeatherMapItem model = WeatherMapItem.fromMap(map);
            return _routeHandler(context, FullMapScreen(map: model));
          }),
      GoRoute(
          path: homeScreen,
          builder: (BuildContext context, GoRouterState state) {
            return _routeHandler(
                context,
                Dashboard(
                  pageIndex: state.uri.queryParameters['page'] == 'home'
                      ? 0
                      : state.uri.queryParameters['page'] == 'charts_page'
                          ? 1
                          : state.uri.queryParameters['page'] == 'maps'
                              ? 2
                              : state.uri.queryParameters['page'] == 'news'
                                  ? 3
                                  : state.uri.queryParameters['page'] == 'profile'
                                      ? 4
                                      : 0,
                ),
                isBranchCheck: true);
          }),
      GoRoute(
          path: homeScreen,
          builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const Dashboard(pageIndex: 0))),
      GoRoute(path: searchScreen, builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const SearchScreen())),
      GoRoute(path: notificationScreen, builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const NotificationScreen())),
      GoRoute(
        path: articleDetailsScreen,
        builder: (BuildContext context, GoRouterState state) {
          final Map<String, dynamic>? article = jsonDecode('${state.uri.queryParameters['article']}') as Map<String, dynamic>?;
          final String articleIdFromPath = state.uri.path.split('/').last;
          final String? articleId0 = state.uri.queryParameters['articleId'];
          final String articleId = articleIdFromPath != ':articleId' ? articleIdFromPath : articleId0!;
          final ArticleModel? model = article != null ? ArticleModel.fromJson(article) : null;
          if (model != null && model.contentType == 'video') {
            return _routeHandler(context,
                VideoArticleDetails(deepLink: articleIdFromPath != ':articleId', article: model, articleId: articleId, tag: 'video${model.id!}'));
          }
          return _routeHandler(context, ArticleDetails(deepLink: articleIdFromPath != ':articleId', articleId: articleId, tag: 'image$articleId'));
        },
      ),
      GoRoute(
        path: RouterHelper.premiumRadar, // أو أي مسار بدك تحميه بتسجيل دخول فقط
        builder: (BuildContext context, GoRouterState state) => const LoginGate(
          child: SuccessSubscriptionScreen(), // أو أي شاشة هدف تريدها
          // pushToRoute: true, // الافتراضي
        ),
      ),


      GoRoute(
          path: articleCommentsScreen,
          builder: (BuildContext context, GoRouterState state) {
            final String? articleId = state.uri.queryParameters['articleId'];
            return _routeHandler(context, ArticleComments(articleId: articleId!));
          }),
      GoRoute(path: rateScreen, builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const NotFound())),
      GoRoute(path: removeAccountScreen, builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const DeleteAccountPage())),
      GoRoute(path: bookmarkScreen, builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const BookmarkScreen())),
      GoRoute(
          path: editProfileScreen,
          builder: (BuildContext context, GoRouterState state) {
            final Map<String, dynamic> model = jsonDecode('${state.uri.queryParameters['user']}') as Map<String, dynamic>;
            final UserModel user = UserModel.fromJson(model);
            return _routeHandler(context, EditProfileScreen(user: user));
          }),
      GoRoute(
          path: editInquiriesScreen,
          builder: (BuildContext context, GoRouterState state) {
            final Map<String, dynamic> model = jsonDecode('${state.uri.queryParameters['user']}') as Map<String, dynamic>;
            final UserModel user = UserModel.fromJson(model);
            return _routeHandler(context, InquiriesScreen(user: user));
          }),
      GoRoute(
          path: daysScreen,
          builder: (BuildContext context, GoRouterState state) {
            // final Map<String, dynamic> model = jsonDecode('${state.uri.queryParameters['weather']}') as Map<String, dynamic>;
            // final WeatherModel weather = WeatherModel.fromJson(model);
            final int index = int.parse(state.uri.queryParameters['index'].toString());
            return _routeHandler(context, DailyForecastScreen(index: index));
          }),
      GoRoute(path: citiesScreen, builder: (BuildContext context, GoRouterState state) {
        final String? isFirstTimeStr = state.uri.queryParameters['isFirstTime'];
        final bool isFirstTime = isFirstTimeStr?.toLowerCase() == 'true';
        return _routeHandler(context, SavedCitiesScreen(isFirstTime: isFirstTime));
      }),
      // GoRoute(path: addCityScreen, builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const CitySearchScreen())),
      GoRoute(path: supportScreen, builder: (BuildContext context, GoRouterState state) => const ContactUsScreen()),
      GoRoute(path: termsScreen, builder: (BuildContext context, GoRouterState state) => const HtmlViewerScreen(htmlType: HtmlType.termsAndCondition)),
      GoRoute(path: policyScreen, builder: (BuildContext context, GoRouterState state) => const HtmlViewerScreen(htmlType: HtmlType.privacyPolicy)),
      GoRoute(path: aboutUsScreen, builder: (BuildContext context, GoRouterState state) => const HtmlViewerScreen(htmlType: HtmlType.aboutUs)),
      GoRoute(path: refundPolicyScreen, builder: (BuildContext context, GoRouterState state) => const HtmlViewerScreen(htmlType: HtmlType.refundPolicy)),
      GoRoute(
          path: cancellationPolicyScreen,
          builder: (BuildContext context, GoRouterState state) => const HtmlViewerScreen(htmlType: HtmlType.cancellationPolicy)),
      GoRoute(
          path: returnPolicyScreen,
          builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const HtmlViewerScreen(htmlType: HtmlType.returnPolicy))),
      GoRoute(
          path: selectLocationScreen,
          builder: (BuildContext context, GoRouterState state) => _routeHandler(context, const NoCityScreen())),
    ],
  );
}
