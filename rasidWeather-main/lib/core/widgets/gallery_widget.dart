import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class GalleryImage {
  const GalleryImage({required this.image, this.id});
  final String image;
  final Object? id;
}

class GalleryWidget extends StatefulWidget {

  const GalleryWidget({
    super.key,
    required this.galleryItems,
    this.initialIndex = 0,
    this.darkBackground = true,
  });
  final List<GalleryImage> galleryItems;
  final int initialIndex;
  final bool darkBackground;

  @override
  State<GalleryWidget> createState() => _GalleryWidgetState();
}

class _GalleryWidgetState extends State<GalleryWidget> {
  late final PageController _controller;
  late int _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialIndex.clamp(0, widget.galleryItems.length - 1);
    _controller = PageController(initialPage: _current);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color bg = widget.darkBackground ? Colors.black : Colors.white;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: bg,
        foregroundColor: widget.darkBackground ? Colors.white : Colors.black,
        title: Text('${_current + 1}/${widget.galleryItems.length}'),
      ),
      body: PhotoViewGallery.builder(
        itemCount: widget.galleryItems.length,
        pageController: _controller,
        onPageChanged: (int i) => setState(() => _current = i),
        backgroundDecoration: BoxDecoration(color: bg),
        builder: (BuildContext context, int index) {
          final GalleryImage item = widget.galleryItems[index];

          // لو عندك أصول محلية، بدّل NetworkImage بـ AssetImage
          final NetworkImage provider = NetworkImage(item.image);

          return PhotoViewGalleryPageOptions(
            imageProvider: provider,
            heroAttributes: item.id != null
                ? PhotoViewHeroAttributes(tag: item.id!)
                : null,
            minScale: PhotoViewComputedScale.contained,
            maxScale: PhotoViewComputedScale.covered * 3.0,
            errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.broken_image, size: 48)),
          );
        },
        loadingBuilder: (_, __) =>
        const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
