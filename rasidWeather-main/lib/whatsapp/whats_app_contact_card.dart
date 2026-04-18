import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../../common/constants/strings.dart';
import '../../../../../../views/base/weather_container.dart';

class WhatsAppContactCard extends StatelessWidget {
  const WhatsAppContactCard({super.key});

  static final Image _illustration = Image.asset('assets/whatsApp.png'); // غيّر المسار إذا لزم

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;

    final String bodyText = _trOr(
      'inquiries.message_whats',
      'inquiries.message',
    );

    return WeatherContainer(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(10),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 3,
            child: Column(
              children: <Widget>[
                Text(
                  bodyText,
                  style: textTheme.bodyMedium!.copyWith(
                    fontSize: 20.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10.h),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    minimumSize: Size(150.w, 40.h),
                  ),
                  onPressed: () => _openWhatsApp(
                    context: context,
                    phoneE164: AppStrings.whatsappPhoneE164,
                    message: _defaultWhatsappMessage(context),
                  ),
                  child: Text(
                    'inquiries.button'.tr(),
                    style: textTheme.bodyMedium!.copyWith(
                      fontSize: 15.sp,
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: _illustration),
        ],
      ),
    );
  }

  /// يحاول ترجمة [key]، ولو طلعت الترجمة نفسها اسم المفتاح (يعني مفقودة)
  /// يرجع ترجمة [fallbackKey].
  static String _trOr(String key, String fallbackKey) {
    final String s = key.tr();
    // EasyLocalization بترجع المفتاح نفسه لو مش موجود
    if (identical(s, key)) return fallbackKey.tr();
    return s;
  }

  /// رسالة افتراضية للواتساب قابلة للترجمة بمفتاح:
  /// inquiries.default_whatsapp_message
  /// لو مش موجودة: يعطي رسالة عربية/إنجليزية حسب لغة التطبيق.
  static String _defaultWhatsappMessage(BuildContext context) {
    const String key = 'inquiries.default_whatsapp_message';
    final String t = key.tr();
    if (!identical(t, key)) return t;

    final bool isAr = context.locale.languageCode.toLowerCase().startsWith('ar');
    return isAr
        ? 'مرحباً، أود التحدث معكم بخصوص حالة الطقس.'
        : "Hello, I'd like to talk with you about the weather.";
  }

  Future<void> _openWhatsApp({
    required BuildContext context,
    required String phoneE164,
    String? message,
  }) async {
    // نحول +9705xxxx إلى 9705xxxx (بدون +)
    final String digitsOnly = phoneE164.replaceAll('+', '').replaceAll(' ', '');
    final String encodedMsg = Uri.encodeComponent(message ?? '');
    final Uri uri = Uri.parse(
      'https://wa.me/$digitsOnly${encodedMsg.isNotEmpty ? '?text=$encodedMsg' : ''}',
    );

    final bool ok = await canLaunchUrl(uri);
    if (!ok) {
      if (context.mounted) {
        final String failText = _trOr(
          'inquiries.whatsapp_open_failed',
          // افتراضي لو المفتاح مش موجود
          context.locale.languageCode.toLowerCase().startsWith('ar')
              ? 'تعذر فتح واتساب على هذا الجهاز'
              : 'Unable to open WhatsApp on this device',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(failText),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
