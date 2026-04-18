import 'package:flutter/material.dart';

class LoadingFeaturedCard extends StatelessWidget {
  const LoadingFeaturedCard({super.key, this.height});

  final double? height;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      height: height ?? 200,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(5),
      ),
    );
  }
}

class LoadingCard extends StatelessWidget {
  const LoadingCard({super.key, this.height, this.count});

  final double? height;
  final int? count;

  @override
  Widget build(BuildContext context) {
    final int itemCount = count ?? 1;

    return SingleChildScrollView(
      child: Column(
        children: List.generate(
          itemCount,
          (int index) => _loadingItem(context),
        ),
      ),
    );
  }

  Widget _loadingItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      height: height,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(15),
      ),
    );
  }
}
