import 'package:flutter/material.dart';

import '../../helper/router_helper.dart';

class NotFound extends StatelessWidget {
  const NotFound({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => RouterHelper.getDashboardRoute('home'),
        ),
        centerTitle: true,
        title: const Text('Not Found'),
      ),
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
}
