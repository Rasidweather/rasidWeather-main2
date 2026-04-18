import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../bloc/subscription_cuibt/subscription_cubit.dart';
import '../../constant.dart';
import '../../data/model/plan_model.dart';
import '../../subscriptions/purchases_error_utils.dart';
import '../model/singletons_data.dart';
import '../model/styles.dart';

class Paywall extends StatefulWidget {

  const Paywall({super.key, this.offering});
  final Offering? offering;

  @override
  _PaywallState createState() => _PaywallState();
}

class _PaywallState extends State<Paywall> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Wrap(
          children: <Widget>[
            Container(
              height: 70.0,
              width: double.infinity,
              decoration: const BoxDecoration(
                  color: kColorBar,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(25.0))),
              child: const Center(
                  child:
                      Text('✨ Magic Weather Premium', style: kTitleTextStyle)),
            ),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  'MAGIC WEATHER PREMIUM',
                  style: kDescriptionTextStyle,
                ),
              ),
            ),
            if (widget.offering?.availablePackages.isNotEmpty ?? false)
              _buildOfferingPackages(context, widget.offering!.availablePackages)
            else if (Platform.isAndroid)
              BlocBuilder<SubscriptionCubit, SubscriptionState>(
                builder: (BuildContext context, SubscriptionState state) {
                  if (state is SubscriptionLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is SubscriptionError) {
                    return Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(state.message, style: kDescriptionTextStyle),
                    );
                  }
                  if (state is SubscriptionLoaded) {
                    return _buildAndroidFallbackPlans(state.plans);
                  }
                  return const SizedBox.shrink();
                },
              )
            else
              const SizedBox.shrink(),
            const Padding(
              padding:
                  EdgeInsets.only(top: 32, bottom: 16, left: 16.0, right: 16.0),
              child: SizedBox(
                width: double.infinity,
                child: Text(
                  footerText,
                  style: kDescriptionTextStyle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOfferingPackages(
      BuildContext context, List<Package> packages) {
    return ListView.builder(
      itemCount: packages.length,
      itemBuilder: (BuildContext context, int index) {
        final Package pkg = packages[index];
        return Card(
          color: Colors.black,
          child: ListTile(
            onTap: () async => _purchasePackage(context, pkg),
            title: Text(
              pkg.storeProduct.title,
              style: kTitleTextStyle,
            ),
            subtitle: Text(
              pkg.storeProduct.description,
              style:
                  kDescriptionTextStyle.copyWith(fontSize: kFontSizeSuperSmall),
            ),
            trailing: Text(
              pkg.storeProduct.priceString,
              style: kTitleTextStyle,
            ),
          ),
        );
      },
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
    );
  }

  Widget _buildAndroidFallbackPlans(List<PlanModel> plans) {
    return Column(
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Google Play Billing غير متاح. ثبّت التطبيق من Play Store (Internal testing) '
            'وتأكد المنتجات Active وحسابك Tester.',
            style: kDescriptionTextStyle,
          ),
        ),
        ListView.builder(
          itemCount: plans.length,
          itemBuilder: (BuildContext context, int index) {
            final PlanModel plan = plans[index];
            return Card(
              color: Colors.black,
              child: ListTile(
                title: Text(
                  plan.name ?? '',
                  style: kTitleTextStyle,
                ),
                subtitle: Text(
                  plan.description ?? '',
                  style: kDescriptionTextStyle.copyWith(
                      fontSize: kFontSizeSuperSmall),
                ),
                trailing: Text(
                  plan.discount?.toString() ?? '—',
                  style: kTitleTextStyle,
                ),
                enabled: false,
              ),
            );
          },
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
        ),
      ],
    );
  }

  Future<void> _purchasePackage(
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
        await showDialog(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text('Billing Error'),
            content: Text(msg),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print(e);
    }

    if (!mounted) return;
    setState(() {});
    Navigator.pop(context);
  }
}
