import 'package:flutter/material.dart';

import '../../main.dart';

class Responsive {
  static bool get isMobile {
    final BuildContext? context = Get.context;
    return context != null && MediaQuery.of(context).size.width < 850;
  }

  static bool get isTablet {
    final BuildContext? context = Get.context;
    return context != null && (MediaQuery.of(context).size.width < 1100 && MediaQuery.of(context).size.width >= 850);
  }

  static bool get isDesktop {
    final BuildContext? context = Get.context;
    return !(context != null) || MediaQuery.of(context).size.width >= 1100;
  }
}
