import 'package:shared_preferences/shared_preferences.dart';

class AppStrings {
  static const String appName = 'Rasid Weather';
  static const String appVersion = '1.0.0';
  static const String serverToken = '7fG2TnI9lR6dE5kO3jW8qZ4xY1vB0cXp';
  static const String baseUrl = 'https://rasidweather.com/api';
  static const String iOSAppId = '1522203608';
  static const String androidPackageName = 'com.rassid.rassid';
  static const String kGoogleApiKey = 'Api_key';
  static const String whatsappPhoneE164 = '+972593420406';

  static const String _kVip = 'isVip';
  static const String _kVipChat = 'isVipChat';
  static const String _kRemoveAds = 'removeAds';
  static const String _kShowAnimation = 'showAnimation';
  static const String _kChatWhatsApp = 'chatWhatsApp';
  static const String _kChatEmail = 'chatEmail';
  static const String _kPlanName = 'planName';

  static late SharedPreferences _prefs;
  static bool _initialized = false;

  static bool isVip = false;
  static bool isVipChat = false;

  static bool removeAds = false;
  static bool showAnimation = false;
  static bool chatWhatsApp = false;
  static bool chatEmail = false;
  static String planName = 'unknown';

  static Future<void> init() async {
    if (_initialized) return;
    _prefs = await SharedPreferences.getInstance();

    isVip         = _prefs.getBool(_kVip) ?? false;
    isVipChat     = _prefs.getBool(_kVipChat) ?? false;

    removeAds     = _prefs.getBool(_kRemoveAds) ?? false;
    showAnimation = _prefs.getBool(_kShowAnimation) ?? false;
    chatWhatsApp  = _prefs.getBool(_kChatWhatsApp) ?? false;
    chatEmail     = _prefs.getBool(_kChatEmail) ?? false;
    planName      = _prefs.getString(_kPlanName) ?? 'unknown';

    _initialized = true;
  }

  static void _ensureInit() {
    assert(_initialized, 'AppStrings.init() must be called before use.');
  }

  static bool get isGold {
    _ensureInit();
    return planName == 'gold';
  }

  static bool get isWhatsAppPlan {
    _ensureInit();
    return planName == 'whatsapp';
  }

  static bool get isBasicPlan {
    _ensureInit();
    return planName == 'basic';
  }

  static Future<void> setVip({
    required bool isVip,
    required bool isVipChat,
  }) async {
    _ensureInit();
    AppStrings.isVip = isVip;
    AppStrings.isVipChat = isVipChat;
    await _prefs.setBool(_kVip, isVip);
    await _prefs.setBool(_kVipChat, isVipChat);
  }

  static Future<void> setRemoveAds(bool value) async {
    _ensureInit();
    removeAds = value;
    await _prefs.setBool(_kRemoveAds, value);
  }

  static Future<void> setShowAnimation(bool value) async {
    _ensureInit();
    showAnimation = value;
    await _prefs.setBool(_kShowAnimation, value);
  }

  static Future<void> setChatWhatsApp(bool value) async {
    _ensureInit();
    chatWhatsApp = value;
    await _prefs.setBool(_kChatWhatsApp, value);
  }

  static Future<void> setChatEmail(bool value) async {
    _ensureInit();
    chatEmail = value;
    await _prefs.setBool(_kChatEmail, value);
  }

  static Future<void> setPlanName(String value) async {
    _ensureInit();
    planName = value;
    await _prefs.setString(_kPlanName, value);
  }

  static Future<void> setCapabilities({
    required bool removeAds,
    required bool showAnimation,
    required bool chatWhatsApp,
    required bool chatEmail,
    required String planName,
  }) async {
    _ensureInit();
    await setRemoveAds(removeAds);
    await setShowAnimation(showAnimation);
    await setChatWhatsApp(chatWhatsApp);
    await setChatEmail(chatEmail);
    await setPlanName(planName);

    final bool vip = removeAds || showAnimation || chatWhatsApp || chatEmail;
    await setVip(isVip: vip, isVipChat: chatWhatsApp);
  }

  static Future<void> clearVip() async {
    _ensureInit();
    isVip = false;
    isVipChat = false;

    removeAds = false;
    showAnimation = false;
    chatWhatsApp = false;
    chatEmail = false;
    planName = 'unknown';

    await _prefs.remove(_kVip);
    await _prefs.remove(_kVipChat);
    await _prefs.remove(_kRemoveAds);
    await _prefs.remove(_kShowAnimation);
    await _prefs.remove(_kChatWhatsApp);
    await _prefs.remove(_kChatEmail);
    await _prefs.remove(_kPlanName);
  }

  static const String loginWithPhoneUrl = '/login/phone/twilio/sendcode';
  static const String verifyOtpUrl = '/login/phone/twilio/verify';
  static const String loginWithGoogleUrl = '/login/social/google';
  static const String loginWithFacebookUrl = '/login/social/facebook';
  static const String loginWithAppleUrl = '/login/social/apple';

  static const String completeProfile = '/complate/profile';
  static const String profileUrl = '/user';
  static const String getProfileDetailsUrl = '/get/user';
  static const String changePassword = '/update/user/password';
  static const String updateProfile = '/update/user';

  static const String subscriptionPlansUrl = '/subscription/plans';
  static const String mySubscriptionUrl = '/subscription/info';
  static const String subscriptionHistoryUrl = '/subscription/history';

  static const String registerUrl = '/register';
  static const String loginWithEmailUrl = '/login';
  static const String forgetPassword = '/request-password-reset';
  static const String resetPassword = '/reset-password';
  static const String logoutUrl = '/logout';

  static const String articlesUrl = '/news';
  static const String articlesHomeUrl = '/news/home';
  static const String articleDetailsUrl = '/news/show/';

  static const String linkPhoneNumber = '/phone/twilio/sendcode';
  static const String verifyPhoneNumber = '/phone/twilio/verify';
  static const String linkGoogleAccount = '/linked/social/google';
  static const String linkFacebookAccount = '/linked/social/facebook';
  static const String linkAppleAccount = '/linked/social/apple';
  static const String disLinkSocialAccount = '/remove/linked/';
  static const String changeEmail = '/update/user/email';
  static const String saveFcmToken = '/set/firebase/fcm';
  static const String removeAccount = '/remove/user';

  static const String userProfileUrl = '/user/profile';
  static const String checkConfirmCode = '/check-otp';

  static const String confirmPassword = '/password/reset';
  static const String searchUserUrl = '/get/users/';

  static const String inquiriesUrl = '/tickets';
  static const String inquiryChatUrl = '/tickets/chat';
  static const String inquiryReplyUrl = '/tickets/reply/';

  static const String configUrl = '/settings/get/data';
  static const String notificationUrl = '/get/notifications';
  static const String notificationReadUrl = '/notifications/see/';
  static const String offersUrl = '/get/offers';
  static const String reportsUrl = '/report';
  static const String timezoneUrl = 'get/timezones';

  static const String categoriesUrl = '/news/categories';
  static const String bookmarkArticleUrl = '/set/favorite/article';
  static const String getBookmarksUrl = '/article/favorites';
  static const String searchArticleUrl = '/news/search?';
  static const String lovedArticleUrl = '/set/liked/article';
  static const String commentUrl = '/article/comments';

  static String geonamesUrl = 'https://secure.geonames.org';
  static String geonamesKey = 'mohamedmesalm';
  static String searchUrl(String query, String lang) =>
      '$geonamesUrl/searchJSON?q=$query&maxRows=10&username=$geonamesKey&lang=$lang';

  static const int animationDuration = 1500;
}
