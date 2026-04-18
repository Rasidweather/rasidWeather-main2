import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:path_provider/path_provider.dart';

import '../core/services/dialog_service.dart';
import '../data/model/base/payload_model.dart';
import '../locator.dart';
import '../main.dart';
import 'router_helper.dart';

class MyNotification {
  static const String channelIdWeather = 'weather_notifications';
  static const String channelIdContent = 'content_notifications';
  static const String channelGroupKey = 'com.rasid.weather.NOTIFICATIONS';
  
  /// Handle FCM background messages
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    // Need to initialize Firebase before handling background messages
    await Firebase.initializeApp();
    
    if (kDebugMode) {
      print('Handling a background message: ${message.messageId}');
      print('Message data: ${message.data}');
      print('Message notification: ${message.notification?.title}');
    }
    
    // Process the notification
    await showNotification(
      message,
      flutterLocalNotificationsPlugin,
      message.data.isNotEmpty,
    );
  }
  
  /// Initialize Firebase Messaging
  static Future<void> initializeFirebaseMessaging() async {
    // Set the background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    
    // Request Firebase Messaging permissions with full options
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      criticalAlert: true,
    );
    
    // Get FCM token for debugging
    if (kDebugMode) {
      final String? token = await FirebaseMessaging.instance.getToken();
      print('FCM Token: $token');
    }
  }

  /// Initialize all notification systems
  static Future<void> initialize(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    // Initialize Firebase Messaging first
    await initializeFirebaseMessaging();
    final List<DarwinNotificationCategory> darwinNotificationCategories =
        <DarwinNotificationCategory>[
          DarwinNotificationCategory(
            'weather',
            actions: <DarwinNotificationAction>[
              DarwinNotificationAction.plain('view', 'View'),
              DarwinNotificationAction.plain('dismiss', 'Dismiss'),
            ],
          ),
          DarwinNotificationCategory(
            'content',
            actions: <DarwinNotificationAction>[
              DarwinNotificationAction.plain('view', 'View'),
              DarwinNotificationAction.plain('dismiss', 'Dismiss'),
            ],
          ),
        ];

    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
          notificationCategories: darwinNotificationCategories,
        );

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('notification_icon');

    final InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsDarwin,
        );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (
        NotificationResponse notificationResponse,
      ) async {
        final String? payload = notificationResponse.payload;
        if (payload == null) {
          return;
        }

        try {
          final PayloadModel notificationPayload = PayloadModel.fromJson(
            jsonDecode(payload) as Map<String, dynamic>,
          );

          if (notificationResponse.actionId == 'dismiss') {
            // Handle dismiss action if needed
          } else {
            await _notificationDirection(notificationPayload);
          }
        } catch (e) {
          print('Error processing notification response: $e');
        }
      },
      onDidReceiveBackgroundNotificationResponse: myBackgroundMessageHandler,
    );

    await _setupNotificationChannels(flutterLocalNotificationsPlugin);

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Received foreground message: ${message.messageId}');
      showNotification(
        message,
        flutterLocalNotificationsPlugin,
        message.data.isNotEmpty,
      );
    });

    // Handle notifications opened from terminated state
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print('Notification opened from background state: ${message.messageId}');
      try {
        final PayloadModel payload = PayloadModel.fromJson(message.data);
        await _notificationDirection(payload);
      } catch (e) {
        print('Error handling opened notification: $e');
      }
    });

    // Check for initial notification when app was terminated
    await getNotificationTerminate();
    
    // Request permission for iOS
    if (Platform.isIOS) {
      await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  static Future<void> _setupNotificationChannels(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
  ) async {
    // Create the weather notification channel
    const AndroidNotificationChannel weatherChannel =
        AndroidNotificationChannel(
          channelIdWeather,
          'Weather Notifications',
          description: 'Notifications about weather updates and alerts',
          importance: Importance.high,
          enableLights: true,
          groupId: channelGroupKey,
        );

    // Create the content notification channel
    const AndroidNotificationChannel contentChannel =
        AndroidNotificationChannel(
          channelIdContent,
          'Content Notifications',
          description: 'Notifications about news and content updates',
          groupId: channelGroupKey,
        );

    // Create the notification channel group
    const AndroidNotificationChannelGroup channelGroup =
        AndroidNotificationChannelGroup(
          channelGroupKey,
          'Rasid Weather Notifications',
          description: 'All notifications from Rasid Weather',
        );

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannelGroup(channelGroup);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(weatherChannel);

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(contentChannel);
  }

  static Future<void> getNotificationTerminate() async {
    try {
      final RemoteMessage? initialMessage =
          await FirebaseMessaging.instance.getInitialMessage();
      if (initialMessage != null) {
        debugPrint('App opened from terminated state with notification: ${initialMessage.messageId}');
        final PayloadModel payload = PayloadModel.fromJson(initialMessage.data);
        await _notificationDirection(payload);
      }
    } catch (e) {
      debugPrint('Error handling initial notification: $e');
    }
  }

  static Future<void> showNotification(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin fln,
    bool data,
  ) async {
    try {
      if (data) {
        final String channelId = message.data['type'] == 'weather'
            ? channelIdWeather
            : channelIdContent;
        const String groupKey = channelGroupKey;

        debugPrint('Showing notification with data: ${message.data}');

        if (message.data['image'] != null && message.data['image'] != '') {
          await showBigPictureNotificationHiddenLargeIcon(
            message,
            fln,
            channelId,
            groupKey,
          );
        } else {
          await showBigTextNotification(
            message,
            fln,
            channelId,
            groupKey,
          );
        }
      } else if (message.notification != null) {
        // Handle FCM notification payload (not data payload)
        debugPrint('Showing notification with notification payload: ${message.notification?.title}');
        
        final String channelId = message.notification?.android?.channelId ?? channelIdContent;
        
        final AndroidNotificationDetails androidPlatformChannelSpecifics =
            AndroidNotificationDetails(
              channelId,
              'Notifications',
              channelDescription: 'App notifications',
              importance: Importance.max,
              priority: Priority.high,
              groupKey: channelGroupKey,
              setAsGroupSummary: true,
            );

        const DarwinNotificationDetails iOSPlatformChannelSpecifics =
            DarwinNotificationDetails(
              presentAlert: true,
              presentBadge: true,
              presentSound: true,
              sound: 'notification.aiff',
              threadIdentifier: channelGroupKey,
            );

        final NotificationDetails platformChannelSpecifics = NotificationDetails(
          android: androidPlatformChannelSpecifics,
          iOS: iOSPlatformChannelSpecifics,
        );

        await fln.show(
          message.hashCode,
          message.notification?.title ?? 'Notification',
          message.notification?.body ?? '',
          platformChannelSpecifics,
          payload: jsonEncode(<String, String?>{
            'title': message.notification?.title,
            'content': message.notification?.body,
            'type': 'content',
          }),
        );
      }
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  static Future<void> showBigTextNotification(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin fln,
    String channelId,
    String groupKey,
  ) async {
    final BigTextStyleInformation bigTextStyleInformation =
        BigTextStyleInformation(
          message.data['content'].toString(),
          htmlFormatBigText: true,
          contentTitle: message.data['title'].toString(),
          htmlFormatContentTitle: true,
          summaryText: message.data['type'] == 'weather' ? '' : 'Alert',
          htmlFormatSummaryText: true,
        );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          channelId,
          message.data['type'] == 'weather'
              ? 'Weather Notifications'
              : 'Content Notifications',
          channelDescription:
              message.data['type'] == 'weather'
                  ? 'Notifications about weather updates and alerts'
                  : 'Notifications about news and content updates',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigTextStyleInformation,
          groupKey: groupKey,
          setAsGroupSummary: true,
          category: AndroidNotificationCategory.alarm,
          fullScreenIntent: message.data['type'] == 'weather',
          actions: <AndroidNotificationAction>[
            const AndroidNotificationAction('view', 'View'),
            const AndroidNotificationAction('dismiss', 'Dismiss'),
          ],
        );

    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'notification.aiff',
          threadIdentifier: groupKey,
          categoryIdentifier: message.data['type'].toString(),
          interruptionLevel: InterruptionLevel.timeSensitive,
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await fln.show(
      message.hashCode,
      message.data['title'].toString(),
      message.data['content'].toString(),
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  static Future<void> showBigPictureNotificationHiddenLargeIcon(
    RemoteMessage message,
    FlutterLocalNotificationsPlugin fln,
    String channelId,
    String groupKey,
  ) async {
    final String bigPicturePath = await _downloadAndSaveFile(
      message.data['image'].toString(),
      'notification_image.jpg',
    );
    final String largeIconPath = await _downloadAndSaveFile(
      message.data['image'].toString(),
      'notification_icon.jpg',
    );

    final BigPictureStyleInformation bigPictureStyleInformation =
        BigPictureStyleInformation(
          FilePathAndroidBitmap(bigPicturePath),
          hideExpandedLargeIcon: true,
          contentTitle: message.data['title'].toString(),
          htmlFormatContentTitle: true,
          summaryText: message.data['content'].toString(),
          htmlFormatSummaryText: true,
          largeIcon: FilePathAndroidBitmap(largeIconPath),
        );

    final AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          channelId,
          message.data['type'] == 'weather'
              ? 'Weather Notifications'
              : 'Content Notifications',
          channelDescription:
              message.data['type'] == 'weather'
                  ? 'Notifications about weather updates and alerts'
                  : 'Notifications about news and content updates',
          importance: Importance.max,
          priority: Priority.high,
          styleInformation: bigPictureStyleInformation,
          groupKey: groupKey,
          setAsGroupSummary: true,
          category: AndroidNotificationCategory.alarm,
          fullScreenIntent: message.data['type'] == 'weather',
          actions: <AndroidNotificationAction>[
            const AndroidNotificationAction('view', 'View'),
            const AndroidNotificationAction('dismiss', 'Dismiss'),
          ],
        );

    final DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          sound: 'notification.aiff',
          threadIdentifier: groupKey,
          categoryIdentifier: message.data['type'].toString(),
          interruptionLevel: InterruptionLevel.timeSensitive,
          attachments: <DarwinNotificationAttachment>[
            DarwinNotificationAttachment(bigPicturePath),
          ],
        );

    final NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await fln.show(
      message.hashCode,
      message.data['title'].toString(),
      message.data['content'].toString(),
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  static Future<String> _downloadAndSaveFile(
    String url,
    String fileName,
  ) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String filePath = '${directory.path}/$fileName';
    final File file = File(filePath);

    if (await file.exists()) {
      return filePath;
    }

    try {
      final Response<dynamic> response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      await file.writeAsBytes(response.data as List<int>);
      return filePath;
    } catch (e) {
      debugPrint('Error downloading file: $e');
      rethrow;
    }
  }

  static Future<void> onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    if (payload == null) {
      return;
    }

    final PayloadModel notificationPayload = PayloadModel.fromJson(
      jsonDecode(payload) as Map<String, dynamic>,
    );
    await _notificationDirection(notificationPayload);
  }

  static Future<void> _notificationDirection(PayloadModel payload) async {
    if (payload.type == 'weather') {
      RouterHelper.getArticleDetailsRoute(payload.reviewableId!);
    } else {
      final DialogService dialogService = sl<DialogService>();
      await dialogService.showDialog(
        title: payload.title ?? '',
        description: payload.content ?? '',
      );
    }
  }

  @pragma('vm:entry-point')
  static Future<void> myBackgroundMessageHandler(
    NotificationResponse details,
  ) async {
    try {
      if (details.payload != null) {
        await showNotification(
          jsonDecode('${details.payload}') as RemoteMessage,
          flutterLocalNotificationsPlugin,
          true,
        );
      }
    } catch (e) {
      debugPrint('Error in background message handler: $e');
    }
    return;
  }
}
