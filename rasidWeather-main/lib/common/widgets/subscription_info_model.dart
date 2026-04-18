class SubscriptionInfoModel {

  SubscriptionInfoModel({
    required this.planName,
    required this.removeAds,
    required this.showAnimation,
    required this.chatEmail,
    required this.chatWhatsApp,
  });

  factory SubscriptionInfoModel.fromBackendName(String backendName) {
    final String name = backendName.trim();

    if (name.contains('المميزة')) {
      return SubscriptionInfoModel(
        planName: 'basic',
        removeAds: true,
        showAnimation: true,
        chatEmail: false,
        chatWhatsApp: false,
      );
    }

    if (name.contains('الذهبية')) {
      return SubscriptionInfoModel(
        planName: 'gold',
        removeAds: true,
        showAnimation: true,
        chatEmail: true,
        chatWhatsApp: false,
      );
    }

    if (name.contains('الفضية')) {
      return SubscriptionInfoModel(
        planName: 'whatsapp',
        removeAds: true,
        showAnimation: true,
        chatEmail: true,
        chatWhatsApp: true,
      );
    }

    return SubscriptionInfoModel(
      planName: 'unknown',
      removeAds: false,
      showAnimation: false,
      chatEmail: false,
      chatWhatsApp: false,
    );
  }
  final String planName;"

  final bool removeAds;
  final bool showAnimation;
  final bool chatEmail;
  final bool chatWhatsApp;
}
