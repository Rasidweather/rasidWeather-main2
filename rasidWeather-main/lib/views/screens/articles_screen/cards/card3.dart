import 'package:easy_localization/easy_localization.dart';
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

class Card3 extends StatelessWidget {
  const Card3({super.key, required this.article, this.heroTag, this.replace = false});

  final ArticleModel article;
  final String? heroTag;
  final bool? replace;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (article.isFeatured && !AppStrings.isVip) {
          RouterHelper.getSubscriptionIntroRoute();
        } else {
          RouterHelper.getArticleDetailsRoute(article.id!, article: article);
        }
      },
      child: Stack(children: <Widget>[
        Card(
            child: Padding(
                padding: const EdgeInsets.all(15),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Flexible(
                      flex: 2,
                      child: heroTag == null
                          ? Stack(alignment: Alignment.center, children: <Widget>[
                              Container(
                                  height: 140,
                                  width: 140,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                                  child: CustomCacheImage(imageUrl: article.mainImage!.original!, radius: 5.0)),
                              VideoIcon(contentType: article.contentType, iconSize: 60)
                            ])
                          : Stack(alignment: Alignment.center, children: <Widget>[
                              Container(
                                height: 140,
                                width: 140,
                                decoration: BoxDecoration(borderRadius: BorderRadius.circular(5.0)),
                                child: CustomCacheImage(imageUrl: article.mainImage!.original!, radius: 5.0),
                              ),
                              VideoIcon(contentType: article.contentType, iconSize: 60)
                            ])),
                  const SizedBox(width: 15),
                  Flexible(
                      flex: 4,
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                        Text(article.title!,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500), maxLines: 4, overflow: TextOverflow.ellipsis),
                        const SizedBox(height: 10),
                        Container(
                            padding: const EdgeInsets.only(left: 10, right: 10, top: 3, bottom: 3),
                            decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: Colors.blueGrey[600]),
                            child: Text(article.categories!.first.title!,
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white))),
                        const SizedBox(height: 20),
                        Row(children: <Widget>[
                          ImageView.svgAsset(Assets.svgCalender, color: Theme.of(context).secondaryHeaderColor, width: 20),
                          const SizedBox(width: 2),
                          Text(dateTimeToTimeAgo(article.createdAt!),
                              style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13)),
                          const Spacer(),
                          const Icon(Icons.favorite, color: Colors.grey, size: 20),
                          const SizedBox(width: 3),
                          Text(article.countLikes.toString(), style: TextStyle(color: Theme.of(context).secondaryHeaderColor, fontSize: 13))
                        ])
                      ]))
                ]))),
        if (article.isFeatured && !AppStrings.isVip)
          Positioned.fill(
              child: Container(
                  decoration: BoxDecoration(color: Colors.black.withOpacity(0.3), borderRadius: BorderRadius.circular(8.0)),
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: <Widget>[
                    Text(
                      'articles.premium_article'.tr(),
                      style: const TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'articles.subscribe_to_read'.tr(),
                      style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(minimumSize: Size(160.w, 30.h), backgroundColor: Theme.of(context).secondaryHeaderColor),
                        onPressed: () => RouterHelper.getSubscriptionIntroRoute(),
                        child: Text(
                          'subscription.subscribe_now'.tr(),
                          style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Colors.white),
                        )),
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
      ]),
    );
  }
}
