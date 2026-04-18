import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/splash_cubit/splash_cubit.dart';
import '../../../common/widgets/app_ui_overlay_style.dart';
import '../../../core/widgets/image_widget.dart';
// 👈 تأكد من المسار حسب مشروعك
import '../../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../../helper/router_helper.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    if (!kDebugMode) {
      // تقدر ترجع تشغّلها لو بدك
      // await context.read<AppCubit>().checkForUpdate();
    }

    // ✅ تهيئة وإرسال / تحديث FCM token مرة واحدة عند بداية التطبيق
    // (عن طريق NotificationsCubit اللي فيه منطق الإرسال)
    await context.read<NotificationsCubit>().initFcmTokenSafelyAndSendToBackend();

    if (!mounted) {
      return;
    }

    // 👇 بعد ما نخلص تهيئة الأشياء (ومنها FCM) نكمل الفلو العادي للسلاش
    context.read<SplashCubit>().afterSplash();
  }

  void _handleNavigation(BuildContext context, SplashState state) {
    if (state is SplashDone) {
      if (!state.isIntroPageDone) {
        RouterHelper.getOnBoardingRoute(
          action: RouteAction.pushNamedAndRemoveUntil,
        );
      } else if (!state.isLanguageSelectionDone) {
        RouterHelper.getLandingScreenRoute();
      } else {
        RouterHelper.getDashboardRoute(
          'home',
          action: RouteAction.pushNamedAndRemoveUntil,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listenWhen: (SplashState previous, SplashState current) =>
      current is SplashDone,
      listener: _handleNavigation,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: AppUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                const _SplashImage(asset: 'assets/logo.png', size: 300),
                const Spacer(),
                const _SplashImage(asset: 'assets/icon.png', size: 100),
                Text(
                  'splash.slogan'.tr(),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                const SizedBox(height: 60),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SplashImage extends StatelessWidget {
  const _SplashImage({required this.asset, required this.size});

  final String asset;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: ImageView.asset(asset),
      ),
    );
  }
}
