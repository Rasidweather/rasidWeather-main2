import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttericon/octicons_icons.dart';

import '../../../../common/constants/index.dart';
import '../../../../core/widgets/image_widget.dart';
import '../../../../data/model/article_model.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../utils/utils.dart';
import '../../../base/cached_image.dart';

import '../articles_components/index.dart';

class Card4 extends StatelessWidget {
  const Card4({
    super.key,
    required this.article,
    this.color,
    this.elevation,
    this.padding = 15.0,
    this.notify = false,
    this.onTap,
  });

  final ArticleModel article;
  final Color? color;
  final double? elevation;
  final double? padding;
  final bool notify;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // اختار أفضل رابط صورة متوفر (original ثم main مثلاً)
    final String? imageUrl =
        article.mainImage?.original ?? article.mainImage?.main;

    return GestureDetector(
      onTap: () {
        if (article.isFeatured && !AppStrings.isVip) {
          RouterHelper.getSubscriptionIntroRoute();
        } else {
          if (onTap != null) {
            onTap!.call();
          } else {
            // نتأكد أن id مش null قبل ما نعمل ناڤيجيت
            if (article.id != null) {
              RouterHelper.getArticleDetailsRoute(
                article.id!,
                article: article,
              );
            }
          }
        }
      },
      child: Card(
        color: color,
        elevation: elevation,
        child: Stack(
          children: <Widget>[
            if (notify)
              const Positioned(
                top: 5,
                right: 5,
                child: Icon(
                  Octicons.primitive_dot,
                  color: Colors.red,
                  size: 12,
                ),
              ),
            Padding(
              padding: EdgeInsets.all(padding ?? 15.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (imageUrl != null && imageUrl.isNotEmpty)
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SizedBox(
                          height: 90,
                          width: 90,
                          child: CustomCacheImage(
                            imageUrl: imageUrl,
                            radius: 10.0,
                          ),
                        ),
                        VideoIcon(
                          contentType: article.contentType,
                          iconSize: 40,
                        ),
                      ],
                    ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // العنوان
                          Text(
                            article.title ?? '',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: <Widget>[
                              ImageView.svgAsset(Assets.svgCalender),
                              const SizedBox(width: 5),
                              if (article.createdAt != null)
                                Text(
                                  // نفترض أن dateTimeToTimeAgo يتعامل مع النوع نفسه
                                  dateTimeToTimeAgo(article.createdAt!),
                                  style: const TextStyle(fontSize: 13),
                                ),
                              if (article.countLikes != null) const Spacer(),
                              if (article.countLikes != null)
                                const Icon(
                                  Icons.favorite,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                              if (article.countLikes != null)
                                const SizedBox(width: 3),
                              if (article.countLikes != null)
                                Text(
                                  article.countLikes.toString(),
                                  style: const TextStyle(fontSize: 13),
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // طبقة اشتراك لو المقال مميز و المستخدم مش VIP
            if (article.isFeatured && !AppStrings.isVip)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(160.w, 30.h),
                          backgroundColor:
                          Theme.of(context).secondaryHeaderColor,
                        ),
                        onPressed: () => RouterHelper.getSubscriptionIntroRoute(),
                        child: Text(
                          'إشترك الآن',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
                    borderRadius: const BorderRadius.only(
                      bottomRight: Radius.circular(15),
                      topLeft: Radius.circular(8),
                    ),
                  ),
                  child: ImageView.svgAsset(
                    Assets.assetsDiamond,
                    color: Colors.white,
                    width: 30.sp,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
