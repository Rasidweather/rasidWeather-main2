import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../helper/router_helper.dart';

class DonePage extends StatefulWidget {
  const DonePage({super.key});

  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  @override
  void initState() {
    Future<Widget>.delayed(const Duration(milliseconds: 5000)).then((Widget value) {
      RouterHelper.getDashboardRoute('home', action: RouteAction.pushNamedAndRemoveUntil);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body:
            Center(child: Lottie.asset('assets/done.json', alignment: Alignment.center, fit: BoxFit.cover, height: 200, width: 200, repeat: false)));
  }
}
