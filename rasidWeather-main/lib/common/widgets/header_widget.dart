import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {

  const HeaderWidget({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 15.0),
        child: Text(
          title,
          style: Theme.of(context).textTheme.displaySmall!.copyWith(fontSize: 20),
        ),
      ),
    ]);
  }
}
