import 'package:flutter/material.dart';

import '../../core/widgets/back_button.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.surface,
        leading: const AdaptiveBackButton(),
      ),
      body: const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
