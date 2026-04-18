import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/cubits/base_cubit.dart';
import '../../../../../core/states/base_state.dart';
import '../../../../core/core.dart';
import '../../../../data/model/base/api_response.dart';
import '../../data/models/notification_model.dart';
import '../../domain/repositories/i_notifications_repository.dart';

part 'notifications_state.dart';

class NotificationsCubit extends BaseCubit<NotificationsState> {
  NotificationsCubit(this.notificationRepo) : super(const NotificationsState()) {
    getNotificationsList(type: NotificationType.weather);
    getNotificationsList(type: NotificationType.custom);

    // ✅ لا تشغله تلقائيًا هون إذا بدك، خلّيه يشتغل من ProfileCubit بعد تحميل user
    // initFcmTokenSafelyAndSendToBackend();
  }

  final INotificationsRepository notificationRepo;
  static const String _seenNotificationsKey = 'seen_notifications';

  final StreamController<void> _updateController =
  StreamController<void>.broadcast();
  Stream<void> get onNotificationsUpdate => _updateController.stream;

  // اشتراك لتحديث التوكن عشان نقدر نلغيه في close
  StreamSubscription<String>? _tokenRefreshSub;

  // ✅ Guards
  bool _fcmInitDone = false;
  String? _lastSyncedProductId;

  // ✅ Topics mapping (عدّل أسماء التوبيكس إذا عندك أسماء مختلفة)
  static const String _topicAll = 'all';
  static const String _topicVipSilver = 'vip_silver';
  static const String _topicVipGold = 'vip_gold';
  static const String _topicVipPremium = 'vip_premium';

  static const List<String> _vipTopics = <String>[
    _topicVipSilver,
    _topicVipGold,
    _topicVipPremium,
  ];

  @override
  Future<void> close() {
    _updateController.close();
    _tokenRefreshSub?.cancel();
    return super.close();
  }

  void _notifyUpdate() {
    _updateController.add(null);
  }

  Future<void> resetFilters() async {
    emit(state.copyWith(isLoading: true));
    await getNotificationsList(type: NotificationType.weather);
    await getNotificationsList(type: NotificationType.custom);
  }

  final List<NotificationModel> _weatherNotifications = <NotificationModel>[];
  final List<NotificationModel> _customNotifications = <NotificationModel>[];

