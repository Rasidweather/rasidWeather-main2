import 'package:flutter/foundation.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'app_user_id.dart';

Future<void> ensureRevenueCatUser(String? userId) async {
  final String normalizedUserId = userId?.trim() ?? '';
  if (normalizedUserId.isEmpty) return;

  final String expectedAppUserId = buildAppUserId(dbId: normalizedUserId);

  try {
    final String currentAppUserId = await Purchases.appUserID;
    if (currentAppUserId == expectedAppUserId) {
      return;
    }
  } catch (e) {
    if (kDebugMode) {
      debugPrint('RevenueCat appUserID read failed: $e');
    }
  }

  await logInToRevenueCat(normalizedUserId);
}

Future<void> logInToRevenueCat(String? userId) async {
  final String normalizedUserId = userId?.trim() ?? '';
  if (normalizedUserId.isEmpty) return;

  try {
    await Purchases.logIn(buildAppUserId(dbId: normalizedUserId));
  } catch (e) {
    if (kDebugMode) {
      debugPrint('RevenueCat logIn failed for userId=$normalizedUserId: $e');
    }
  }
}

Future<void> logOutFromRevenueCat() async {
  try {
    await Purchases.logOut();
  } catch (e) {
    if (kDebugMode) {
      debugPrint('RevenueCat logOut failed: $e');
    }
  }
}
