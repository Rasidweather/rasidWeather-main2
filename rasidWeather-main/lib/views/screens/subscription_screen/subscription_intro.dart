import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../bloc/splash_cubit/splash_cubit.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../generated/assets.dart';
import '../../../helper/router_helper.dart';
import '../../base/background.dart';

class SubscriptionIntroScreen extends StatefulWidget {
  const SubscriptionIntroScreen({super.key});

  @override
  SubscriptionIntroScreenState createState() => SubscriptionIntroScreenState();
}

class SubscriptionIntroScreenState extends State<SubscriptionIntroScreen> {
  int currentPage = 0;

  void afterIntroComplete() {
    RouterHelper.getSubscriptionRoute(action: RouteAction.pushReplacement);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BlocBuilder<SplashCubit, SplashState>(
        builder: (BuildContext context, SplashState state) {
          return IntroductionScreen(
            controlsPadding: EdgeInsets.only(bottom: 50.h),
            globalBackgroundColor: Colors.white,
            pages: <PageViewModel>[
              ...List<PageViewModel>.generate(IntroModel.intro.length, (
                int index,
              ) {
                return introPage(
                  context,
                  IntroModel.intro[index].topTitle,
                  IntroModel.intro[index].title,
                  IntroModel.intro[index].subtitle,
                  IntroModel.intro[index].image,
                  index,
                );
              }),
            ],
            onDone: () => afterIntroComplete(),
            onSkip: () => afterIntroComplete(),
            onChange: (int i) => setState(() => currentPage = i),
            showSkipButton: currentPage != 5,
            nextFlex: 2,
            skipOrBackFlex: currentPage == 5 ? 0 : 2,
            dotsFlex: 0,
            skip: GestureDetector(
              onTap: () => afterIntroComplete(),
              child: Container(
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'subscription.subscribe_now'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            next: Container(
              height: 40.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Theme.of(context).primaryColor,
              ),
              child: Text(
                'common.next'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
            ),
            done: GestureDetector(
              onTap: () => afterIntroComplete(),
              child: Container(
                height: 40.h,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Theme.of(context).primaryColor,
                ),
                child: Text(
                  'subscription.subscribe_now'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
            dotsDecorator: DotsDecorator(
              size: currentPage == 5 ? Size.zero : const Size(3, 10),
              activeSize: currentPage == 5 ? Size.zero : const Size(3, 20),
              activeColor: Theme.of(context).primaryColor,
              color: Theme.of(context).primaryColor.withOpacity(.5),
              spacing: EdgeInsets.symmetric(
                horizontal: currentPage == 5 ? 0 : 3.0,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          );
        },
      ),
    );
  }
}

PageViewModel introPage(
  BuildContext context,
  String topTitle,
  String title,
  String subtitle,
  String image,
  int index,
) => PageViewModel(
  footer: Padding(
    padding: const EdgeInsets.all(8.0),
    child: Container(
      height: 150.h,
      decoration: BoxDecoration(
        color: const Color(0xffC3EAFF),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.tr(),
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 16.sp,
            ),
          ),
          Text(
            subtitle.tr(),
            maxLines: 3,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    ),
  ),
  titleWidget: Container(
    width: double.infinity,
    alignment: Alignment.center,
    child: Text(
      topTitle,
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w800,
        color: Colors.black,
      ),
    ).tr(),
  ),
  bodyWidget: index == 1
      ? const VideoView()
      : index == 2
      ? const AnimationView()
      : SizedBox(
          height: MediaQuery.of(context).size.height * 0.5,
          child: ImageView.asset(image),
        ),
  decoration: const PageDecoration(
    pageColor: Colors.white,
    bodyTextStyle: TextStyle(
      color: Colors.black54,
      fontSize: 17,
      fontWeight: FontWeight.w500,
    ),
    bodyFlex: 3,
    bodyAlignment: Alignment.center,
  ),
);

class IntroModel {
  IntroModel({
    required this.topTitle,
    required this.title,
    required this.subtitle,
    required this.image,
  });

  final String topTitle;
  final String title;
  final String subtitle;
  final String image;

  static List<IntroModel> intro = <IntroModel>[
    IntroModel(
      topTitle: 'subscription.intro.premium.title',
      title: 'subscription.intro.premium.forecast_title',
      subtitle: 'subscription.intro.premium.forecast_description',
      image: Assets.introImage4,
    ),
    IntroModel(
      topTitle: 'subscription.intro.premium.backgrounds_title',
      title: 'subscription.intro.premium.backgrounds_subtitle',
      subtitle: 'subscription.intro.premium.backgrounds_description',
      image: Assets.introImage5,
    ),
    IntroModel(
      topTitle: 'subscription.intro.premium.icons_title',
      title: 'subscription.intro.premium.icons_subtitle',
      subtitle: 'subscription.intro.premium.icons_description',
      image: Assets.introImage6,
    ),
    IntroModel(
      topTitle: 'subscription.intro.premium.icons_whats',
      title: 'subscription.intro.premium.icons_subtitle_whats',
      subtitle: 'subscription.intro.premium.icons_description_whats',
      image: Assets.whatsApp,
    ),
    IntroModel(
      topTitle: 'subscription.intro.premium.newsletter_title',
      title: 'subscription.intro.premium.newsletter_subtitle',
      subtitle: 'subscription.intro.premium.newsletter_description',
      image: Assets.introImage7,
    ),
    IntroModel(
      topTitle: 'subscription.intro.premium.ads_title',
      title: 'subscription.intro.premium.ads_subtitle',
      subtitle: 'subscription.intro.premium.ads_description',
      image: Assets.introImage8,
    ),
    IntroModel(
      topTitle: 'subscription.intro.premium.consultation_title',
      title: 'subscription.intro.premium.consultation_subtitle',
      subtitle: 'subscription.intro.premium.consultation_description',
      image: Assets.introImage9,
    ),
  ];
}

class AnimationView extends StatelessWidget {
  const AnimationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.sp),
      decoration: const BoxDecoration(
        color: Color(0xff75b1e8),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/mostlyClear-night.json',
                width: 100.sp,
              ),
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/strongStorms.json',
                width: 100.sp,
              ),
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/رياح نشطة مع امطار.json',
                width: 100.sp,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/lightRain-day.json',
                width: 100.sp,
              ),
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/clear-day.json',
                width: 80.sp,
              ),
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/snow-falling.json',
                width: 100.sp,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/frigid.json',
                width: 80.sp,
              ),
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/غائم نهارا مع امطار رعدية.json',
                width: 100.sp,
              ),
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/clear-night.json',
                width: 80.sp,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/cloudy.json',
                width: 100.sp,
              ),
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/windy.json',
                width: 80.sp,
              ),
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/snow.json',
                width: 100.sp,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class VideoView extends StatelessWidget {
  const VideoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 460.h,
      width: MediaQuery.sizeOf(context).width * .8,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      child: const BackgroundVideo(
        video: 'assets/intro/intro-video.mp4',
        isAsset: true,
      ),
    );
  }
}
