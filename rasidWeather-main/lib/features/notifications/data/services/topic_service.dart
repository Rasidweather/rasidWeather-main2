import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

import '../../../../bloc/subscription_cuibt/subscription_plan.dart';

class TopicService {
  final FirebaseMessaging _fm = FirebaseMessaging.instance;

  Future<void> syncTopicsFromPlan(SubscriptionPlan plan) async {
    await _prepareMessaging();

    await _safeSubscribe('all');

    switch (plan) {
      case SubscriptionPlan.silver:
        await _safeSubscribe('silver');
      case SubscriptionPlan.gold:
        await _safeSubscribe('gold');
      case SubscriptionPlan.premium:
        await _safeSubscribe('premium');
      case SubscriptionPlan.none:
        break;
    }
  }

  Future<void> _prepareMessaging() async {
    await _fm.requestPermission();
    await _fm.getToken();

    if (Platform.isIOS) {
      String? apns = await _fm.getAPNSToken();
      int tries = 0;
      while (apns == null && tries < 10) {
        await Future.delayed(const Duration(milliseconds: 300));
        apns = await _fm.getAPNSToken();
        tries++;
      }
    }
  }

  Future<void> _safeSubscribe(String topic) async {
    try {
      await _fm.subscribeToTopic(topic);
    } catch (_) {
    }
  }
}
