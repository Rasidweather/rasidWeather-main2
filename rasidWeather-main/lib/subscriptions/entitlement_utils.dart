import 'package:purchases_flutter/purchases_flutter.dart';

import '../constant.dart';

Future<bool> isEntitled() async {
  final CustomerInfo info = await Purchases.getCustomerInfo();
  return info.entitlements.all[entitlementID]?.isActive ?? false;
}
