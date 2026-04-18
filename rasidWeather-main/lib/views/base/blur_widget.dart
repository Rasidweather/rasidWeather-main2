import 'package:flutter/material.dart';

import '../../core/widgets/image_widget.dart';

class BlurWidget extends StatelessWidget {
  const BlurWidget({
    super.key,
    required this.child,
    this.color = Colors.black12,
  });

  final Widget child;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: Stack(fit: StackFit.expand, alignment: Alignment.center, children: <Widget>[
        Positioned(
          top: 0,
          bottom: 0,
          child: ImageView.lottie('assets/blur.json', width: MediaQuery.sizeOf(context).width, fit: BoxFit.cover),
        ),
        Positioned(
          top: 0,
          bottom: 0,
          right: 0,
          left: 0,
          child: Container(color: color),
        ),
        child,
      ]),
    );
  }
}
