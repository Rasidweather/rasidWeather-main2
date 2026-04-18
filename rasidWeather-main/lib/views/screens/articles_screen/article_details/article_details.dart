import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../bloc/articles_cubit/articles_cubit.dart';
import '../../../../bloc/profile_cubit/profile_cubit.dart';
import '../../../../common/constants/index.dart';
import '../../../../core/widgets/back_button.dart';
import '../../../../core/widgets/gallery_widget.dart';
import '../../../../core/widgets/image_widget.dart';
import '../../../../data/model/article_model.dart';
import '../../../../data/model/comment_model.dart';
import '../../../../features/ads/presentation/services/ads_service.dart';
import '../../../../generated/assets.dart';
import '../../../../helper/router_helper.dart';
import '../../../../locator.dart';
import '../../../../utils/ui_utils.dart';
import '../../../../utils/utils.dart';
import '../../../base/index.dart';
import '../../../base/loading_page.dart';
import '../../../base/native_ad_widget.dart';
import '../articles_components/index.dart';
import 'comments/add_comment_widget.dart';
import 'comments/comment_item.dart';

class ArticleDetails extends StatefulWidget {
  const ArticleDetails({
    super.key,
    required this.tag,
    required this.articleId,
    this.deepLink = false,
  });

  final String articleId;
  final String tag;
  final bool deepLink;

  @override
  ArticleDetailsState createState() => ArticleDetailsState();
}

class ArticleDetailsState extends State<ArticleDetails> {
  double rightPaddingValue = 10;
  // final AdManager _adManager = AdManager();
  bool viewPremiumDialog = false;

  @override
  void initState() {
    getData();
    sl<AdsService>().showInterstitialAd();
    super.initState();
  }

  @override
  void dispose() {
    // _adManager.dispose();
    super.dispose();
  }

  Future<void> getData() async {
    Future<void>.delayed(Duration.zero, () async {
      // if (widget.deepLink) {
      //   await context.read<ProfileCubit>().getProfile();
      // }
      await context.read<ArticlesBloc>().getArticleDetails(widget.articleId);
      await context.read<ArticlesBloc>().getArticleComments(widget.articleId);
    });
  }

