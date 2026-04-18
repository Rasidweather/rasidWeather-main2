import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

import '../../../bloc/profile_cubit/profile_cubit.dart';
import '../../../common/constants/index.dart';
import '../../../core/widgets/image_widget.dart';
import '../../../data/model/user_model.dart';
import '../../../features/ads/presentation/services/ads_service.dart';
import '../../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../../features/language/components/language_dropdown.dart';
import '../../../features/language/cubit/language_cubit.dart';
import '../../../generated/assets.dart';
import '../../../helper/router_helper.dart';
import '../../../locator.dart';
import '../../../utils/ui_utils.dart';
import '../../base/native_ad_widget.dart';
import '../../base/real_native_ad_widget.dart';
import 'about_us.dart';
import 'contact_us.dart';
import 'privacy.dart';
import 'terms.dart';

/// ProfilePage widget that displays user profile and app settings
///
/// This is the main profile screen widget that handles both authenticated
/// and guest user states, along with various app settings and actions
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  Future<void> openAboutDialog(BuildContext context) async {
    await showDialog<Widget>(
        context: context,
        builder: (BuildContext context) {
          return const AboutDialog(
            applicationName: AppStrings.appName,
            applicationIcon: Image(
                image: AssetImage(Assets.assetsLogo), height: 30, width: 30),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        shadowColor: Colors.grey[100],
        automaticallyImplyLeading: false,
        title: Text(
          'profile.title'.tr(),
          style: Theme.of(context).textTheme.titleLarge,
        ),
        centerTitle: true,
      ),
      body: BlocListener<AuthCubit, AuthState>(
        listener: (BuildContext context, AuthState state) {
          if (state is LogoutSuccess || state is UnauthenticatedState) {
            RouterHelper.getDashboardRoute('home');
            context.read<ProfileCubit>().checkAuthStatus();
          }
        },
        child: ListView(
            padding: const EdgeInsets.fromLTRB(15, 20, 20, 50),
            children: <Widget>[
              BlocConsumer<ProfileCubit, ProfileState>(
                listenWhen: (ProfileState previous, ProfileState current) =>
                    previous != current,
                listener: (BuildContext context, ProfileState state) {
                  if (state is UnauthenticatedState) {}
                },
                builder: (BuildContext context, ProfileState state) {
                  if (state is ProfileError) {
                    print('ProfileError${state.error}');
                  }
                  if (state is ProfileSuccess) {
                    return UserUI(currentUser: state.profile);
                  }
                  return const GuestUserUI();
                },
              ),
              const SizedBox(height: 15),
              // Add a small native ad between user profile and general settings
              if (!AppStrings.isVip) ...<Widget>[  
                const NativeAdWidget(
                  size: AdSize.fullBanner,
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                ),
                const SizedBox(height: 15),
              ],
              Text(
                'profile.general_settings'.tr(),
                style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff3D3C3C)),
              ),
              const SizedBox(height: 15),
              BlocBuilder<LanguageCubit, LanguageState>(
                builder: (BuildContext context, LanguageState state) {
                  return ListTile(
                    leading: ImageView.svgAsset(Assets.svgLanguage),
                    trailing: const LanguageDropdown(),
                    title: Text(
                      'profile.changeLanguage'.tr(),
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xff3D3C3C)),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text('profile.contact_us'.tr()),
                leading: ImageView.svgAsset(Assets.svgMail),
                trailing: Icon(
                    context.read<LanguageCubit>().isArabic()
                        ? FeatherIcons.chevronLeft
                        : FeatherIcons.chevronRight,
                    size: 20),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const ContactUsScreen(),
                  ),
                ),
              ),
              const Divider(height: 3),
              ListTile(
                title: Text('profile.rate_app'.tr()),
                leading: ImageView.svgAsset(Assets.svgStar),
                trailing: Icon(
                    context.read<LanguageCubit>().isArabic()
                        ? FeatherIcons.chevronLeft
                        : FeatherIcons.chevronRight,
                    size: 20),
                onTap: () async {
                  final InAppReview inAppReview = InAppReview.instance;
                  if (await inAppReview.isAvailable()) {
                    inAppReview.requestReview();
                  }
                },
              ),
              const Divider(height: 3),
              ListTile(
                title: Text('profile.privacy_policy'.tr()),
                leading: ImageView.svgAsset(Assets.svgLock),
                trailing: Icon(
                    context.read<LanguageCubit>().isArabic()
                        ? FeatherIcons.chevronLeft
                        : FeatherIcons.chevronRight,
                    size: 20),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const Privacy(),
                  ),
                ),
              ),
              const Divider(height: 3),
              ListTile(
                title: Text('profile.about_us'.tr()),
                leading: ImageView.svgAsset(Assets.svgInfo),
                trailing: Icon(
                    context.read<LanguageCubit>().isArabic()
                        ? FeatherIcons.chevronLeft
                        : FeatherIcons.chevronRight,
                    size: 20),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const AboutUs(),
                  ),
                ),
              ),
              // if (!removeAds)

              const NativeAdWidgetReal(),
              const Divider(height: 3),
              ListTile(
                title: Text('profile.terms_of_use'.tr()),
                leading: ImageView.svgAsset(Assets.svgKey),
                trailing: Icon(
                    context.read<LanguageCubit>().isArabic()
                        ? FeatherIcons.chevronLeft
                        : FeatherIcons.chevronRight,
                    size: 20),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => const Terms(),
                  ),
                ),
              ),
              const Divider(height: 3),
              ListTile(
                title: Text('profile.share_app'.tr()),
                leading: ImageView.svgAsset(Assets.svgShare),
                trailing: Icon(
                    context.read<LanguageCubit>().isArabic()
                        ? FeatherIcons.chevronLeft
                        : FeatherIcons.chevronRight,
                    size: 20),
                onTap: () async {
                  final RenderBox? box = context.findRenderObject() as RenderBox?;
                  await Share.share(
                    'تحقق من التطبيق Rasid Weather https://onelink.to/wvwmth',
                    sharePositionOrigin: box != null
                        ? box.localToGlobal(Offset.zero) & box.size
                        : null,
                  );
                },
              ),
              const NativeAdWidget(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
              ),
              
              // Add a medium native ad in the middle of the settings list
              if (!AppStrings.isVip) ...<Widget>[  
                const SizedBox(height: 15),
                // Align(
                //   child: FutureBuilder<Widget>(
                //     future: sl<AdsService>().getBannerAd(),
                //     builder: (
                //         BuildContext context,
                //         AsyncSnapshot<Widget> snapshot,
                //         ) {
                //       if (snapshot.hasData) {
                //         return snapshot.data!;
                //       }
                //       return const SizedBox();
                //     },
                //   ),
                // ),
                Align(
                  child: FutureBuilder<Widget>(
                    future: sl<AdsService>().getMrecAd(),
                    builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
                      if (!snapshot.hasData) return const SizedBox(width: 300, height: 250);
                      return snapshot.data!;
                    },
                  )



                ),
              ],
            ]),
      ),
    );
  }
}

