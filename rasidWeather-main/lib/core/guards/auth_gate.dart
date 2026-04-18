import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../bloc/profile_cubit/profile_cubit.dart';
import '../../helper/router_helper.dart';

/// gate بسيطة: لو المستخدم مش مسجّل → توديه على /login وتوقف البناء
class AuthGate extends StatelessWidget { // مسار نرجع له بعد تسجيل الدخول (اختياري)

  const AuthGate({super.key, required this.child, this.returnTo});
  final Widget child;
  final String? returnTo;

  @override
  Widget build(BuildContext context) {
    final ProfileState state = context.watch<ProfileCubit>().state;

    // لو عندك ProfileSuccess(user) لما المستخدم يكون مسجل
    final bool isLoggedIn = state is ProfileSuccess && state.profile.id != null;


    if (isLoggedIn) return child;

    // رحّل المستخدم للّوجين مرّة وحدة بعد بناء الإطار
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // لو بدك ترجّعه لنفس الشاشة بعد اللوجين، مرّر returnTo كـ query
      final String to = returnTo ?? GoRouterState.of(context).uri.toString();
      context.push('${RouterHelper.loginScreen}?return=$to');
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
