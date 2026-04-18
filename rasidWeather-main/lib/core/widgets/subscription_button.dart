import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/profile_cubit/profile_cubit.dart';
import '../../helper/router_helper.dart';
import '../../locator.dart';
import '../../views/base/custom_button.dart';

class SubscriptionButton extends StatelessWidget {
  const SubscriptionButton({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileCubit>.value(
      value: sl<ProfileCubit>(),
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (BuildContext context, ProfileState state) {
          debugPrint('SubscriptionButton status: $state');

          final bool isUserLoggedIn = state is ProfileSuccess;

          // Handle initial state - show the button by default
          if (state is ProfileInitial) {
            debugPrint('SubscriptionButton status: Initial state');
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: AdaptiveButton(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.orange.shade500,
                    Colors.yellow.shade600,
                  ],
                ),
                radius: 50,
                width: 110,
                height: 30,
                isShimmer: true,
                onTap: () => RouterHelper.getSubscriptionIntroRoute(),
                label: 'subscription.subscribe'.tr(),
              ),
            );
          }
          // Handle loading state
          else if (state is ProfileLoading) {
            return const SizedBox.shrink();
          }
          // Handle error state
          else if (state is ProfileError) {
            // Show the subscription button if there is an error
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: AdaptiveButton(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.orange.shade500,
                    Colors.yellow.shade600,
                  ],
                ),
                radius: 50,
                width: 110,
                height: 30,
                isShimmer: true,
                onTap: () => RouterHelper.getSubscriptionIntroRoute(),
                label: 'subscription.subscribe'.tr(),
              ),
            );
          }
          // Handle success state
          else if (state is ProfileSuccess) {
            debugPrint(
              'SubscriptionButton status: isVip ${state.profile.isVip}, isVipChat: ${state.profile.isVipChat}',
            );

            // Show the subscription button if the user is not a VIP
            if (isUserLoggedIn &&
                (!state.profile.isVip && !state.profile.isVipChat)) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: AdaptiveButton(
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.orange.shade500,
                      Colors.yellow.shade600,
                    ],
                  ),
                  radius: 50,
                  width: 110,
                  height: 30,
                  isShimmer: true,
                  onTap: () => RouterHelper.getSubscriptionIntroRoute(),
                  label: 'subscription.subscribe'.tr(),
                ),
              );
            }

            // If user is VIP or has VIP chat access, show nothing
            return const SizedBox.shrink();
          }

          // Default return if none of the above states match
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
