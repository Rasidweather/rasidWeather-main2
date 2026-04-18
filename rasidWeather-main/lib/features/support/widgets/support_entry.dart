import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/feature_access.dart';

class SupportEntry extends StatelessWidget { // رقم المستخدم لحالة واتساب
  const SupportEntry({super.key, this.userPhone});
  final String? userPhone;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait(<Future<bool>>[
        FeatureAccess.canUseInAppChat(),
        FeatureAccess.canUseWhatsAppChat(),
        FeatureAccess.isVip(),
      ]),
      builder: (BuildContext context, AsyncSnapshot<List<bool>> snap) {
        if (!snap.hasData) return const SizedBox.shrink();
        final bool canInApp = snap.data![0];
        final bool canWhats = snap.data![1];
        final bool isVip    = snap.data![2];

        if (canInApp) {
          return ElevatedButton(
            onPressed: () => Navigator.of(context).pushNamed('/chat'),
            child: const Text('الدردشة داخل التطبيق'),
          );
        }
        if (canWhats) {
          return ElevatedButton(
            onPressed: () async {
              final String phone = (userPhone?.isNotEmpty ?? false ? userPhone! : '201026094252')
                  .replaceAll(RegExp(r'[^0-9+]'), '');
              final Uri uri = Uri.parse('https://wa.me/$phone');
              if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تعذر فتح واتساب')),
                );
              }
            },
            child: const Text('تحدث عبر واتساب'),
          );
        }
        if (isVip) {
          return const SizedBox.shrink(); // المميزة: بدون أزرار إضافية
        }
        return OutlinedButton(
          onPressed: () => Navigator.of(context).pushNamed('/subscriptions'),
          child: const Text('اشترك للوصول للدردشة'),
        );
      },
    );
  }
}
