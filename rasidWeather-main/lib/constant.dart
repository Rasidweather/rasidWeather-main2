import 'dart:io';

const String entitlementID = 'annually';

const String footerText =
    """Don't forget to add your subscription terms and conditions.""";

const String appleApiKey = 'appl_sFLOSxvgfcSJcxbbXrqcmGVulcH';

const String googleApiKey = 'goog_OnMeutFapibXBzUuaiGJZtMQNHL';

const String amazonApiKey = 'amazon_api_key';

const String webApiKey = 'web_api_key';

String rcSdkKeyForPlatform() {
  if (Platform.isIOS) return appleApiKey;
  if (Platform.isAndroid) return googleApiKey;
  return webApiKey;
}
