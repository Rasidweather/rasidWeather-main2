import 'package:flutter/material.dart';

class AppHeadline extends StatelessWidget {
  const AppHeadline({
    super.key,
    required this.headlineTitle,
    this.leading = const SizedBox.shrink(),
  });

  final String headlineTitle;
  final Widget leading;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 15, top: 10, bottom: 5, right: 15),
      child: Row(
        children: <Widget>[
          Container(
            height: 30,
            width: 4,
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 6),
          Text(
            headlineTitle,
            style: Theme.of(context).textTheme.headlineSmall!.copyWith(fontSize: 15),
          ),
          const Spacer(),
          leading
        ],
      ),
    );
  }
}