class GuestUserUI extends StatelessWidget {
  const GuestUserUI({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ListTile(
        title: Text('profile.login'.tr()),
        leading: SizedBox(
          height: 30,
          width: 30,
          child: Icon(FeatherIcons.user, size: 20, color: Colors.grey[600]),
        ),
        trailing: Icon(
            context.read<LanguageCubit>().isArabic()
                ? FeatherIcons.chevronLeft
                : FeatherIcons.chevronRight,
            size: 20),
        onTap: () => RouterHelper.getLoginRoute(),
      ),
      const SizedBox(height: 20)
    ]);
  }
}

/// Widget to display loading state while fetching user profile
class UserLoading extends StatelessWidget {
  const UserLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(children: <Widget>[
        CircleAvatar(
          radius: 45,
          backgroundColor: Colors.grey[300],
          backgroundImage:
              const CachedNetworkImageProvider(Images.defaultAvatar),
        ),
        const SizedBox(height: 15),
        Text(
          '......',
          style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xff3D3C3C)),
        ),
        Text(
          '.....',
          style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xff3D3C3C)),
        ),
      ]),
    );
  }
}

/// Widget to display UI for authenticated users
///
/// Shows user profile information and related actions
class UserUI extends StatelessWidget {
  const UserUI({super.key, required this.currentUser});

