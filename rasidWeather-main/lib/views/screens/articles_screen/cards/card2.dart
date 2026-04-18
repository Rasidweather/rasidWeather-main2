import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:html/parser.dart';
import 'package:html_unescape/html_unescape.dart';

import '../../../../common/constants/index.dart';
import '../../../../core/widgets/image_widget.dart';
import '../../../../data/model/article_model.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../utils/utils.dart';
import '../../../base/index.dart';
import '../articles_components/index.dart';

class Card2 extends StatelessWidget {
  const Card2({super.key, required this.article, required this.heroTag});

  final ArticleModel article;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        children: <Widget>[
          Card(
            child: Wrap(children: <Widget>[
              Stack(alignment: Alignment.center, children: <Widget>[
                SizedBox(
                  height: 160,
                  width: MediaQuery.of(context).size.width,
                  child: CustomCacheImage(imageUrl: article.mainImage!.original!, radius: 15, circularShape: false),
                ),
                VideoIcon(contentType: article.contentType, iconSize: 80),
              ]),
              Container(
                margin: const EdgeInsets.all(15),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                  Text(
                    article.title!,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    HtmlUnescape().convert(parse(article.description).documentElement!.text),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Theme.of(context).secondaryHeaderColor),
                  ),
                  const SizedBox(height: 10),
                  Row(children: <Widget>[
                    ImageView.svgAsset(Assets.svgCalender),
                    const SizedBox(width: 3),
                    Text(
                      dateTimeToTimeAgo(article.createdAt!),
                    ),
                    const Spacer(),
                    Icon(Icons.favorite, size: 16, color: Theme.of(context).secondaryHeaderColor),
                    const SizedBox(width: 3),
                    Text(
                      article.countLikes.toString(),
                      style: TextStyle(fontSize: 12, color: Theme.of(context).secondaryHeaderColor),
                    ),
                  ]),
                ]),
              ),
            ]),
          ),
          if (article.isFeatured && !AppStrings.isVip)
            Positioned.fill(
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(mainAxisAlignment: MainAxisAlignment.end, mainAxisSize: MainAxisSize.min, children: <Widget>[
                      ViewTooltip(
                        message: 'مقالة مميزة',
                        backgroundColor: Theme.of(context).secondaryHeaderColor,
                        child: Text(
                          'articles.featured_article'.tr(),
                          style: const TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
                        ),
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
                        ),
                      ),
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
                    child: ImageView.svgAsset(Assets.assetsDiamond, color: Colors.white, width: 30.sp))),
        ],
      ),
      onTap: () {
        if (article.isFeatured && !AppStrings.isVip) {
          RouterHelper.getSubscriptionIntroRoute();
        } else {
          RouterHelper.getArticleDetailsRoute(article.id!, article: article);
        }
      },
    );
  }
}
