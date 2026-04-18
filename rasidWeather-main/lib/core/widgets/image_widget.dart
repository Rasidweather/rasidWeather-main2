import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'lottie_icon_widget.dart';

enum ImageType { svg, link, asset, svgLink, lottie, lottieLink }

/// An optimized image view widget that supports various image types
@immutable
class ImageView extends StatelessWidget {
  const ImageView({
    super.key,
    required this.imageType,
    required this.image,
    this.imageColor,
    this.noColor = false,
    this.rotate = 0.0,
    this.fit = BoxFit.contain,
    this.width,
  });

  // Factory constructors to simplify instance creation
  factory ImageView.svgAsset(String image,
      {Color? color,
      BoxFit fit = BoxFit.contain,
      double? width,
      double? rotate}) {
    return ImageView(
        imageType: ImageType.svg,
        image: image,
        imageColor: color,
        noColor: color == null,
        fit: fit,
        width: width,
        rotate: rotate);
  }

  factory ImageView.svgLink(String image,
      {Color? color, BoxFit fit = BoxFit.contain, double? width}) {
    return ImageView(
        imageType: ImageType.svgLink,
        image: image,
        imageColor: color,
        noColor: color == null,
        fit: fit,
        width: width);
  }

  factory ImageView.link(String image,
      {BoxFit fit = BoxFit.contain, double? width}) {
    return ImageView(
        imageType: ImageType.link, image: image, fit: fit, width: width);
  }

  factory ImageView.asset(String image,
      {Color? color, BoxFit fit = BoxFit.contain, double? width}) {
    return ImageView(
        imageType: ImageType.asset,
        image: image,
        imageColor: color,
        noColor: color == null,
        fit: fit,
        width: width);
  }

  factory ImageView.lottie(String image,
      {BoxFit fit = BoxFit.contain, double? width}) {
    return ImageView(
        imageType: ImageType.lottie, image: image, fit: fit, width: width);
  }

  factory ImageView.lottieLink(String image,
      {BoxFit fit = BoxFit.contain, double? width}) {
    return ImageView(
        imageType: ImageType.lottieLink, image: image, fit: fit, width: width);
  }

  final ImageType imageType;
  final String image;
  final Color? imageColor;
  final bool noColor;
  final double? rotate;
  final BoxFit fit;
  final double? width;

  static const double _piDiv180 = pi / 180;

  @override
  Widget build(BuildContext context) {
    final double rotationAngle =
        (rotate == null || rotate == 0.0) ? 0.0 : rotate! * _piDiv180;
    final Widget imageWidget = _buildImage();

    return rotationAngle == 0.0
        ? imageWidget
        : Transform.rotate(angle: rotationAngle, child: imageWidget);
  }

  /// Builds the appropriate image widget based on the image type
  Widget _buildImage() {
    switch (imageType) {
      case ImageType.svg:
        return _buildSvgPicture(SvgPicture.asset);
      case ImageType.svgLink:
        return _buildSvgPicture(SvgPicture.network);
      case ImageType.link:
        return Image.network(image,
            fit: BoxFit.cover,
            width: width,
            errorBuilder: (_, __, ___) =>
                const SizedBox(width: 24, height: 24));
      case ImageType.asset:
        return Image.asset(image, fit: fit, color: imageColor, width: width);
      case ImageType.lottie:
        return LottieIcon(source: image, size: width ?? 24, fit: fit);
      case ImageType.lottieLink:
        return LottieIcon(
            source: image, isAsset: false, size: width ?? 24, fit: fit);
    }
  }

  /// Helper method to build an SVG image
  Widget _buildSvgPicture(
      SvgPicture Function(String, {double? width, BoxFit fit, Color? color})
          svgBuilder) {
    return svgBuilder(image,
        width: width, fit: fit, color: noColor ? null : imageColor);
  }
}
