import '../common/constants/strings.dart';

class FeatureAccess {
  static Future<bool> canUseInAppChat() async {
    // الذهبية فقط
    return AppStrings.planName == 'gold';
  }

  static Future<bool> canUseWhatsAppChat() async {
    // الفضية فقط
    return AppStrings.planName == 'whatsapp';
  }

  static Future<bool> isVip() async {
    // أي باقة مدفوعة
    final String p = AppStrings.planName;
    return p == 'gold' || p == 'whatsapp' || p == 'basic';
  }
}
