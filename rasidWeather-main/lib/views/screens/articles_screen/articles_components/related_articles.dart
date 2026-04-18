import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../bloc/articles_cubit/articles_cubit.dart';
import '../../../../common/constants/strings.dart';
import '../../../../common/widgets/app_hedline.dart';
import '../../../../features/ads/presentation/services/ads_service.dart';
import '../../../../locator.dart';
import '../../../base/index.dart';
import '../cards/index.dart';

class RelatedArticles extends StatefulWidget {
  const RelatedArticles({
    super.key,
    required this.category,
    required this.replace,
  });
  final String category;
  final bool replace;

  @override
  RelatedArticlesState createState() => RelatedArticlesState();
}

class RelatedArticlesState extends State<RelatedArticles> {
  @override
  void initState() {
    context.read<ArticlesBloc>().getArticles(categories: widget.category);
    super.initState();
  }

  /// حساب العدد الإجمالي للعناصر بما في ذلك الإعلانات
  int _calculateTotalItemCount(List<dynamic> articles) {
    if (articles.isEmpty) return 1; // لعرض رسالة فارغة

    // عدد المقالات + عدد الإعلانات (إعلان واحد لكل 10 مقالات)
    final int adCount = AppStrings.isVip || AppStrings.isVipChat
        ? 0
        : (articles.length / 10).floor();
    return articles.length + adCount;
  }

  /// حساب فهرس المقال الفعلي بعد طرح الإعلانات
  int _getActualArticleIndex(int index) {
    // عدد الإعلانات قبل هذا الفهرس
    final int adsBeforeIndex = (index / 11).floor();
    return index - adsBeforeIndex;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArticlesBloc, ArticlesState>(
      builder: (BuildContext context, ArticlesState state) {
        if (state is ArticlesLoading) {
          return SizedBox(
            height: 200,
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (BuildContext context, int index) {
                return const LoadingCard();
              },
            ),
          );
        }
        if (state is ArticlesSuccess) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Divider(),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10),
                child: AppHeadline(
                  headlineTitle: 'articles.youMightAlsoLike'.tr(),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: const EdgeInsets.only(top: 15, bottom: 15),
                  shrinkWrap: true,
                  itemCount: _calculateTotalItemCount(state.articles),
                  itemBuilder: (BuildContext context, int index) {
                    // إضافة إعلان أصلي بعد كل 10 عناصر
                    if (index > 0 &&
                        index % 11 == 10 &&
                        !AppStrings.isVip &&
                        !AppStrings.isVipChat) {
                      // عرض إعلان أصلي
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: FutureBuilder<Widget>(
                          future: sl<AdsService>().getBannerAd(),
                          builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                            if (snapshot.hasData) {
                              return snapshot.data!;
                            }
                            return const SizedBox();
                          },
                        ),
                      );
                    }

                    // حساب الفهرس الفعلي للمقال بعد طرح الإعلانات
                    final int articleIndex = _getActualArticleIndex(index);

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Card3(
                        article: state.articles[articleIndex],
                        heroTag: '',
                        replace: true,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 60),
            ],
          );
        }
        return Container();
      },
    );
  }
}
