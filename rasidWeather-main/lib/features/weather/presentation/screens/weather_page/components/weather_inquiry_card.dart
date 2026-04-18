import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../bloc/profile_cubit/profile_cubit.dart';
import '../../../../../../core/widgets/image_widget.dart';
import '../../../../../../data/model/user_model.dart';
import '../../../../../../helper/router_helper.dart';
import '../../../../../../views/base/weather_container.dart';

class WeatherInquiryCard extends StatelessWidget {
  const WeatherInquiryCard({super.key});

  static final ImageView _cachedIllustration = ImageView.asset('assets/inquiries.png');

  @override
  Widget build(BuildContext context) {
    return BlocSelector<ProfileCubit, ProfileState, UserModel?>(
      selector: (ProfileState state) => state is ProfileSuccess ? state.profile : null,
      builder: (BuildContext context, UserModel? profile) {
        if (profile == null) return const SizedBox.shrink();
        return WeatherContainer(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          padding: const EdgeInsets.all(10),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              _MessageSection(profile: profile),
               Expanded(flex: 2, child: _cachedIllustration),
            ],
          ),
        );
      },
    );
  }
}

class _MessageSection extends StatelessWidget {
  const _MessageSection({required this.profile});

  final UserModel profile;

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Expanded(
      flex: 3,
      child: Column(
        children: <Widget>[
          Text(
            'inquiries.message'.tr(),
            style: textTheme.bodyMedium!.copyWith(fontSize: 20.sp, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              minimumSize: Size(150.w, 40.h),
            ),
            onPressed: () => RouterHelper.getInquiriesRoute(profile),
            child: Text(
              'inquiries.button'.tr(),
              style: textTheme.bodyMedium!.copyWith(fontSize: 15.sp, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}