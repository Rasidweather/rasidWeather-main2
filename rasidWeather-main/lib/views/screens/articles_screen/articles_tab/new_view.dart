import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../bloc/articles_cubit/articles_cubit.dart';
import '../../../../common/constants/strings.dart';
import '../../../../data/model/article_model.dart';
import '../../../../data/model/category_model.dart';
import '../../../../features/ads/presentation/services/ads_service.dart';
import '../../../../features/cities/data/models/city_model.dart';
import '../../../../features/cities/presentation/cubit/cities_cubit.dart';
import '../../../../locator.dart';
import '../../../../utils/ui_utils.dart';
import '../../../base/index.dart';
import '../cards/index.dart';

class ContentNewsTab extends StatefulWidget {
  const ContentNewsTab({super.key, required this.selectedCategory});

  final CategoryModel selectedCategory;

  @override
  ContentNewsTabState createState() => ContentNewsTabState();
}

class ContentNewsTabState extends State<ContentNewsTab> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final RefreshController _refreshController = RefreshController();
  // final AdManager _adManager = AdManager();

  List<ArticleModel> articles = <ArticleModel>[];
  int _currentPage = 1;
  bool _isLastPage = false;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      _initData();
    }
  }

  @override
  void dispose() {
    _refreshController.dispose();
    // _adManager.dispose();
    super.dispose();
  }

  Future<void> _initData() async {
    final CityModel? city = await context.read<CitiesCubit>().getSelectedCity();
    if (city != null) {
      await _fetchArticles(refresh: true);
    }
  }

  Future<void> _fetchArticles({bool refresh = false}) async {
    await context.read<ArticlesBloc>().getArticles(
      categories: widget.selectedCategory.id,
      countryCode:
          (await context.read<CitiesCubit>().getSelectedCity())?.countryCode,
      currentPage: refresh ? 1 : _currentPage,
      refresh: refresh,
    );
  }

  Widget _buildLoadingItem(int index) {
    final List<double> heights = <double>[200.0, 160.0, 140.0, 140.0];
    return LoadingCard(height: heights[index.clamp(0, heights.length - 1)]);
  }

  /// حساب العدد الإجمالي للعناصر بما في ذلك الإعلانات
  int _calculateTotalItemCount() {
    if (articles.isEmpty) return 0;

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

  Widget _buildArticleItem(int index) {
    if (index >= articles.length) {
      return const SizedBox(height: 15);
    }

    final ArticleModel article = articles[index];
    if (index == 0) {
      return Column(
        children: <Widget>[
          Card1(article: article, heroTag: article.id!),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.bottomCenter,
            child: FutureBuilder<Widget>(
              future: sl<AdsService>().getBannerAd(),
              builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!;
                }
                return const SizedBox();
              },
            ),
          ),
          // _adManager.bannerAd,
          const SizedBox(height: 10),
        ],
      );
    }

    return index == 1
        ? Card3(article: article, heroTag: article.id)
        : Card4(article: article);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Expanded(
          child: BlocConsumer<ArticlesBloc, ArticlesState>(
            listener: (BuildContext context, ArticlesState state) {
              if (state is ArticlesError) {
                showSnackBar(context, state.error, color: Colors.red);
              } else if (state is ArticlesSuccess) {
                articles = state.articles;
                _isLastPage = state.isLastPage;
              }
            },
            builder: (BuildContext context, ArticlesState state) {
              if (state is ArticlesLoading && state.refresh) {
                return SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      ListView.separated(
                        key: const PageStorageKey<String>('loading'),
                        padding: const EdgeInsets.all(15),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: 4,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        shrinkWrap: true,
                        itemBuilder: (_, int index) => _buildLoadingItem(index),
                      ),
                    ],
                  ),
                );
              }

              return SmartRefresher(
                controller: _refreshController,
                enablePullUp: true,
                header: const WaterDropHeader(),
                footer: CustomFooter(
                  builder: (BuildContext context, LoadStatus? mode) {
                    if (mode == LoadStatus.loading) {
                      return const LoadingCard(height: 120);
                    }

                    final Map<LoadStatus, String> messages =
                        <LoadStatus, String>{
                          LoadStatus.idle: 'اسحب لتحميل المزيد',
                          LoadStatus.failed: 'فشل في التحميل',
                          LoadStatus.noMore: 'لا مزيد من العناصر',
                        };

                    return Center(child: Text(messages[mode] ?? ''));
                  },
                ),
                onLoading: () async {
                  if (_isLastPage) {
                    _refreshController.loadNoData();
                  } else {
                    _currentPage++;
                    await _fetchArticles();
                    _refreshController.loadComplete();
                  }
                },
                onRefresh: () async {
                  _currentPage = 1;
                  await _fetchArticles(refresh: true);
                  _refreshController.refreshCompleted();
                },
                child: articles.isNotEmpty
                    ? ListView.builder(
                        key: const PageStorageKey<String>('articles'),
                        padding: const EdgeInsets.all(15),
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _calculateTotalItemCount(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          // إضافة إعلان أصلي بعد كل 10 عناصر
                          if (index > 0 &&
                              index % 11 == 10 &&
                              !AppStrings.isVip &&
                              !AppStrings.isVipChat) {
                            // عرض إعلان أصلي
                            return Column(
                              children: <Widget>[
                                const SizedBox(height: 10),
                                FutureBuilder<Widget>(
                                  future: sl<AdsService>().getBannerAd(),
                                  builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                                    if (snapshot.hasData) {
                                      return snapshot.data!;
                                    }
                                    return const SizedBox();
                                  },
                                ),
                                const SizedBox(height: 10),
                              ],
                            );
                          }

                          // حساب الفهرس الفعلي للمقال بعد طرح الإعلانات
                          final int articleIndex = _getActualArticleIndex(
                            index,
                          );
                          return Column(
                            children: <Widget>[
                              _buildArticleItem(articleIndex),
                              const SizedBox(height: 10),
                            ],
                          );
                        },
                      )
                    : const EmptyWidget(
                        icon: Icons.article_outlined,
                        message1: 'هذا القسم فارغ حتى الان',
                        message: 'لا توجد مقالات',
                      ),
              );
            },
          ),
        ),
      ],
    );
  }
}