  final UserModel currentUser;

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      SizedBox(
        height: 200,
        child: Column(children: <Widget>[
          CircleAvatar(
            radius: 45,
            backgroundColor: Colors.grey[300],
            backgroundImage:
                CachedNetworkImageProvider(currentUser.avatar!.main!),
          ),
          const SizedBox(height: 15),
          Text(
            currentUser.userName,
            style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: const Color(0xff3D3C3C)),
          ),
          Text(
            currentUser.userEmail,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xff3D3C3C)),
          ),
        ]),
      ),
      if (kDebugMode)
        FutureBuilder<String>(
          future: context.read<ProfileCubit>().getToken(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            return ListTile(
              title: const Text('copy user token'),
              leading: ImageView.svgAsset(Assets.svgUser),
              trailing: Icon(
                  context.read<LanguageCubit>().isArabic()
                      ? FeatherIcons.chevronLeft
                      : FeatherIcons.chevronRight,
                  size: 20),
              onTap: () {
                // Copy the token to clipboard
                Clipboard.setData(ClipboardData(text: snapshot.data!));
                showSnackBar(context, 'user token copied');
              },
            );
          },
        ),
      ListTile(
        title: Text('profile.edit_profile'.tr()),
        leading: ImageView.svgAsset(Assets.svgUser),
        trailing: Icon(
            context.read<LanguageCubit>().isArabic()
                ? FeatherIcons.chevronLeft
                : FeatherIcons.chevronRight,
            size: 20),
        onTap: () => RouterHelper.getEditProfileRoute(currentUser),
      ),
      if (currentUser.subscriptions != null &&
          currentUser.subscriptions!.isNotEmpty)
        ListTile(
          title: const Text(
            'subscription.title',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          ).tr(),
          subtitle: Text(
            !currentUser.subscriptions!.first.isSubscribeExpired
                ? 'subscription.active'.tr()
                : 'subscription.expired'.tr(),
            style: TextStyle(
              color: !currentUser.subscriptions!.first.isSubscribeExpired
                  ? Colors.green
                  : Colors.red,
              fontSize: 12,
            ),
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: Colors.orange,
              size: 24,
            ),
          ),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Text(
                'subscription.expiration_date'.tr(),
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
              ),
              Text(
                DateFormat('yyyy/MM/dd').format(
                    currentUser.subscriptions!.first.expiredAt ??
                        DateTime.now()),
                style: const TextStyle(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          onTap: () {
            if (currentUser.subscriptions!.first.isSubscribeExpired) {
              _showResubscribeDialog(context);
            } else if (currentUser.subscriptions!.first.isSubscribed != true) {
              RouterHelper.getSubscriptionRoute();
            }
          },
        ),
      ListTile(
        title: Text('profile.delete_account.title'.tr()),
        leading: ImageView.svgAsset(Assets.svgDeleteAccount, color: Colors.red),
        trailing: Icon(
            context.read<LanguageCubit>().isArabic()
                ? FeatherIcons.chevronLeft
                : FeatherIcons.chevronRight,
            size: 20),
        onTap: () => RouterHelper.getRemoveAccountRoute(),
      ),
      const Divider(height: 3),
      ListTile(
        title: Text('profile.logout.confirm_title'.tr()),
        leading: ImageView.svgAsset(Assets.svgLogout),
        trailing: Icon(
            context.read<LanguageCubit>().isArabic()
                ? FeatherIcons.chevronLeft
                : FeatherIcons.chevronRight,
            size: 20),
        onTap: () => openLogoutDialog(context),
      ),
      const SizedBox(height: 15),
    ]);
  }

  void _showResubscribeDialog(BuildContext context) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(
            child: Text(
              'تجديد الاشتراك',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(
                Icons.stars_rounded,
                color: Colors.orange,
                size: 48,
              ),
              const SizedBox(height: 16),
              const Text(
                'انتهى اشتراكك في الخدمات المميزة!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'جدد اشتراكك الآن للاستمتاع بالمزايا الحصرية',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 12),
              _buildBenefitItem(context, 'تصفح بدون إعلانات'),
              _buildBenefitItem(context, 'تنبؤات طقس متقدمة'),
              _buildBenefitItem(context, 'تنبيهات مخصصة'),
              _buildBenefitItem(context, 'دعم فني متميز'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'لاحقاً',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
                RouterHelper.getSubscriptionRoute();
              },
              child: const Text('تجديد الآن'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBenefitItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: <Widget>[
          const Icon(Icons.check_circle, color: Colors.green, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void openLogoutDialog(BuildContext context) {
    showDialog<Widget>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('profile.logout.confirm_title'.tr()),
          content: Text('profile.logout.confirm_message'.tr()),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('common.no'.tr()),
            ),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await context.read<AuthCubit>().signOut();
                context.read<ProfileCubit>().checkAuthStatus();
              },
              child: Text('common.yes'.tr()),
            ),
          ],
        );
      },
    );
  }
}