  Widget _authorWidget(ArticleModel article) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundImage: NetworkImage(article.author!.avatar!.original!),
      ),
      title: Text(
        article.author!.name!,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w600,
          color: const Color(0xff3d3d3d),
        ),
      ),
      subtitle: Text(
        'articles.author'.tr(),
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w400,
          color: const Color(0xff3d3d3d),
        ),
      ),
      trailing: SizedBox(
        width: MediaQuery.sizeOf(context).width / 2,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            // TODO(mohamedSleem): add comment feature later.
            Row(
              children: <Widget>[
                ImageView.svgAsset(Assets.svgComment, width: 15.w),
                Text(article.countComments.toString()),
              ],
            ),
            Row(
              children: <Widget>[
                ImageView.svgAsset(Assets.svgLoveBoard, width: 15.w),
                Text(article.countLikes.toString()),
              ],
            ),
            _articleDate(context, article),
          ],
        ),
      ),
    );
  }

  Widget _buildSourceButton(ArticleModel d) {
    return d.source == null || d.source!.isEmpty || d.source == 'null'
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(4.0),
            child: InkWell(
              child: const Icon(FeatherIcons.externalLink),
              onTap: () async => launchURLTap(context, d.source!),
            ),
          );
  }

  Widget _buildShareButton(String articleId) {
    final String url = 'https://rasidweather.com/article/$articleId';
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: InkWell(
        child: const Icon(FeatherIcons.share2),
        onTap: () async => Share.share(url),
      ),
    );
  }

  Widget _buildLikeButton(ArticleModel d) {
    return IconButton(
      onPressed: () async {
        final bool isLoggedIn = await context.read<ProfileCubit>().isLoggedIn();
        if (!isLoggedIn) {
          await openSignInDialog();
        } else {
          if (!context.mounted) {
            return;
          }
          await context.read<ArticlesBloc>().lovedArticle(
            like: !d.isLiked!,
            articleId: d.id!,
          );
          await getData();
        }
      },
      icon: ImageView.svgAsset(
        d.isLiked! ? Assets.svgLove : Assets.svgLoveBoard,
      ),
    );
  }

  Widget _buildBookmarkButton(ArticleModel d, BuildContext context) {
    return IconButton(
      onPressed: () async {
        final bool isLoggedIn = await context.read<ProfileCubit>().isLoggedIn();
        if (!isLoggedIn) {
          await openSignInDialog();
        } else {
          if (!context.mounted) {
            return;
          }
          await context.read<ArticlesBloc>().bookmarkedArticle(
            favorite: !d.hasFavorited!,
            articleId: d.id!,
          );
          await getData();
        }
      },
      icon: ImageView.svgAsset(
        d.hasFavorited! ? Assets.svgBookmark : Assets.svgBookmarkBoard,
      ),
    );
  }

  Widget _addCommentWidget() {
    // Show the comment widget if:
    // 1. Article exists AND
    // 2. Either the article is not premium/featured OR the user is a premium user
    if (article != null &&
        (!viewPremiumDialog || AppStrings.isVip || AppStrings.isVipChat)) {
      return AddCommentWidget(
        article: article!,
        openSignInDialog: () {
          showDialog<Widget>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('تسجيل الدخول'),
              content: const Text('يجب تسجيل الدخول لإضافة تعليق'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    RouterHelper.getLoginRoute();
                  },
                  child: const Text('تسجيل الدخول'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
              ],
            ),
          );
        },
        viewPremiumDialog: () {
          showDialog<Widget>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text('ميزة مدفوعة'),
              content: const Text('هذه الميزة متاحة فقط للمشتركين'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    RouterHelper.getSubscriptionIntroRoute();
                  },
                  child: const Text('اشترك الآن'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('إلغاء'),
                ),
              ],
            ),
          );
        },
      );
    }
    return const SizedBox.shrink();
  }

  ArticleModel? article;
  List<CommentModel>? comments;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // This is the key to keyboard management
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _addCommentWidget(),
      body: WillPopScope(
        onWillPop: () async {
          await sl<AdsService>().showInterstitialAd();
          // _adManager.showInterstitialAd();
          return true;
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
          child: AppUiOverlayStyle(
            systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
            child: BlocConsumer<ArticlesBloc, ArticlesState>(
              listener: (BuildContext context, ArticlesState state) {
                if (state is ArticleDetailsSuccess) {
                  article = state.articleDetails;
                  viewPremiumDialog =
                      state.articleDetails.isFeatured ||
                      state.articleDetails.isPremium! &&
                          (!AppStrings.isVip || !AppStrings.isVipChat);
                  setState(() {});
                }
              },
              builder: (BuildContext context, ArticlesState state) {
                printLog('ArticleDetailsState: $state');
                if (state is ArticleDetailsLoading) {
                  if (article == null) {
                    return const LoadingPage();
                  }
                }
                if (state is ArticleDetailsError) {
                  return EmptyWidget(
                    icon: FeatherIcons.alertTriangle,
                    message: 'حدث خطأ ما',
                    message1: state.error,
                    back: true,
                    onTap: () => getData(),
                  );
                }
                // if (state is ArticleDetailsSuccess) {
                //   ArticleModel d = state.articleDetails;
                if (article == null) {
                  return EmptyWidget(
                    icon: FeatherIcons.alertTriangle,
                    message: 'حدث خطأ ما',
                    message1: '',
                    back: true,
                    onTap: () => getData(),
                  );
                }
                return SafeArea(
                  top: false,
                  maintainBottomViewPadding: true,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Expanded(
                            child: CustomScrollView(
                              slivers: <Widget>[
                                SliverAppBar(
                                  pinned: true,
                                  leading: AdaptiveBackButton(
                                    onPressed: () async {
                                      if (widget.deepLink) {
                                        RouterHelper.getDashboardRoute('home');
                                      } else {
                                        Navigator.pop(context);
                                      }
                                      await sl<AdsService>()
                                          .showInterstitialAd();
                                      // _adManager.showInterstitialAd();
                                    },
                                  ),
                                  actions: <Widget>[
                                    _buildShareButton(article!.id.toString()),
                                    _buildSourceButton(article!),
                                    _buildLikeButton(article!),
                                    _buildBookmarkButton(article!, context),
                                    if (article!.categories!.isNotEmpty)
                                      Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(
                                            5,
                                          ),
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.primary,
                                        ),
                                        child: AnimatedPadding(
                                          duration: const Duration(
                                            milliseconds: 1000,
                                          ),
                                          padding: EdgeInsets.only(
                                            left: 10,
                                            right: rightPaddingValue,
                                          ),
                                          child: Text(
                                            article!.categories!.first.title!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .displayMedium!
                                                .copyWith(
                                                  fontSize: 15,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                          ),
                                        ),
                                      ),
                                    SizedBox(width: 15.w),
                                  ],
                                ),
                                SliverToBoxAdapter(
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                          MaterialPageRoute<void>(
                                            builder: (BuildContext context) => GalleryWidget(
                                              galleryItems: <GalleryImage>[
                                                GalleryImage(
                                                  image: article!.mainImage!.original!,
                                                  id: article.hashCode,
                                                ),
                                              ],
                                            ),
                                          )

                                      );
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.sizeOf(context).height *
                                          .25,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        image: DecorationImage(
                                          image: NetworkImage(
                                            article!.mainImage!.original!,
                                          ),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(
                                        left: 13,
                                        right: 13,
                                        top: 10,
                                        bottom: 10,
                                      ),
                                    ),
                                  ),
                                ),
                                SliverToBoxAdapter(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                        ),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            if (article!.author != null)
                                              _authorWidget(article!),
                                            const SizedBox(height: 5),
                                            Text(
                                              article!.title!,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                fontWeight: FontWeight.w400,
                                                color: const Color(0xff3D3C3C),
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                              Align(
                                                child: FutureBuilder<Widget>(
                                                  future: sl<AdsService>()
                                                    .getBannerAd(),
                                                  builder:
                                                      (
                                                        BuildContext context,
                                                        AsyncSnapshot<Widget>
                                                        snapshot,
                                                      ) {
                                                        if (snapshot.hasData) {
                                                          return snapshot.data!;
                                                        }
                                                        return const SizedBox();
                                                      },
                                                ),
                                              ),
                                            // _adManager.bannerAd..adSize,
                                            const SizedBox(height: 20),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                bottom: 40.h,
                                              ),
                                              child: AppHtmlView(
                                                html:
                                                    '''${article!.description}''',
                                              ),
                                            ),
                                            const SizedBox(height: 20),
                                            // إضافة إعلان أصلي بعد محتوى المقال
                                            if (!AppStrings.isVip &&
                                                !AppStrings.isVipChat)
                                              const Center(
                                                child: Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    vertical: 10,
                                                  ),
                                                  child: NativeAdWidget(),
                                                ),
                                              ),
                                            const SizedBox(height: 10),
                                          ],
                                        ),
                                      ),
                                      BlocConsumer<ArticlesBloc, ArticlesState>(
                                        listener:
                                            (
                                              BuildContext context,
                                              ArticlesState state,
                                            ) {
                                              if (state
                                                  is UpdateCommentSuccess) {
                                                comments!.removeWhere(
                                                  (CommentModel element) =>
                                                      element.id ==
                                                      state.comment.id,
                                                );
                                                comments!.insert(
                                                  0,
                                                  state.comment,
                                                );
                                              }
                                              if (state is AddCommentSuccess) {
                                                comments!.insert(
                                                  0,
                                                  state.comment,
                                                );
                                              }
                                              if (state
                                                  is DeleteCommentSuccess) {
                                                comments!.removeWhere(
                                                  (CommentModel element) =>
                                                      element.id ==
                                                      state.commentId,
                                                );
                                              }
                                              if (state is AddCommentError) {
                                                showSnackBar(
                                                  context,
                                                  state.error,
                                                  color: Colors.red,
                                                );
                                              }
                                              if (state
                                                  is ArticleCommentsSuccess) {
                                                comments = state.comments;
                                              }
                                            },
                                        builder: (BuildContext context, ArticlesState state) {
                                          if (state is ArticleCommentsLoading) {
                                            if (state.loading) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                          } else if (state
                                              is ArticleCommentsError) {
                                            return Center(
                                              child: Text(state.error),
                                            );
                                          }
                                          if (comments != null &&
                                              comments!.isNotEmpty) {
                                            return Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(
                                                    'articles.comments.title'
                                                        .tr(),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                ...List<Widget>.generate(
                                                  comments!.length,
                                                  (int index) {
                                                    return CommentItem(
                                                      comment: comments![index],
                                                    );
                                                  },
                                                ),
                                                if (comments!.length > 5)
                                                  ElevatedButton(
                                                    onPressed: () =>
                                                        RouterHelper.getArticleComments(
                                                          article!.id!,
                                                        ),
                                                    child: Text(
                                                      'articles.comments.load_more'
                                                          .tr(),
                                                    ),
                                                  ),
                                              ],
                                            );
                                          } else {
                                            return Column(
                                              children: <Widget>[
                                                ListTile(
                                                  title: Text(
                                                    'articles.comments.title'
                                                        .tr(),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20,
                                                    ),
                                                  ),
                                                ),
                                                const Padding(
                                                  padding: EdgeInsets.all(16.0),
                                                  child: Text(
                                                    'لا يوجد تعليقات',
                                                  ),
                                                ),
                                              ],
                                            );
                                          }
                                        },
                                      ),
                                      if (article!.categories!.isNotEmpty)
                                        BlocProvider<ArticlesBloc>(
                                          create: (BuildContext context) =>
                                              sl<ArticlesBloc>()..getArticles(
                                                categories: article!
                                                    .categories!
                                                    .first
                                                    .id,
                                              ),
                                          child: RelatedArticles(
                                            category:
                                                article!.categories!.first.id!,
                                            replace: true,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      if (viewPremiumDialog && !AppStrings.isVip)
                        BlurryContainer(
                          child: Dialog(
                            backgroundColor: Theme.of(
                              context,
                            ).colorScheme.primary,
                            insetPadding: EdgeInsets.zero,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  'هذه مقاله مميزه',
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(color: Colors.white),
                                ),
                                Text(
                                  'اشترك لتتمكن من قراءتها',
                                  style: Theme.of(context).textTheme.bodyLarge!
                                      .copyWith(color: Colors.white),
                                ),
                                const SizedBox(height: 8.0),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(160.w, 30.h),
                                    backgroundColor: Theme.of(
                                      context,
                                    ).secondaryHeaderColor,
                                  ),
                                  onPressed: () =>
                                      RouterHelper.getSubscriptionIntroRoute(),
                                  child: Text(
                                    'إشترك الآن',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: Size(160.w, 30.h),
                                    backgroundColor: Colors.redAccent.shade100,
                                  ),
                                  onPressed: () async {
                                    if (widget.deepLink) {
                                      // await context.read<ProfileCubit>().getProfile();
                                      RouterHelper.getDashboardRoute('home');
                                    } else {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text(
                                    'الغاء',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium!
                                        .copyWith(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _articleDate(BuildContext context, ArticleModel? d) {
    return Row(
      children: <Widget>[
        ImageView.svgAsset(Assets.svgCalender),
        const SizedBox(width: 5),
        Text(
          dateTimeToTimeAgo(d!.createdAt!),
          style: Theme.of(
            context,
          ).textTheme.displayMedium!.copyWith(fontSize: 12),
        ),
      ],
    );
  }
}
