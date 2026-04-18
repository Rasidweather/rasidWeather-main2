import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:introduction_screen/introduction_screen.dart';

import '../../../bloc/splash_cubit/splash_cubit.dart';
import '../../../common/widgets/app_ui_overlay_style.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../generated/assets.dart';
import '../../../helper/router_helper.dart';


class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  OnBoardingScreenState createState() => OnBoardingScreenState();
}

class OnBoardingScreenState extends State<OnBoardingScreen> {
  void afterIntroComplete() {
    context.read<SplashCubit>().setIntroPageDone();
  }

  @override
  Widget build(BuildContext context) {
    return AppUiOverlayStyle(
      isDark: false,
      child: BlocConsumer<SplashCubit, SplashState>(
        listener: (BuildContext context, SplashState state) {
          if (state is IntroDone) {
            // Navigate to language selection screen after intro is done
            RouterHelper.getLandingScreenRoute();
          }
        },
        builder: (BuildContext context, SplashState state) {
          return IntroductionScreen(
            controlsPadding: EdgeInsets.only(bottom: 50.h),
            globalBackgroundColor: Colors.white,
            pages: <PageViewModel>[
              introPage(
                context,
                'intro.page1.title',
                'intro.page1.description',
                Assets.introImage1,
              ),
              introPage(
                context,
                'intro.page2.title',
                'intro.page2.description',
                Assets.introImage2,
              ),
              introPage(
                context,
                'intro.page3.title',
                'intro.page3.description',
                Assets.introImage3,
              ),
            ],
            showSkipButton: true,
            skip: Text(
              'intro.skip'.tr(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            next: Text(
              'intro.next'.tr(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            onDone: () {
              afterIntroComplete();
            },
            onSkip: () {
              afterIntroComplete();
            },
            animationDuration: 1000,
            done: Text(
              'intro.done'.tr(),
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 16.sp,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
            dotsDecorator: DotsDecorator(
              size: const Size(3, 10),
              activeSize: const Size(3, 20),
              activeColor: Colors.black,
              color: Colors.black26,
              spacing: const EdgeInsets.symmetric(horizontal: 3.0),
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

PageViewModel introPage(BuildContext context, String title, String subtitle, String image) {
  return PageViewModel(
    titleWidget: SizedBox(
      width: double.infinity,
      child: Text(
        title.tr(),
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: Colors.black,
        ),
      ),
    ),
    body: subtitle.tr(),
    image: Center(child: ImageView.svgAsset(image)),
    decoration: const PageDecoration(
      pageColor: Colors.white,
      bodyTextStyle: TextStyle(
        color: Colors.black54,
        fontSize: 17,
        fontWeight: FontWeight.w500,
      ),
      imageFlex: 3,
      bodyAlignment: Alignment.centerRight,
    ),
  );
}
