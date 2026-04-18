import 'package:flutter/material.dart';

class VideoIcon extends StatelessWidget {
  const VideoIcon({
    super.key,
    required this.contentType,
    required this.iconSize,
  });
  final String contentType;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    if (contentType != 'video') {
      return Container();
    } else {
      return Align(
        child: Icon(
          Icons.play_circle_fill_outlined,
          color: Colors.white,
          size: iconSize,
        ),
      );
    }
  }
}