  Future<void> getNotificationsList({
    int page = 1,
    required NotificationType type,
    String? countryCode,
  }) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'page': page,
      'type': type.name,
    };

    emit(state.copyWith(isLoading: true));

    final ApiResponse apiResponse =
    await notificationRepo.getNotificationsApi(params);

    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      final Map<String, dynamic> data =
      apiResponse.response!.data['body'] as Map<String, dynamic>;
      final NotificationsModelBody notificationsData =
      NotificationsModelBody.fromJson(data);

      if (notificationsData.notifications != null) {
        final List<NotificationModel> targetList = type == NotificationType.weather
            ? _weatherNotifications
            : _customNotifications;

        if (page == 1) {
          targetList
            ..clear()
            ..addAll(notificationsData.notifications!);
        } else {
          final List<NotificationModel> newNotifications =
          notificationsData.notifications!;
          for (final NotificationModel notification in newNotifications) {
            if (!targetList.any((NotificationModel p) => p.id == notification.id)) {
              targetList.add(notification);
            } else {
              final int index =
              targetList.indexWhere((NotificationModel p) => p.id == notification.id);
              if (index != -1) {
                targetList[index] = notification;
              }
            }
          }
        }

        emit(
          state.copyWith(
            isLoading: false,
            weatherNotifications: type == NotificationType.weather
                ? List<NotificationModel>.from(_weatherNotifications)
                : null,
            customNotifications: type == NotificationType.custom
                ? List<NotificationModel>.from(_customNotifications)
                : null,
            pageSize: notificationsData.meta?.perPage ?? 10,
            totalRows: notificationsData.meta?.total ?? 0,
            currentPage: notificationsData.meta?.currentPage ?? 1,
          ),
        );

        _notifyUpdate();
      } else {
        emit(state.copyWith(isLoading: false));
      }
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> markNotificationAsSeen(String notificationId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> seenNotifications =
          prefs.getStringList(_seenNotificationsKey) ?? <String>[];

      if (!seenNotifications.contains(notificationId)) {
        seenNotifications.add(notificationId);
        await prefs.setStringList(_seenNotificationsKey, seenNotifications);

        final List<NotificationModel> updatedWeatherNotifications =
        _weatherNotifications.map((NotificationModel notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(seen: true);
          }
          return notification;
        }).toList();

        final List<NotificationModel> updatedCustomNotifications =
        _customNotifications.map((NotificationModel notification) {
          if (notification.id == notificationId) {
            return notification.copyWith(seen: true);
          }
          return notification;
        }).toList();

        emit(state.copyWith(
          weatherNotifications: updatedWeatherNotifications,
          customNotifications: updatedCustomNotifications,
        ));

        _notifyUpdate();
      }
    } catch (e) {
      print('Error marking notification as seen: $e');
    }
  }

  Future<bool> isNotificationSeen(String notificationId) async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> seenNotifications =
          prefs.getStringList(_seenNotificationsKey) ?? <String>[];
      return seenNotifications.contains(notificationId);
    } catch (e) {
      print('Error checking if notification is seen: $e');
      return false;
    }
  }

  Future<bool> hasUnreadNotifications() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final List<String> seenNotifications =
          prefs.getStringList(_seenNotificationsKey) ?? <String>[];

      for (final NotificationModel notification in _weatherNotifications) {
        if (notification.id != null &&
            !seenNotifications.contains(notification.id)) {
          return true;
        }
      }

      for (final NotificationModel notification in _customNotifications) {
        if (notification.id != null &&
            !seenNotifications.contains(notification.id)) {
          return true;
        }
      }

      return false;
    } catch (e) {
      print('Error checking unread notifications: $e');
      return false;
    }
  }

  // ===========================
  //   TOPICS SYNC (PRODUCT ID)
  // ===========================

  /// ✅ يحدد نوع الاشتراك من productId ويشترك/يلغي الاشتراك حسب الباك اند
  /// product ids:
  /// - whats-annual       => Silver
  /// - annual_package     => Gold
  /// - annual_package_2   => Premium
  Future<void> syncTopicsWithBackendProductId(String? productId) async {
    // منع تكرار نفس العملية
    if (_lastSyncedProductId == productId) return;
    _lastSyncedProductId = productId;

    final String? vipTopic = _mapProductIdToTopic(productId);

    try {
      // ✅ all: خليه دائمًا مشترك
      await subscribeTopic(_topicAll);

      // ✅ إذا ما في اشتراك: الغِ كل vip topics
      if (vipTopic == null) {
        for (final String t in _vipTopics) {
          await unsubscribeTopic(t);
        }
        printLog('No subscription productId => unsubscribed from all VIP topics');
        return;
      }

      // ✅ اشترك بالباقة المطلوبة + الغي الباقي
      for (final String t in _vipTopics) {
        if (t == vipTopic) {
          await subscribeTopic(t);
        } else {
          await unsubscribeTopic(t);
        }
      }

      printLog('Synced VIP topic => $vipTopic for productId=$productId');
    } catch (e) {
      printLog('syncTopicsWithBackendProductId error: $e');
    }
  }

  String? _mapProductIdToTopic(String? productId) {
    if (productId == null || productId.trim().isEmpty) return null;

    switch (productId.trim()) {
      case 'whats-annual':
        return _topicVipSilver;
      case 'annual_package':
        return _topicVipGold;
      case 'annual_package_2':
        return _topicVipPremium;
      default:
      // إذا بدك: ترجع null أو تعمل fallback:
      // return _topicVipSilver;
        return null;
    }
  }

  // ===========================
  //      SUB / UNSUB TOPICS
  // ===========================

  Future<void> subscribeTopic(String topic) async {
    try {
      // ✅ iOS: لازم APNS token يكون موجود قبل subscribeToTopic
      if (Platform.isIOS) {
        final bool ok = await _ensureApnsTokenReady();
        if (!ok) {
          printLog('APNS not ready, skip subscribe topic: $topic');
          return;
        }
      }

      final bool success = await notificationRepo.subscribeTopic(topic);
      if (success) {
        printLog('Successfully subscribed to topic: $topic');
      } else {
        printLog('Failed to subscribe to topic: $topic');
      }
    } catch (e) {
      printLog('Error subscribing to topic: $e');
    }
  }

  Future<void> unsubscribeTopic(String topic) async {
    try {
      if (Platform.isIOS) {
        final bool ok = await _ensureApnsTokenReady();
        if (!ok) {
          printLog('APNS not ready, skip unsubscribe topic: $topic');
          return;
        }
      }

      final bool success = await notificationRepo.unsubscribeTopic(topic);
      if (success) {
        printLog('Successfully unsubscribed from topic: $topic');
      } else {
        printLog('Failed to unsubscribe from topic: $topic');
      }
    } catch (e) {
      printLog('Error unsubscribing from topic: $e');
    }
  }

  Future<void> developerTopic() async {
    try {
      if (Platform.isIOS) {
        final bool ok = await _ensureApnsTokenReady();
        if (!ok) {
          printLog('APNS not ready, skip developerTopic');
          return;
        }
      }

      final bool success = await notificationRepo.developerTopic();
      if (success) {
        printLog('Successfully subscribed to developer topic');
      } else {
        printLog('Failed to subscribe to developer topic');
      }
    } catch (e) {
      printLog('Error subscribing to developer topic: $e');
    }
  }

  // ===========================
  //  FCM TOKEN (SAFE FOR iOS)
  // ===========================

  /// ✅ إرسال التوكن للباك اند بدون ما نخرب القديم
  /// - AuthRepo ما زال يرسل token عند login
  /// - هذا مجرد تأكيد/تثبيت خاصة بعد تحميل user أو على app start
  Future<void> initFcmTokenSafelyAndSendToBackend() async {
    if (_fcmInitDone) return;
    _fcmInitDone = true;

    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;

      // permissions
      await messaging.requestPermission();

      // iOS: لازم APNS جاهز قبل بعض عمليات FCM (خصوصًا topics)
      if (Platform.isIOS) {
        await _ensureApnsTokenReady();
      }

      final String? token = await messaging.getToken();
      if (token == null) {
        printLog('FCM token is null');
        return;
      }

      final String platform = Platform.isAndroid
          ? 'android'
          : Platform.isIOS
          ? 'ios'
          : 'web';

      final String? deviceId = await _getDeviceId();
      final String? appVersion = await _getAppVersion();

      await notificationRepo.sendFcmToken(
        token: token,
        platform: platform,
        deviceId: deviceId,
        appVersion: appVersion,
      );

      // refresh listener (مرة واحدة)
      _tokenRefreshSub?.cancel();
      _tokenRefreshSub = FirebaseMessaging.instance.onTokenRefresh.listen(
            (String newToken) async {
          await notificationRepo.sendFcmToken(
            token: newToken,
            platform: platform,
            deviceId: deviceId,
            appVersion: appVersion,
          );
        },
      );

      printLog('FCM token initialized and sent (safe)');
    } catch (e) {
      printLog('Error initializing FCM token (safe): $e');
    }
  }

  /// ✅ يحاول يضمن إن APNS token جاهز على iOS (لتفادي apns-token-not-set)
  Future<bool> _ensureApnsTokenReady() async {
    try {
      final FirebaseMessaging messaging = FirebaseMessaging.instance;

      // جرّب مباشرة
      String? apns = await messaging.getAPNSToken();
      if (apns != null) return true;

      // انتظر شوي وحاول كم مرة (بدون مبالغة)
      for (int i = 0; i < 6; i++) {
        await Future<void>.delayed(const Duration(milliseconds: 500));
        apns = await messaging.getAPNSToken();
        if (apns != null) return true;
      }

      return false;
    } catch (e) {
      printLog('APNS token check failed: $e');
      return false;
    }
  }

  Future<String?> _getDeviceId() async {
    try {
      final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

      if (Platform.isAndroid) {
        final AndroidDeviceInfo info = await deviceInfo.androidInfo;
        return info.id;
      } else if (Platform.isIOS) {
        final IosDeviceInfo info = await deviceInfo.iosInfo;
        return info.identifierForVendor;
      }
    } catch (e) {
      printLog('Error getting device id: $e');
    }
    return null;
  }

  Future<String?> _getAppVersion() async {
    try {
      final PackageInfo info = await PackageInfo.fromPlatform();
      return info.version;
    } catch (e) {
      printLog('Error getting app version: $e');
      return null;
    }
  }
}
