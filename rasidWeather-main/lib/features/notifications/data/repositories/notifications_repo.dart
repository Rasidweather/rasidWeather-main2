import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../../../bloc/subscription_cuibt/subscription_plan.dart';
import '../../../../core/core.dart';
import '../../../../data/model/base/api_response.dart';
import '../../domain/repositories/i_notifications_repository.dart';
import '../models/notification_model.dart';
import '../services/topic_service.dart';

class NotificationsRepo implements INotificationsRepository {
  NotificationsRepo(this.dio, this.firebaseMessaging);

  final DioClient dio;
  final FirebaseMessaging firebaseMessaging;
  final TopicService _topicService = TopicService();
  Future<void> syncPlanTopics(String? productId) async {
    final SubscriptionPlan plan = planFromProductId(productId);
    await _topicService.syncTopicsFromPlan(plan);
  }

  @override
  Future<ApiResponse> getNotificationsApi(Map<String, dynamic> params) async {
    final Response<dynamic> response = await dio.get(
      AppStrings.getNotificationsEndpoint,
      queryParameters: params,
    );
    return ApiResponse.withSuccess(response);
  }

  @override
  Future<bool> subscribeTopic(String topic) async {
    try {
      await firebaseMessaging.subscribeToTopic(topic);
      printLog('topic subscribed $topic');
      return true;
    } catch (e, stack) {
      printLog('Error subscribing to topic $topic: $e');
      debugPrintStack(stackTrace: stack);
      return false;
    }
  }

  @override
  Future<bool> unsubscribeTopic(String topic) async {
    try {
      await firebaseMessaging.unsubscribeFromTopic(topic);
      printLog('topic unsubscribed $topic');
      return true;
    } catch (e, stack) {
      printLog('Error unsubscribing from topic $topic: $e');
      debugPrintStack(stackTrace: stack);
      return false;
    }
  }

  @override
  Future<bool> developerTopic({String topic = 'Debug'}) async {
    printLog('developerTopic');
    try {
      if (kDebugMode) {
        await firebaseMessaging.subscribeToTopic(topic);
        printLog('developer topic subscribed ($topic)');
      } else {
        await firebaseMessaging.unsubscribeFromTopic(topic);
        printLog('developer topic unsubscribed ($topic)');
      }
      return true;
    } catch (e, stack) {
      printLog('Error in developerTopic ($topic): $e');
      debugPrintStack(stackTrace: stack);
      return false;
    }
  }

  // ===========================
  //       FCM TOKEN API
  // ===========================
  @override
  Future<bool> sendFcmToken({
    required String token,
    required String platform, // android | ios | web
    String? deviceId,
    String? appVersion,
  })
  async {
    try {
      final Response<dynamic> response = await dio.post(
        // يطابق Route::post('/fcm/token', ...)
        '/fcm/token',
        data: <String, dynamic>{
          'token': token,
          'platform': platform,
          if (deviceId != null) 'device_id': deviceId,
          if (appVersion != null) 'app_version': appVersion,
        },
      );

      final bool ok = response.statusCode == 200;
      if (ok) {
        printLog('FCM token sent successfully');
      } else {
        printLog('Failed to send FCM token, status: ${response.statusCode}');
      }
      return ok;
    } catch (e, stack) {
      printLog('Error sending FCM token: $e');
      debugPrintStack(stackTrace: stack);
      return false;
    }
  }

  @override
  Future<void> create(NotificationModel item) {
    // TODO: implement create
    throw UnimplementedError();
  }

  @override
  Future<void> delete(String id) {
    // TODO: implement delete
    throw UnimplementedError();
  }

  @override
  Future<List<NotificationModel>> getAll() {
    // TODO: implement getAll
    throw UnimplementedError();
  }

  @override
  Future<NotificationModel?> getById(String id) {
    // TODO: implement getById
    throw UnimplementedError();
  }

  @override
  Future<void> update(NotificationModel item) {
    // TODO: implement update
    throw UnimplementedError();
  }
}
