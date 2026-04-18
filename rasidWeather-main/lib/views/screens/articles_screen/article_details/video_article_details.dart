import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../../../../bloc/articles_cubit/articles_cubit.dart';
import '../../../../common/constants/strings.dart';
import '../../../../common/widgets/app_ui_overlay_style.dart';
import '../../../../data/model/article_model.dart';
import '../../../../features/ads/presentation/services/ads_service.dart';
import '../../../../locator.dart';
import '../../../base/cached_image.dart';

class VideoArticleDetails extends StatefulWidget {
  const VideoArticleDetails({super.key, required this.article, required this.tag, required this.articleId, required this.deepLink});

  final ArticleModel? article;
  final String articleId;
  final String tag;
  final bool deepLink;

  @override
  VideoArticleDetailsState createState() => VideoArticleDetailsState();
}

class VideoArticleDetailsState extends State<VideoArticleDetails> {
  double rightPaddingValue = 10;
  late YoutubePlayerController _controller;
  ArticleModel? d;

  @override
  void initState() {
    getData();
    initYoutube();
    super.initState();
  }

  Future<void> getData() async {
    if (widget.article == null) {
      context.read<ArticlesBloc>().getArticleDetails(widget.articleId);
    } else {
      d = widget.article;
      context.read<ArticlesBloc>().getArticleDetails(widget.article!.id!);
    }
  }

  Future<void> initYoutube() async {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(d!.videoUrl!)!,
      flags: const YoutubePlayerFlags(autoPlay: false, loop: true, enableCaption: false),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: Key(d!.id!),
      body: PopScope(
        onPopInvoked: (bool didPop) async {
          if (!didPop) {
            await sl<AdsService>().showInterstitialAd();
            Navigator.pop(context);
          }
        },
        child: BlocConsumer<ArticlesBloc, ArticlesState>(
          listener: (BuildContext context, ArticlesState state) {
            if (state is ArticleDetailsSuccess) {
              setState(() => d = state.articleDetails);
            }
          },
          builder: (BuildContext context, ArticlesState state) {
            return AppUiOverlayStyle(
              systemNavigationBarColor: Theme.of(context).scaffoldBackgroundColor,
              child: SafeArea(
                bottom: false,
                child: YoutubePlayerBuilder(
                  player: YoutubePlayer(
                    showVideoProgressIndicator: true,
                    progressIndicatorColor: Theme.of(context).primaryColor,
                    progressColors: ProgressBarColors(playedColor: Theme.of(context).primaryColor, handleColor: Theme.of(context).primaryColor),
                    controller: _controller,
                    thumbnail: Hero(tag: widget.tag, child: CustomCacheImage(imageUrl: d!.mainImage!.main!, radius: 0)),
                    onReady: () {},
                  ),
                  builder: (BuildContext context, Widget player) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        player,
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            d!.title ?? '',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            d!.description ?? '',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ),
                        const SizedBox(height: 20),
                        
                        // إضافة إعلان أصلي بعد محتوى الفيديو
                        if (!AppStrings.isVip && !AppStrings.isVipChat)
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
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
                      ],
                    );
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void deactivate() {
    _controller.pause();
    super.deactivate();
  }
}
