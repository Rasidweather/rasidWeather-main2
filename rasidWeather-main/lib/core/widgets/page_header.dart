import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({
    super.key,
    required this.title,
    required this.onSubmit,
    required this.btnLabel,
    required this.child,
    this.isLoading = false,
  });

  final String title;
  final void Function() onSubmit;
  final String btnLabel;
  final Widget child;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        toolbarHeight: 80,
        leading: const CloseButton(color: Colors.black),
        scrolledUnderElevation: 0,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        actions: <Widget>[
          if (isLoading) const Padding(
            padding: EdgeInsets.symmetric(horizontal:18.0),
            child: CircularProgressIndicator(strokeWidth: 1),
          ),
          if (!isLoading)
          TextButton(
            onPressed: onSubmit,
            child: Text(
              btnLabel,
              style: const TextStyle(color: Colors.blue),
            ),
          ),
        ],
      ),
      body: child,
    );
  }
}
