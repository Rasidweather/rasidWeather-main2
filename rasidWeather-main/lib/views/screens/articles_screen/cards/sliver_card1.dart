import 'package:flutter/material.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../data/model/article_model.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../utils/utils.dart';
import '../../../base/cached_image.dart';

import '../articles_components/index.dart';

// TODO(mohamedSleem): not used.
class SliverCard1 extends StatelessWidget {
  const SliverCard1({super.key, required this.article, required this.heroTag});
  final ArticleModel article;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(color: Theme.of(context).primaryColorLight, borderRadius: BorderRadius.circular(5), boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ]),
        child: Column(children: <Widget>[
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
            Flexible(
              flex: 5,
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Text(
                  article.title!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                    top: 3,
                    bottom: 3,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    color: Colors.blueGrey[600],
                  ),
                  child: Text(
                    article.categories!.first.title!,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
            ),
            Flexible(
              flex: 3,
              child: Stack(alignment: Alignment.center, children: <Widget>[
                Container(
                  height: 100,
                  width: 100,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: CustomCacheImage(
                    imageUrl: article.mainImage!.original!,
                    radius: 5.0,
                  ),
                ),
                VideoIcon(
                  contentType: article.contentType,
                  iconSize: 40,
                ),
              ]),
            ),
          ]),
          const SizedBox(height: 20),
          Row(children: <Widget>[
            ImageView.svgAsset(
              Assets.svgCalender,
              color: Colors.grey,
              width: 20,
            ),
            const SizedBox(width: 5),
            Text(
              dateTimeToTimeAgo(article.createdAt!),
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 13,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.favorite,
              color: Theme.of(context).secondaryHeaderColor,
              size: 20,
            ),
            const SizedBox(width: 3),
            Text(
              article.countLikes.toString(),
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 13,
              ),
            ),
          ]),
        ]),
      ),
      onTap: () => RouterHelper.getArticleDetailsRoute(article.id!, article: article),
    );
  }
}
