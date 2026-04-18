// // lib/core/guards/premium_gate.dart
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:go_router/go_router.dart';
//
// import '../../bloc/profile_cubit/profile_cubit.dart';
// import '../../bloc/subscription_cuibt/subscription_cubit.dart';
// import '../../features/auth/presentation/screens/login_screen.dart';
// import '../../views/screens/subscription_screen/subscription_intro.dart';
//
// class PremiumGate extends StatelessWidget {
//   const PremiumGate({
//     super.key,
//     required this.child,
//     this.entitlementId = 'premium', // غيرها لو اسم الصلاحية مختلف
//     this.showScreensInsteadOfNavigate = true,
//   });
//
//   /// الواجهة المحمية (تظهر لو المستخدم مشترك)
//   final Widget child;
//
//   /// معرف الصلاحية في RevenueCat
//   final String entitlementId;
//
//   /// لو true نعرض Login/Intro كواجهات داخلية،
//   /// لو false نوجّه بالراوتر (go) بدل العرض المباشر.
//   final bool showScreensInsteadOfNavigate;
//
//   @override
//   Widget build(BuildContext context) {
//     // 1) فحص حالة تسجيل الدخول
//     final profileState = context.watch<ProfileCubit>().state;
//     final bool isLoggedIn =
//         profileState is ProfileSuccess && profileState.profile.id != null;
//
//     if (!isLoggedIn) {
//       if (showScreensInsteadOfNavigate) {
//         // نعرض شاشة تسجيل الدخول مباشرةً
//         return const LoginScreen();
//       } else {
//         // توجيه: login
//         WidgetsBinding.instance.addPostFrameCallback((_) {
//           context.go('/login');
//         });
//         return const SizedBox.shrink();
//       }
//     }
//
//     // 2) فحص الاشتراك عبر RevenueCat
//     return FutureBuilder<bool>(
//       // future: context
//       //     .read<SubscriptionCubit>()
//       //     .hasActiveEntitlement(entitlementId),
//       // builder: (context, snap) {
//       //   if (snap.connectionState != ConnectionState.done) {
//       //     return const Scaffold(
//       //       body: Center(child: CircularProgressIndicator()),
//       //     );
//         }
//
//         final bool entitled = snap.data == true;
//
//         if (entitled) {
//           // مشترك → أعرض المحتوى
//           return child;
//         } else {
//           if (showScreensInsteadOfNavigate) {
//             // أعرض واجهة الاشتراكات (باقة/شراء)
//             return const SubscriptionIntroScreen();
//           } else {
//             // أو وجّه لواجهة الاشتراك
//             WidgetsBinding.instance.addPostFrameCallback((_) {
//               context.go('/subscription-intro-screen');
//             });
//             return const SizedBox.shrink();
//           }
//         }
//       },
//     );
//   }
// }
