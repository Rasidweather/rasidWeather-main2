import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../helper/router_helper.dart';

@immutable
class AdsContainer extends StatelessWidget {
  const AdsContainer({
    super.key,
    required this.child,
    this.onClose,
  });

  final Widget child;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            constraints: const BoxConstraints(),
            icon: const Icon(
              CupertinoIcons.xmark_circle_fill,
              color: Colors.white,
              size: 20,
            ),
            onPressed: onClose ?? () => RouterHelper.getSubscriptionIntroRoute(),
          ),
        ),
        Flexible(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(1),
            child: child,
          ),
        ),
      ],
    );
  }
}
