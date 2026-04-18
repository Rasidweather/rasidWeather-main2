import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/profile_cubit/profile_cubit.dart';
import '../../features/auth/presentation/screens/login_screen.dart'; // لو عندك route جاهز استخدمه بدل الـ Screen
import '../../helper/router_helper.dart'; // لو بتستخدم المسارات من RouterHelper

/// بوابة تفحص إذا المستخدم مسجل دخول.
/// - لو مسجل دخول: تعرض الـ child.
/// - لو مش مسجل: تنقله لصفحة تسجيل الدخول أو تعرض LoginScreen inline (اختَر السلوك المناسب).
class LoginGate extends StatelessWidget { // true: يوجّه بالرواتر / false: يعرض LoginScreen مكان الـ child

  const LoginGate({
    super.key,
    required this.child,
    this.pushToRoute = true,
  });
  final Widget child;
  final bool pushToRoute;

  @override
  Widget build(BuildContext context) {
    final ProfileState state = context.watch<ProfileCubit>().state;
    final bool isLoggedIn = state is ProfileSuccess && state.profile.id != null;

    if (isLoggedIn) return child;

    // المستخدم غير مسجل دخول
    if (pushToRoute) {
      // وجّهه لصفحة اللوجين عبر go_router
      // استعمل مسارك المركزي لو عندك:
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted) {
          context.go(RouterHelper.loginScreen);
          // أو:
          // RouterHelper.getLoginRoute(action: RouteAction.pushNamedAndRemoveUntil);
        }
      });
      // اعرض شاشة انتظار خفيفة لحين الانتقال
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      // بدلاً من التوجيه، اعرض شاشة اللوجين داخل نفس المكان
      return const LoginScreen();
    }
  }
}
