# RevenueCat Webhook Integration

هذا الدليل يشرح كيفية ربط RevenueCat webhook مع تطبيق RASID Weather لمتابعة أحداث الاشتراكات.

## الملفات المضافة

### 1. `lib/services/revenuecat_webhook_service.dart`
- يحتوي على `RevenueCatWebhookService` لمعالجة أحداث webhook
- يدعم كل أنواع الأحداث:
  - `INITIAL_PURCHASE` - اشتراك جديد
  - `RENEWAL` - تجديد الاشتراك
  - `EXPIRATION` - انتهاء الاشتراك
  - `CANCELLATION` - إلغاء الاشتراك
  - `BILLING_ISSUE` - مشكلة في الدفع

### 2. التعديلات على `lib/main.dart`
- إضافة مستمع لأحداث RevenueCat
- إرسال webhook لكل تغيير في حالة الاشتراك

### 3. التعديلات على `lib/bloc/subscription_cuibt/subscription_cubit.dart`
- إرسال webhook عند الشراء مباشرة
- معالجة الأحداث المحلية والبعث للسيرفر

## كيف يعمل النظام

### 1. عند تغيير حالة الاشتراك
```dart
Purchases.addCustomerInfoUpdateListener((CustomerInfo info) async {
  // تحليل التغيير وإرسال webhook مناسب
});
```

### 2. عند الشراء المباشر
```dart
case PurchaseStatus.purchased:
  final webhookEvent = RevenueCatWebhookEvent(
    type: WebhookEventType.initialPurchase,
    // ... بيانات الحدث
  );
  await RevenueCatWebhookService.handleWebhookEvent(webhookEvent);
```

### 3. إرسال للسيرفر
```dart
static Future<bool> sendWebhookEvent(RevenueCatWebhookEvent event) async {
  final response = await http.post(
    Uri.parse('https://rasidweather.com/api/subscription/confirm-revenuecat'),
    body: jsonEncode(event.toJson()),
  );
  return response.statusCode >= 200 && response.statusCode < 300;
}
```

## أمثلة على الأحداث

### اشتراك جديد
```json
{
  "type": "INITIAL_PURCHASE",
  "app_user_id": "user-123",
  "store": "PLAY_STORE",
  "product_id": "annual_package",
  "entitlement_ids": ["annually.gold"],
  "transaction_id": "GPA.3312-3456-7890-12345",
  "original_transaction_id": "GPA.3312-3456-7890-12345",
  "purchased_at": 1742860800000,
  "subscription_expires_at": 1774396800000
}
```

### تجديد الاشتراك
```json
{
  "type": "RENEWAL",
  "app_user_id": "user-123",
  "store": "PLAY_STORE",
  "product_id": "annual_package",
  "entitlement_ids": ["annually.gold"],
  "transaction_id": "GPA.3312-3456-7890-99999",
  "original_transaction_id": "GPA.3312-3456-7890-12345",
  "purchased_at": 1774396800000,
  "subscription_expires_at": 1805932800000
}
```

## الخطوات التالية

1. **فعّل Webhook الرسمي داخل RevenueCat Dashboard** على نفس الرابط:
   `https://rasidweather.com/api/subscription/confirm-revenuecat`
2. **اعتبر الإرسال من التطبيق دعمًا إضافيًا فقط** وليس المصدر الوحيد، لأن أحداث مثل `RENEWAL` و`EXPIRATION` و`BILLING_ISSUE` قد تحصل والتطبيق مغلق.
3. **اختبر الأحداث** باستخدام حسابات اختبار
4. **راقب السجلات** للتأكد من وصول الأحداث للسيرفر
5. **تعامل مع الأخطاء** وقم بإعادة المحاولة عند الفشل

## ملاحظات هامة

- تأكد من أن الـ entitlement ID الصحيح مستخدم في الكود
- التطبيق لا يملك دائمًا `transaction_id` و `original_transaction_id` من `CustomerInfo`، لذلك التغطية الكاملة لهذه الحقول تكون من Webhook RevenueCat الرسمي
- يمكن إضافة headers للمصادقة إذا لزم الأمر
- يفضل إضافة retry logic للأحداث الفاشلة
- راقب حجم الأحداث المرسلة لتجنب الحد الزمني للـ API
