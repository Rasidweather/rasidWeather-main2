import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:purchases_flutter/models/customer_info_wrapper.dart';
import 'package:purchases_flutter/models/entitlement_info_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Webhook event types from RevenueCat.
enum WebhookEventType {
  initialPurchase('INITIAL_PURCHASE'),
  renewal('RENEWAL'),
  expiration('EXPIRATION'),
  cancellation('CANCELLATION'),
  billingIssue('BILLING_ISSUE');

  const WebhookEventType(this.apiValue);

  final String apiValue;
}

/// RevenueCat webhook event model.
class RevenueCatWebhookEvent {
  RevenueCatWebhookEvent({
    required this.type,
    required this.appUserId,
    required this.store,
    required this.productId,
    required this.entitlementIds,
    this.transactionId,
    this.originalTransactionId,
    this.purchasedAt,
    this.subscriptionExpiresAt,
    this.gracePeriodExpiresAt,
  });

  final WebhookEventType type;
  final String appUserId;
  final String store;
  final String productId;
  final List<String> entitlementIds;
  final String? transactionId;
  final String? originalTransactionId;
  final int? purchasedAt;
  final int? subscriptionExpiresAt;
  final int? gracePeriodExpiresAt;

  factory RevenueCatWebhookEvent.fromJson(Map<String, dynamic> json) {
    final String typeStr = json['type']?.toString().toUpperCase() ?? '';
    final WebhookEventType type = WebhookEventType.values.firstWhere(
      (WebhookEventType value) => value.apiValue == typeStr,
      orElse: () => throw Exception('Unknown webhook event type: $typeStr'),
    );

    return RevenueCatWebhookEvent(
      type: type,
      appUserId: json['app_user_id']?.toString() ?? '',
      store: json['store']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      entitlementIds: (json['entitlement_ids'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic value) => value.toString())
          .toList(),
      transactionId: json['transaction_id']?.toString(),
      originalTransactionId: json['original_transaction_id']?.toString(),
      purchasedAt: _toInt(json['purchased_at']),
      subscriptionExpiresAt: _toInt(json['subscription_expires_at']),
      gracePeriodExpiresAt: _toInt(json['grace_period_expires_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'type': type.apiValue,
      'app_user_id': appUserId,
      'store': store,
      'product_id': productId,
      'entitlement_ids': entitlementIds,
      if (transactionId != null) 'transaction_id': transactionId,
      if (originalTransactionId != null)
        'original_transaction_id': originalTransactionId,
      if (purchasedAt != null) 'purchased_at': purchasedAt,
      if (subscriptionExpiresAt != null)
        'subscription_expires_at': subscriptionExpiresAt,
      if (gracePeriodExpiresAt != null)
        'grace_period_expires_at': gracePeriodExpiresAt,
    };
  }

  String dedupeKey() {
    return <Object?>[
      type.apiValue,
      appUserId,
      store,
      productId,
      entitlementIds.join(','),
      transactionId,
      originalTransactionId,
      purchasedAt,
      subscriptionExpiresAt,
      gracePeriodExpiresAt,
    ].join('|');
  }

  @override
  String toString() {
    return 'RevenueCatWebhookEvent(type: ${type.apiValue}, productId: $productId, appUserId: $appUserId)';
  }

  static int? _toInt(dynamic value) {
    if (value is int) {
      return value;
    }
    if (value is num) {
      return value.toInt();
    }
    if (value is String) {
      return int.tryParse(value);
    }
    return null;
  }
}

class _EntitlementSnapshot {
  const _EntitlementSnapshot({
    required this.productId,
    required this.isActive,
    required this.willRenew,
    this.latestPurchaseDateMs,
    this.expirationDateMs,
    this.unsubscribeDetectedAtMs,
    this.billingIssueDetectedAtMs,
  });

  final String productId;
  final bool isActive;
  final bool willRenew;
  final int? latestPurchaseDateMs;
  final int? expirationDateMs;
  final int? unsubscribeDetectedAtMs;
  final int? billingIssueDetectedAtMs;

  factory _EntitlementSnapshot.fromEntitlement(EntitlementInfo entitlement) {
    return _EntitlementSnapshot(
      productId: entitlement.productIdentifier,
      isActive: entitlement.isActive,
      willRenew: entitlement.willRenew,
      latestPurchaseDateMs: _parseRevenueCatDate(
        entitlement.latestPurchaseDate,
      ),
      expirationDateMs: _parseRevenueCatDate(entitlement.expirationDate),
      unsubscribeDetectedAtMs: _parseRevenueCatDate(
        entitlement.unsubscribeDetectedAt,
      ),
      billingIssueDetectedAtMs: _parseRevenueCatDate(
        entitlement.billingIssueDetectedAt,
      ),
    );
  }

  factory _EntitlementSnapshot.fromJson(Map<String, dynamic> json) {
    return _EntitlementSnapshot(
      productId: json['product_id']?.toString() ?? '',
      isActive: json['is_active'] == true,
      willRenew: json['will_renew'] == true,
      latestPurchaseDateMs: RevenueCatWebhookEvent._toInt(
        json['latest_purchase_date_ms'],
      ),
      expirationDateMs: RevenueCatWebhookEvent._toInt(
        json['expiration_date_ms'],
      ),
      unsubscribeDetectedAtMs: RevenueCatWebhookEvent._toInt(
        json['unsubscribe_detected_at_ms'],
      ),
      billingIssueDetectedAtMs: RevenueCatWebhookEvent._toInt(
        json['billing_issue_detected_at_ms'],
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'product_id': productId,
      'is_active': isActive,
      'will_renew': willRenew,
      'latest_purchase_date_ms': latestPurchaseDateMs,
      'expiration_date_ms': expirationDateMs,
      'unsubscribe_detected_at_ms': unsubscribeDetectedAtMs,
      'billing_issue_detected_at_ms': billingIssueDetectedAtMs,
    };
  }
}

/// Service to handle RevenueCat webhook events.
class RevenueCatWebhookService {
  static const String _webhookUrl =
      'https://rasidweather.com/api/subscription/confirm-revenuecat';
  static const String _snapshotPrefix = 'rc_webhook_snapshot_v1';
  static const String _sentEventPrefix = 'rc_webhook_last_sent_v1';

  /// RevenueCat Android events must still be configured in the RevenueCat
  /// dashboard webhook for complete coverage when the app is closed.
  static Future<void> syncCustomerInfo({
    required CustomerInfo customerInfo,
    required String appUserId,
  }) async {
    if (!Platform.isAndroid || appUserId.trim().isEmpty) {
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    for (final MapEntry<String, EntitlementInfo> entry
        in customerInfo.entitlements.all.entries) {
      final String entitlementId = entry.key;
      final _EntitlementSnapshot current = _EntitlementSnapshot.fromEntitlement(
        entry.value,
      );
      final _EntitlementSnapshot? previous = _loadSnapshot(
        prefs: prefs,
        appUserId: appUserId,
        entitlementId: entitlementId,
      );

      final WebhookEventType? eventType = _detectEventType(
        previous: previous,
        current: current,
      );

      _saveSnapshot(
        prefs: prefs,
        appUserId: appUserId,
        entitlementId: entitlementId,
        snapshot: current,
      );

      if (eventType == null) {
        continue;
      }

      final RevenueCatWebhookEvent event = RevenueCatWebhookEvent(
        type: eventType,
        appUserId: appUserId,
        store: 'PLAY_STORE',
        productId: current.productId,
        entitlementIds: <String>[entitlementId],
        purchasedAt: current.latestPurchaseDateMs,
        subscriptionExpiresAt: current.expirationDateMs,
        gracePeriodExpiresAt: current.billingIssueDetectedAtMs != null
            ? current.expirationDateMs
            : null,
      );

      await sendWebhookEvent(event, prefs: prefs);
    }
  }

  /// Send webhook event to your server.
  static Future<bool> sendWebhookEvent(
    RevenueCatWebhookEvent event, {
    SharedPreferences? prefs,
  }) async {
    if (!Platform.isAndroid || event.store != 'PLAY_STORE') {
      return false;
    }

    final SharedPreferences cache =
        prefs ?? await SharedPreferences.getInstance();
    final String dedupeStorageKey = _lastSentKey(
      appUserId: event.appUserId,
      entitlementId: event.entitlementIds.join(','),
    );
    final String dedupeValue = event.dedupeKey();

    if (cache.getString(dedupeStorageKey) == dedupeValue) {
      print('⏭️ Skipping duplicate webhook event: $event');
      return true;
    }

    try {
      print('📤 Sending webhook event: $event');

      final http.Response response = await http
          .post(
            Uri.parse(_webhookUrl),
            headers: <String, String>{
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: jsonEncode(event.toJson()),
          )
          .timeout(const Duration(seconds: 30));

      print('📥 Webhook response status: ${response.statusCode}');
      print('📥 Webhook response body: ${response.body}');

      if (response.statusCode >= 200 && response.statusCode < 300) {
        await cache.setString(dedupeStorageKey, dedupeValue);
        print('✅ Webhook event sent successfully');
        return true;
      }

      print('❌ Webhook failed with status: ${response.statusCode}');
      return false;
    } catch (e) {
      print('❌ Error sending webhook event: $e');
      return false;
    }
  }

  static _EntitlementSnapshot? _loadSnapshot({
    required SharedPreferences prefs,
    required String appUserId,
    required String entitlementId,
  }) {
    final String? raw = prefs.getString(
      _snapshotKey(appUserId: appUserId, entitlementId: entitlementId),
    );
    if (raw == null || raw.isEmpty) {
      return null;
    }

    try {
      return _EntitlementSnapshot.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> _saveSnapshot({
    required SharedPreferences prefs,
    required String appUserId,
    required String entitlementId,
    required _EntitlementSnapshot snapshot,
  }) {
    return prefs.setString(
      _snapshotKey(appUserId: appUserId, entitlementId: entitlementId),
      jsonEncode(snapshot.toJson()),
    );
  }

  static WebhookEventType? _detectEventType({
    required _EntitlementSnapshot? previous,
    required _EntitlementSnapshot current,
  }) {
    if (previous == null) {
      return current.isActive ? WebhookEventType.initialPurchase : null;
    }

    if (current.billingIssueDetectedAtMs != null &&
        current.billingIssueDetectedAtMs != previous.billingIssueDetectedAtMs) {
      return WebhookEventType.billingIssue;
    }

    if (current.unsubscribeDetectedAtMs != null &&
        current.unsubscribeDetectedAtMs != previous.unsubscribeDetectedAtMs) {
      return WebhookEventType.cancellation;
    }

    final bool latestPurchaseChanged =
        current.latestPurchaseDateMs != null &&
        current.latestPurchaseDateMs != previous.latestPurchaseDateMs;

    if (current.isActive && latestPurchaseChanged) {
      return previous.isActive
          ? WebhookEventType.renewal
          : WebhookEventType.initialPurchase;
    }

    if (previous.isActive && !current.isActive) {
      return WebhookEventType.expiration;
    }

    return null;
  }

  static String _snapshotKey({
    required String appUserId,
    required String entitlementId,
  }) {
    return '$_snapshotPrefix::$appUserId::$entitlementId';
  }

  static String _lastSentKey({
    required String appUserId,
    required String entitlementId,
  }) {
    return '$_sentEventPrefix::$appUserId::$entitlementId';
  }
}

int? _parseRevenueCatDate(String? value) {
  if (value == null || value.isEmpty) {
    return null;
  }
  return DateTime.tryParse(value)?.millisecondsSinceEpoch;
}
