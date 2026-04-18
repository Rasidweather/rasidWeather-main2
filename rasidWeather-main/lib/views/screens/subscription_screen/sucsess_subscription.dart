import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../bloc/subscription_cuibt/subscription_cubit.dart';
import '../../../helper/router_helper.dart';

class SuccessSubscriptionScreen extends StatefulWidget {
  const SuccessSubscriptionScreen({super.key});

  @override
  State<SuccessSubscriptionScreen> createState() => _SuccessSubscriptionScreenState();
}

class _SuccessSubscriptionScreenState extends State<SuccessSubscriptionScreen> {
  @override
  void initState() {
    Future<void>.delayed(const Duration(seconds: 5), () => navigateToSplashScreen());
    super.initState();
  }

  Future<void> navigateToSplashScreen() async{
    // await context.read<ProfileCubit>().getProfile();
    RouterHelper.getDashboardRoute('home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<SubscriptionCubit, SubscriptionState>(
        builder: (BuildContext context, SubscriptionState state) {
          if (state is PurchaseSuccess) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 170,
                    padding: const EdgeInsets.all(35),
                    decoration: const BoxDecoration(
                      color: Color(0xFF32567A),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.gpp_good_outlined, color: Colors.white, size: 40),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'subscription.thank_you'.tr(),
                    style: const TextStyle(color: Color(0xFF32567A), fontWeight: FontWeight.w600, fontSize: 36),
                  ),
                  SizedBox(height: 1.h),
                  Text(
                    'subscription.payment_success'.tr(),
                    style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.w400, fontSize: 17),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    'subscription.redirect_to_home'.tr(),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.black54, fontWeight: FontWeight.w400, fontSize: 14),
                  ),
                  SizedBox(height: 6.h),
                  Flexible(
                    child: ElevatedButton(
                      onPressed: () => navigateToSplashScreen(),
                      child: Text(
                        'subscription.back_to_home'.tr(),
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
