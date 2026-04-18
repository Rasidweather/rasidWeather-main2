import 'package:flutter/material.dart';

import '../../../../core/widgets/image_widget.dart';
import '../../../../data/model/article_model.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../utils/utils.dart';
import '../../../base/cached_image.dart';

import '../articles_components/index.dart';

// TODO(mohamedSleem): not used.
class SliverCard extends StatelessWidget {
  const SliverCard({super.key, required this.article, required this.heroTag});
  final ArticleModel article;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        margin: const EdgeInsets.only(bottom: 15),
        decoration: BoxDecoration(color: Theme.of(context).primaryColorLight, borderRadius: BorderRadius.circular(5), boxShadow: <BoxShadow>[
          BoxShadow(
            color: Theme.of(context).shadowColor,
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ]),
        child: Wrap(children: <Widget>[
          Stack(alignment: Alignment.center, children: <Widget>[
            SizedBox(
              height: 160,
              width: MediaQuery.of(context).size.width,
              child: CustomCacheImage(
                imageUrl: article.mainImage!.original!,
                radius: 5.0,
                circularShape: false,
              ),
            ),
            VideoIcon(
              contentType: article.contentType,
              iconSize: 80,
            ),
          ]),
          Container(
            margin: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
              Text(
                article.title!,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              Row(children: <Widget>[
                ImageView.svgAsset(
                  Assets.svgCalender,
                  width: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 3),
                Text(
                  dateTimeToTimeAgo(article.createdAt!),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
                const Spacer(),
                const Icon(
                  Icons.favorite,
                  size: 16,
                  color: Colors.grey,
                ),
                const SizedBox(width: 3),
                Text(
                  article.countLikes.toString(),
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).secondaryHeaderColor,
                  ),
                ),
              ]),
            ]),
          ),
        ]),
      ),
      onTap: () => RouterHelper.getArticleDetailsRoute(article.id!, article: article),
    );
  }
}
