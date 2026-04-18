import 'package:flutter/material.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../data/model/article_model.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../utils/utils.dart';
import '../../../base/cached_image.dart';

import '../articles_components/index.dart';

class FeaturedCard extends StatelessWidget {
  const FeaturedCard({super.key, required this.article});
  final ArticleModel article;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Card(
        margin: const EdgeInsets.all(15),
        child: Stack(children: <Widget>[
          Stack(alignment: Alignment.center, children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.circular(5), boxShadow: <BoxShadow>[
                BoxShadow(
                  color: Theme.of(context).shadowColor,
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ]),
              child: CustomCacheImage(
                imageUrl: article.mainImage!.main!,
                radius: 5,
              ),
            ),
            VideoIcon(
              contentType: article.videoType != null ? 'video' : 'image',
              iconSize: 80,
            ),
          ]),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 15, left: 15, right: 5),
              child: Row(children: <Widget>[
                Container(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  height: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.deepPurpleAccent.withOpacity(0.7),
                  ),
                  child: Text(
                    article.categories!.first.title!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 6,
                    bottom: 6,
                  ),
                  height: 30,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.black45,
                  ),
                  child: Row(children: <Widget>[
                    const Icon(
                      Icons.favorite,
                      size: 20,
                      color: Colors.white,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      article.countLikes.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ]),
                ),
                const SizedBox(width: 10),
              ]),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.only(
                left: 15,
                right: 15,
                top: 15,
                bottom: 15,
              ),
              decoration: const BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
              ),
              child: Column(children: <Widget>[
                Text(
                  article.title!,
                  style: const TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 5),
                Row(children: <Widget>[
                  ImageView.svgAsset(
                    Assets.svgCalender,
                    width: 16,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    dateTimeToTimeAgo(article.createdAt!),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ]),
              ]),
            ),
          ),
        ]),
      ),
      onTap: () => RouterHelper.getArticleDetailsRoute(article.id!, article: article),
    );
  }
}
