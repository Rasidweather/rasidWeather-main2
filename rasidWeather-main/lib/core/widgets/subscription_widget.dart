import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../bloc/profile_cubit/profile_cubit.dart';
import '../../helper/router_helper.dart';
import '../../locator.dart';
import '../../views/base/blur_widget.dart';
import 'image_widget.dart';

class SubscriptionWidget extends StatelessWidget {
  const SubscriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>.value(
      value: sl<ProfileCubit>(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          debugPrint('SubscriptionWidget state: $state');

          // For non-logged in users (ProfileInitial) or errors, show the subscription button
          if (state is ProfileInitial || state is ProfileError) {
            return _buildWeatherDetailsWithButton(context);
          }
          // Handle loading state
          else if (state is ProfileLoading) {
            return const SizedBox.shrink();
          }
          // Handle success state
          else if (state is ProfileSuccess) {
            debugPrint(
              'SubscriptionWidget isVip: ${state.profile.isVip}, isVipChat: ${state.profile.isVipChat}',
            );

            // Show the button if the user is not a VIP
            if (!state.profile.isVip && !state.profile.isVipChat) {
              return _buildWeatherDetailsWithButton(context);
            }

            // If user is VIP or has VIP chat access, show nothing
            return const SizedBox.shrink();
          }

          // Default return if none of the above states match
          return _buildWeatherDetailsWithButton(context);
        },
      ),
    );
  }

  Widget _buildWeatherDetailsWithButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
      child: SizedBox(
        height: 150,
        width: MediaQuery.of(context).size.width * 0.9,
        child: BlurWidget(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'subscription.premium_description'.tr(),
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontSize: 15.sp,
                      color: Colors.black54,
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        minimumSize: Size(130.w, 40.h),
                      ),
                      onPressed: () => RouterHelper.getSubscriptionIntroRoute(),
                      child: Text(
                        'subscription.subscribe_now'.tr(),
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                          color: Colors.black54,
                          fontSize: 15.sp,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              ImageView.lottieLink(
                'https://rasidweather.com/images/svg/lottie/rain.json',
                width: 130.w,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
