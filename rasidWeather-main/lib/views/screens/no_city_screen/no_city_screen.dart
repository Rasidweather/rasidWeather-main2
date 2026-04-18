import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/widgets/image_widget.dart';
import '../../../helper/router_helper.dart';


class NoCityScreen extends StatefulWidget {
  const NoCityScreen({super.key});

  @override
  State<NoCityScreen> createState() => _NoCityScreenState();
}

class _NoCityScreenState extends State<NoCityScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(fit: StackFit.expand, children: <Widget>[
        Positioned.fill(child: ImageView.asset('assets/welcome.jpg', fit: BoxFit.cover)),
        SafeArea(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 250.w),
              child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <Widget>[
                const SizedBox(height: 30),
                ImageView.asset('assets/icon.png', width: 120),
                const SizedBox(height: 80),
                Center(
                  child: Text(
                    'common.welcome'.tr(),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontSize: 34,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    'common.add_city_message'.tr(),
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () => RouterHelper.getCitiesRoute(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: Text(
                    'common.add_city'.tr(),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
