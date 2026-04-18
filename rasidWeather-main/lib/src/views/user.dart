import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../../subscriptions/revenuecat_identity.dart';
import '../components/native_dialog.dart';
import '../components/top_bar.dart';
import '../model/singletons_data.dart';
import '../model/styles.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    setState(() {});
  }

  Future<void> _logIn(String dbId) async {
    setState(() {
      _isLoading = true;
    });

    /*
      How to login and identify your users with the Purchases SDK.

      Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    */

    try {
      await logInToRevenueCat(dbId);
      appData.appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => ShowDialogToDismiss(
          title: 'Error',
          content: e.message ?? 'Unknown error',
          buttonText: 'OK',
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _logOut() async {
    setState(() {
      _isLoading = true;
    });

    /*
      How to login and identify your users with the Purchases SDK.

      Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    */

    try {
      await logOutFromRevenueCat();
      appData.appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => ShowDialogToDismiss(
          title: 'Error',
          content: e.message ?? 'Unknown error',
          buttonText: 'OK',
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _restore() async {
    setState(() {
      _isLoading = true;
    });

    /*
      How to login and identify your users with the Purchases SDK.

      Read more about Identifying Users here: https://docs.revenuecat.com/docs/user-ids
    */

    try {
      await Purchases.restorePurchases();
      appData.appUserID = await Purchases.appUserID;
    } on PlatformException catch (e) {
      await showDialog(
        context: context,
        builder: (BuildContext context) => ShowDialogToDismiss(
          title: 'Error',
          content: e.message ?? 'Unknown error',
          buttonText: 'OK',
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TopBar(
      text: 'User',
      style: kTitleTextStyle,
      uniqueHeroTag: 'user',
      child: Scaffold(
        backgroundColor: kColorBackground,
        body: ModalProgressHUD(
          inAsyncCall: _isLoading,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const SizedBox(
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: 32.0,
                      right: 8.0,
                      left: 8.0,
                      bottom: 8.0,
                    ),
                    child: Text(
                      'Current User Identifier',
                      textAlign: TextAlign.center,
                      style: kTitleTextStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    appData.appUserID,
                    textAlign: TextAlign.center,
                    style: kDescriptionTextStyle,
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(
                    top: 24.0,
                    bottom: 8.0,
                    left: 8.0,
                    right: 8.0,
                  ),
                  child: Text(
                    'Subscription Status',
                    textAlign: TextAlign.center,
                    style: kTitleTextStyle,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    appData.entitlementIsActive ? 'Active' : 'Not Active',
                    textAlign: TextAlign.center,
                    style: kDescriptionTextStyle.copyWith(
                      color: (appData.entitlementIsActive)
                          ? kColorSuccess
                          : kColorError,
                    ),
                  ),
                ),
                Visibility(
                  visible: appData.appUserID.contains('RCAnonymousID:'),
                  child: const Padding(
                    padding: EdgeInsets.only(
                      top: 24.0,
                      bottom: 8.0,
                      left: 8.0,
                      right: 8.0,
                    ),
                    child: Text(
                      'Login',
                      textAlign: TextAlign.center,
                      style: kTitleTextStyle,
                    ),
                  ),
                ),
                Visibility(
                  visible: appData.appUserID.contains('RCAnonymousID:'),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.text,
                      style: kDescriptionTextStyle,
                      onSubmitted: (String value) {
                        if (value != '') _logIn(value);
                      },
                      decoration: userInputDecoration,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 100.0),
                  child: Column(
                    children: <Widget>[
                      Visibility(
                        visible: !appData.appUserID.contains('RCAnonymousID:'),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextButton(
                            onPressed: () {
                              _logOut();
                            },
                            child: Text(
                              'Logout',
                              style: kDescriptionTextStyle.copyWith(
                                fontSize: kFontSizeMedium,
                                fontWeight: FontWeight.bold,
                                color: kColorError,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextButton(
                          onPressed: () {
                            _restore();
                          },
                          child: Text(
                            'Restore Purchases',
                            style: kDescriptionTextStyle.copyWith(
                              fontSize: kFontSizeMedium,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
