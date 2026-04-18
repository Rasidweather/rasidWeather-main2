import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../common/constants/index.dart';
import '../../../../core/widgets/image_widget.dart';
import '../../../../data/model/article_model.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../utils/utils.dart';
import '../../../base/cached_image.dart';

import '../articles_components/index.dart';

class Card5 extends StatelessWidget {
  const Card5({super.key, required this.article, required this.heroTag});

  final ArticleModel article;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (article.isFeatured && AppStrings.isVip) {
            RouterHelper.getArticleDetailsRoute(article.id!, article: article);
          } else {
            RouterHelper.getSubscriptionIntroRoute();
          }
        },
        child: Card(
            child: Stack(children: <Widget>[
          Wrap(children: <Widget>[
            Stack(alignment: Alignment.center, children: <Widget>[
              SizedBox(
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  child: CustomCacheImage(imageUrl: article.mainImage!.original!, radius: 15.0, circularShape: false)),
              VideoIcon(contentType: article.contentType, iconSize: 80)
            ]),
            Container(
                margin: const EdgeInsets.all(20),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text(article.title!,
                      maxLines: 3, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 10),
                  Row(children: <Widget>[
                    ImageView.svgAsset(Assets.svgCalender, width: 16, color: Theme.of(context).secondaryHeaderColor),
                    const SizedBox(width: 3),
                    Text(dateTimeToTimeAgo(article.createdAt!),
                        style: TextStyle(fontSize: 12, color: Theme.of(context).secondaryHeaderColor)),
                    const Spacer(),
                    const Icon(Icons.favorite, size: 16, color: Colors.grey),
                    const SizedBox(width: 3),
                    Text(article.countLikes.toString(), style: TextStyle(fontSize: 12, color: Theme.of(context).secondaryHeaderColor))
                  ])
                ]))
          ]),
          if (article.isFeatured && AppStrings.isVip)
            Positioned.fill(
                child: Container(
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(8.0)),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: <Widget>[
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(minimumSize: Size(160.w, 30.h), backgroundColor: Theme.of(context).secondaryHeaderColor),
                          onPressed: () => RouterHelper.getSubscriptionIntroRoute(),
                          child: Text('إشترك الآن', style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white)))
                    ]))),
          if (article.isFeatured && !AppStrings.isVip)
            Positioned(
                left: 0,
                top: 0,
                child: Container(
                    width: 40.w,
                    height: 40.h,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).secondaryHeaderColor,
                        borderRadius: const BorderRadius.only(bottomRight: Radius.circular(15), topLeft: Radius.circular(8))),
                    child: ImageView.svgAsset(Assets.assetsDiamond, color: Colors.white, width: 30.sp)))
        ])));
  }
}
