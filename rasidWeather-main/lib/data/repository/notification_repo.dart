// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/foundation.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:rasid_weather/data/model/base/payload_model.dart';
// import 'package:rasid_weather/utils/ui_utils.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// import '../../core/network/dio_helper.dart';
// import '../../helper/notification_sql.dart';
//
// class NotificationRepo {
//
//   NotificationRepo({
//     required this.databaseHelper,
//     required this.firebaseMessaging,
//     required this.sharedPreferences,
//     required this.dioClient,
//   });
//   final DioClient dioClient;
//   final SharedPreferences sharedPreferences;
//   final FirebaseMessaging firebaseMessaging;
//   final DatabaseHelper databaseHelper;
//
//   // Future<ApiResponse> getNotificationList(String params) async {
//   //   try {
//   //     final response = await dioClient.get(AppStrings.notificationUrl + params);
//   //     return ApiResponse.withSuccess(response);
//   //   } on DioException catch (e) {
//   //     return ApiResponse.withError(ApiErrorHandler.getMessage(e)!);
//   //   }
//   // }
//
//   Future<bool> setNotificationAsRead(String notificationId) async {
//     return sharedPreferences.setBool(notificationId, true);
//   }
//
//   Future<bool> getNotificationStatus(String notificationId) async {
//     bool isSeen = sharedPreferences.getBool(notificationId) ?? false;
//     return isSeen;
//   }
//
//   Future<bool> subscribeTopic(String topic) async {
//     return firebaseMessaging.subscribeToTopic(topic).onError((Object? error, StackTrace stackTrace) => false).then((value) {
//       printLog('topic subscribed $topic');
//       return true;
//     });
//   }
//
//   Future<bool> unsubscribeTopic(String topic) async {
//     return firebaseMessaging.unsubscribeFromTopic(topic).onError((Object? error, StackTrace stackTrace) => false).then((value) {
//       printLog('topic unsubscribed');
//       return true;
//     });
//   }
//
//   Future<bool> developerTopic({String topic = 'Debug'}) async {
//     printLog('developerTopic');
//
//     if (kDebugMode) {
//     return firebaseMessaging.subscribeToTopic(topic).onError((Object? error, StackTrace stackTrace) => false).then((value) {
//       printLog('developer topic subscribed');
//       return true;
//     });
//     } else {
//       return firebaseMessaging
//           .unsubscribeFromTopic(topic)
//           .onError((Object? error, StackTrace stackTrace) => false)
//           .then((value) {
//         printLog('developer topic unsubscribed');
//         return true;
//       });
//     }
//   }
//
//   Future<void> setAllowNotifications(bool value) async {
//     await sharedPreferences.setBool('allowNotifications', value);
//   }
//
//   bool getNotificationAllowed() {
//     return sharedPreferences.getBool('allowNotifications') ?? false;
//   }
//
//   Future<PermissionStatus> permissionStatus() async {
//     return Permission.notification.status;
//   }
//
//   Future<NotificationSettings> requestPermission() async {
//     return firebaseMessaging.requestPermission();
//   }
//
//   // need to save topics in shared pref and get it from there
//   Future<void> getSubscribedTopics() async {
//     try {
//       sharedPreferences.getStringList('topics') ?? <String>[];
//     } catch (e) {
//       rethrow;
//     }
//   }
//
//   Future<List<PayloadModel>> getSavedNotifications() async {
//     try {
//       // final locationsDecoded = sharedPreferences.get(AppKeys.notifications);
//       final List<PayloadModel> locationsDecoded = await databaseHelper.getNotifications();
//       // final List<PayloadModel> locations = PayloadModel.decode(locationsDecoded);
//       return locationsDecoded;
//     } catch (e) {
//       return <PayloadModel>[];
//     }
//   }
//
//   // Future<void> _saveListNotifications(List<PayloadModel> locations) async {
//   //   // final String locationsEncoded = PayloadModel.encode(locations);
//   //   // sharedPreferences.setString(AppKeys.notifications, locationsEncoded);
//   //   for (var element in locations) {
//   //     await databaseHelper.insert(element);
//   //   }
//   // }
//
//   // Future<void> removeNotification(String notification) async {
//   //   final notificationsDecoded = sharedPreferences.get(AppKeys.notifications);
//   //   final List<PayloadModel> notifications = PayloadModel.decode(notificationsDecoded);
//   //   for (var element in notifications) {
//   //     if (element.id.toString() == notification) {
//   //       notifications.remove(element);
//   //     }
//   //   }
//   //   _saveListNotifications(notifications);
//   // }
//
//   // Future<void> saveNewNotification(PayloadModel payload) async {
//   //   // final notificationsDecoded = sharedPreferences.get(AppKeys.notifications)?? '[]';
//   //   // final List<PayloadModel> notifications = PayloadModel.decode(notificationsDecoded);
//   //   // notifications.add(payload);
//   //   // _saveListNotifications(notifications);
//   //   await databaseHelper.insert(payload);
//   // }
//
//   Future<void> seenNotification(PayloadModel payload) async {
//     await databaseHelper.updateNotification(payload.copyWith(seen: true));
//
//     // final locationsDecoded = sharedPreferences.get(AppKeys.notifications);
//     // sharedPreferences.getStringList(AppKeys.notifications);
//     //
//     // final List<PayloadModel> notifications = PayloadModel.decode(locationsDecoded);
//     // for (var element in notifications) {
//     //   if (element.id == payload.id) {
//     //     notifications.remove(element);
//     //     notifications.add(element.copyWith(seen: true));
//     //     _saveListNotifications(notifications);
//     //   }
//     // }
//   }
// }
