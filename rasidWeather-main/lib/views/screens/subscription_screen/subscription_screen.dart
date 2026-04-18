import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../bloc/profile_cubit/profile_cubit.dart';
import '../../../bloc/subscription_cuibt/subscription_cubit.dart';
import '../../../constant.dart';
import '../../../data/model/plan_model.dart';
import '../../../helper/router_helper.dart';
import '../../../locator.dart';
import '../../../src/model/singletons_data.dart';
import '../../../subscriptions/purchases_error_utils.dart';
import '../../../utils/ui_utils.dart';

class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  List<ProductDetails> productDetails = <ProductDetails>[];
  List<PlanModel> plans = <PlanModel>[];

  bool storeAvailable = false;
  List<String> missingProductIds = <String>[];
  List<Package> _androidPackages = <Package>[];
  Package? _selectedPackage;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      _loadAndroidOfferings();
    }
    context.read<SubscriptionCubit>().fetchSubscriptions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'subscription.title'.tr(),
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: BlocConsumer<SubscriptionCubit, SubscriptionState>(
        listener: (BuildContext context, SubscriptionState state) {
          if (state is SubscriptionLoaded) {
            productDetails = state.productDetails;
            plans = state.plans;

            storeAvailable = state.storeAvailable;
            missingProductIds = state.missingProductIds;
          }

          if (state is PurchaseSuccess) {
            RouterHelper.getSuccessSubscriptionRoute(
              action: RouteAction.pushReplacement,
            );
          }

          if (state is PurchaseError) {
            showSnackBar(
              context,
              'subscription.purchase_failed'.tr(args: <String>[state.error]),
            );
          }

          if (state is PurchasePending) {
            showSnackBar(context, 'subscription.pending_purchase'.tr());
          }
        },
        builder: (BuildContext context, SubscriptionState state) {
          if (state is SubscriptionLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is SubscriptionNotAvailable) {
            return Center(child: Text('subscription.not_available'.tr()));
          }

          if (state is SubscriptionError) {
            return Center(child: Text(state.message));
          }

          final bool androidHasPackages =
              Platform.isAndroid && _androidPackages.isNotEmpty;

          return Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                image: const AssetImage('assets/bg_screen_image.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.white.withOpacity(0.7),
                  BlendMode.lighten,
                ),
              ),
            ),
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  if (!storeAvailable && Platform.isIOS)
                    Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12.r),
                        border:
                        Border.all(color: Colors.orange.withOpacity(0.30)),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'تعذر تحميل الأسعار من المتجر حالياً. سيتم عرض الباقات بدون أسعار.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  if (missingProductIds.isNotEmpty && Platform.isIOS)
                    Container(
                      margin:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12.r),
                        border: Border.all(color: Colors.red.withOpacity(0.25)),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.error_outline, color: Colors.red),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'بعض منتجات المتجر غير موجودة/غير مفعلة: ${missingProductIds.join(', ')}',
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (Platform.isAndroid && !androidHasPackages)
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      padding: EdgeInsets.all(12.w),
                      decoration: BoxDecoration(
                        color: Colors.orange.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12.r),
                        border:
                            Border.all(color: Colors.orange.withOpacity(0.30)),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.info_outline, color: Colors.orange),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              'Google Play Billing غير متاح. ثبّت التطبيق من Play Store (Internal testing) '
                              'وتأكد المنتجات Active وحسابك Tester.',
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                  Expanded(
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 8.h,
                      ),
                      child: androidHasPackages
                          ? _buildAndroidPackagesList(_androidPackages)
                          : _buildPlansList(plans),
                    ),
                  ),
                  _buildBottomButtons(context),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    final bool androidCanPurchase = _androidPackages.isNotEmpty;
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ElevatedButton(
            onPressed: (Platform.isAndroid && !androidCanPurchase)
                ? null
                : () async {
                    if (Platform.isAndroid) {
                      final Package? selected = _selectedPackage;
                      if (selected == null) {
                        showSnackBar(context, 'subscription.select_plan'.tr());
                        return;
                      }
                      await _purchaseAndroidPackage(context, selected);
                      return;
                    }

                    if (!storeAvailable) {
                      showSnackBar(
                        context,
                        'المتجر غير متاح حالياً. ثبّت التطبيق من Google Play (Release) وجرب مرة ثانية.',
                      );
                      return;
                    }

                    final bool isLoggedIn =
                        await sl<ProfileCubit>().isLoggedIn();
                    if (!isLoggedIn) {
                      await openSignInDialog();
                      return;
                    }

                    final ProductDetails? selected = context
                        .read<SubscriptionCubit>()
                        .selectedProductDetails;

                    if (selected == null) {
                      showSnackBar(context, 'subscription.select_plan'.tr());
                      return;
                    }

                    await context
                        .read<SubscriptionCubit>()
                        .initiatePurchase(selected);
                  },
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.r),
              ),
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(
              'subscription.subscribe_now'.tr(),
              style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.bold),
            ),
          ),
          if (Platform.isAndroid) ...<Widget>[
            SizedBox(height: 10.h),
            TextButton(
              onPressed: () async => _refreshAndroidStatus(context),
              child: Text(
                'تم الدفع؟ تحديث',
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
              ),
            ),
          ],
          SizedBox(height: 16.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              TextButton(
                onPressed: () async {
                  final Uri url =
                  Uri.parse('https://rasidweather.com/page/terms');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: Text(
                  'subscription.terms'.tr(),
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                ),
              ),
              Text(
                ' • ',
                style: TextStyle(fontSize: 14.sp, color: Colors.black38),
              ),
              TextButton(
                onPressed: () async {
                  final Uri url =
                  Uri.parse('https://rasidweather.com/page/privacy');
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  }
                },
                child: Text(
                  'subscription.privacy'.tr(),
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPlansList(List<PlanModel> plans) {
    final Map<String, ProductDetails> storeMap = <String, ProductDetails>{
      for (final ProductDetails p in productDetails) p.id: p,
    };
    final bool androidCanSelect = _androidPackages.isNotEmpty;

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: plans.length,
      itemBuilder: (BuildContext context, int index) {
        final PlanModel plan = plans[index];
        final String? pid =
        Platform.isAndroid ? plan.androidProductId : plan.iosProductId;

        final ProductDetails? pd = (pid == null || pid.isEmpty)
            ? null
            : storeMap[pid]; // ممكن يكون null لو المتجر ما رجعه

        return planItem(context, plan, pd, androidCanSelect);
      },
    );
  }

  String _stripHtml(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '').trim();
  }

  Widget planItem(BuildContext context, PlanModel plan, ProductDetails? product,
      bool androidCanSelect) {
    final bool isSelected = (product != null) &&
        (context.read<SubscriptionCubit>().selectedProductDetails?.id ==
            product.id);

    final String title = plan.name ?? '';
    final String desc = _stripHtml(plan.description ?? '');

    final String priceText = product?.price ?? 'غير متاح حالياً';

    String? originalPrice;
    if (product != null && plan.discount != null && plan.discount! > 0) {
      try {
        final String priceStr =
        product.price.replaceAll(RegExp(r'[^0-9.]'), '');
        final double currentPrice = double.parse(priceStr);
        final double originalAmount = currentPrice / (1 - plan.discount! / 100);

        final String currencySymbol =
        product.price.replaceAll(RegExp(r'[0-9.]'), '').trim();

        originalPrice = '$currencySymbol${originalAmount.toStringAsFixed(2)}';
      } catch (_) {}
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: isSelected ? Colors.blue : Colors.grey.shade300,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: isSelected ? 15 : 10,
            offset: Offset(0, isSelected ? 6 : 4),
          ),
        ],
      ),
      child: ListTile(
        onTap: Platform.isAndroid
            ? null
            : product == null
                ? null
                : () {
                    setState(() {
                      context.read<SubscriptionCubit>().selectProduct(
                        productDetails: product,
                      );
                    });
                  },
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
        leading: Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            color: Colors.blue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: SvgPicture.asset(
            'assets/diamond.svg',
            width: 32.w,
            height: 32.w,
            colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 6.h),
            Text(
              desc,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 14.sp, color: Colors.black54),
            ),
            SizedBox(height: 10.h),
            if (Platform.isAndroid && plan.duration != null)
              Text(
                'المدة: ${plan.duration}',
                style: TextStyle(fontSize: 13.sp, color: Colors.black54),
              ),

            if (!Platform.isAndroid &&
                product != null &&
                plan.discount != null &&
                plan.discount! > 0 &&
                originalPrice != null)
              Row(
                children: <Widget>[
                  Container(
                    padding:
                    EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Text(
                      '-${plan.discount}%',
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    originalPrice,
                    style: TextStyle(
                      fontSize: 14.sp,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),

            Text(
              Platform.isAndroid
                  ? _androidPlanPriceText(plan)
                  : 'date.xYears'.tr().replaceFirst('{}', priceText),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Platform.isAndroid
                    ? Colors.blue
                    : product == null
                        ? Colors.grey
                        : Colors.blue,
              ),
            ),

            if (product == null && Platform.isIOS) ...<Widget>[
              SizedBox(height: 6.h),
              Text(
                'الشراء غير متاح حالياً من المتجر على هذا الجهاز.',
                style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              ),
            ],
          ],
        ),
        enabled: Platform.isAndroid ? androidCanSelect : product != null,
      ),
    );
  }

  String _androidPlanPriceText(PlanModel plan) {
    // عرض المدة (سنوي) بدلاً من الخصم
    if (plan.duration != null) {
      return 'المدة: ${plan.duration}';
    }
    return 'سنوي'; // افتراضي
  }

  Future<void> _loadAndroidOfferings() async {
    try {
      final Offerings offerings = await Purchases.getOfferings();
      final Offering? current = offerings.current;
      if (current != null && current.availablePackages.isNotEmpty) {
        setState(() {
          _androidPackages = current.availablePackages;
          _selectedPackage ??= _androidPackages.first;
        });
        return;
      }
    } on PlatformException catch (e) {
      final String? msg = billingDeveloperMessage(e);
      if (msg != null) {
        await _showBillingErrorDialog(msg);
      }
    } catch (_) {}

    setState(() {
      _androidPackages = <Package>[];
      _selectedPackage = null;
    });
  }

  Future<void> _refreshAndroidStatus(BuildContext context) async {
    try {
      final CustomerInfo info = await Purchases.getCustomerInfo();
      appData.appUserID = await Purchases.appUserID;
      appData.entitlementIsActive =
          info.entitlements.all[entitlementID]?.isActive ?? false;
    } catch (_) {}

    try {
      await context.read<SubscriptionCubit>().fetchSubscriptions();
    } catch (_) {}
  }

  Widget _buildAndroidPackagesList(List<Package> packages) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: packages.length,
      itemBuilder: (BuildContext context, int index) {
        final Package pkg = packages[index];
        final bool isSelected = _selectedPackage?.identifier == pkg.identifier;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          margin: EdgeInsets.symmetric(horizontal: 1.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(
              color: isSelected ? Colors.blue : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: isSelected ? 15 : 10,
                offset: Offset(0, isSelected ? 6 : 4),
              ),
            ],
          ),
          child: ListTile(
            onTap: () {
              setState(() {
                _selectedPackage = pkg;
              });
            },
            contentPadding:
                EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
            leading: Container(
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: SvgPicture.asset(
                'assets/diamond.svg',
                width: 32.w,
                height: 32.w,
                colorFilter: const ColorFilter.mode(Colors.blue, BlendMode.srcIn),
              ),
            ),
            title: Text(
              pkg.storeProduct.title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 6.h),
                Text(
                  pkg.storeProduct.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 14.sp, color: Colors.black54),
                ),
                SizedBox(height: 10.h),
                Text(
                  pkg.storeProduct.priceString,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _purchaseAndroidPackage(
      BuildContext context, Package package) async {
    try {
      final PurchaseResult purchaseResult =
          await Purchases.purchasePackage(package);
      final EntitlementInfo? entitlement =
          purchaseResult.customerInfo.entitlements.all[entitlementID];
      appData.entitlementIsActive = entitlement?.isActive ?? false;
    } on PlatformException catch (e) {
      final String? msg = billingDeveloperMessage(e);
      if (msg != null) {
        await _showBillingErrorDialog(msg);
      }
    } catch (_) {}
  }

  Future<void> _showBillingErrorDialog(String message) async {
    await showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Billing Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
