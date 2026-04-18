class SubscriptionModel {
  SubscriptionModel({
    this.id,
    this.userId,
    this.type,
    this.originalTransactionId,
    this.orderId,
    this.kind,
    this.linkedPurchaseToken,
    this.webOrderLineItemId,
    this.offerId,
    this.subscriptionGroupId,
    this.productId,
    this.isSubscribed,
    this.isRefund,
    this.willAutoRenew,
    this.originalPurchasedAt,
    this.purchasedAt,
    this.expiredAt,
    this.upgradedAt,
    this.revokedAt,
    this.createdAt,
    this.updatedAt,
  });

  SubscriptionModel.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    type = json['type'].toString();
    originalTransactionId = json['original_transaction_id'].toString();
    orderId = json['order_id'].toString();
    kind = json['kind'].toString();
    linkedPurchaseToken = json['linkedPurchaseToken'].toString();
    webOrderLineItemId = json['web_order_line_item_id'].toString();
    offerId = json['offer_id'].toString();
    subscriptionGroupId = json['subscription_group_id'].toString();
    productId = json['product_id'].toString();
    isSubscribed = json['is_subscribed'] as bool;
    isRefund = json['is_refund'] as bool;
    willAutoRenew = json['will_auto_renew'] as bool;
    originalPurchasedAt = json['original_purchased_at'] == null ? null : DateTime.parse(json['original_purchased_at'].toString());
    purchasedAt = json['purchased_at'] == null ? null : DateTime.parse(json['purchased_at'].toString());
    expiredAt = json['expired_at'] == null ? null : DateTime.parse(json['expired_at'].toString());
    upgradedAt = json['upgraded_at'] == null ? null : DateTime.parse(json['upgraded_at'].toString());
    revokedAt = json['revoked_at'] == null ? null : DateTime.parse(json['revoked_at'].toString());
    createdAt = json['created_at'] == null ? null : DateTime.parse(json['created_at'].toString());
    updatedAt = json['updated_at'] == null ? null : DateTime.parse(json['updated_at'].toString());
  }

  String? id;
  String? userId;
  String? type;
  String? originalTransactionId;
  String? orderId;
  String? kind;
  String? linkedPurchaseToken;
  String? webOrderLineItemId;
  String? offerId;
  String? subscriptionGroupId;
  String? productId;
  bool? isSubscribed;
  bool? isRefund;
  bool? willAutoRenew;
  DateTime? originalPurchasedAt;
  DateTime? purchasedAt;
  DateTime? expiredAt;
  DateTime? upgradedAt;
  DateTime? revokedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  bool get isSubscribeExpired {
    if (expiredAt != null) {
      print('Subscription expiry check: expiredAt=$expiredAt, now=${DateTime.now()}');
    }

    if (expiredAt == null || isSubscribed == false) {
      return true;
    }

    final bool hasExpired = DateTime.now().isAfter(expiredAt!);
    
    final bool isInGracePeriod = DateTime.now().difference(expiredAt!).inMinutes <= 5;
    
    if (hasExpired && isInGracePeriod) {
      print('Subscription in grace period: ${DateTime.now().difference(expiredAt!).inMinutes} minutes after expiration');
      return false;
    }
    
    return hasExpired;
  }



  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['type'] = type;
    data['original_transaction_id'] = originalTransactionId;
    data['order_id'] = orderId;
    data['kind'] = kind;
    data['linkedPurchaseToken'] = linkedPurchaseToken;
    data['web_order_line_item_id'] = webOrderLineItemId;
    data['offer_id'] = offerId;
    data['subscription_group_id'] = subscriptionGroupId;
    data['product_id'] = productId;
    data['is_subscribed'] = isSubscribed;
    data['is_refund'] = isRefund;
    data['will_auto_renew'] = willAutoRenew;
    data['original_purchased_at'] = originalPurchasedAt?.toIso8601String();
    data['purchased_at'] = purchasedAt?.toIso8601String();
    data['expired_at'] = expiredAt?.toIso8601String();
    data['upgraded_at'] = upgradedAt?.toIso8601String();
    data['revoked_at'] = revokedAt?.toIso8601String();
    data['created_at'] = createdAt?.toIso8601String();
    data['updated_at'] = updatedAt?.toIso8601String();
    return data;
  }
}
