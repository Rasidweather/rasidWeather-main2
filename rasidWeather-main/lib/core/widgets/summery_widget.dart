import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../utils/price_formatter.dart';

class SummeryItemData {

  const SummeryItemData({
    required this.label,
    required this.value,
    required this.color,
    this.translationKey,
    this.showCurrency = false,
    this.currencySymbol = '﷼',
  });
  final String label;
  final String value;
  final Color color;
  final String? translationKey;
  final bool showCurrency;
  final String? currencySymbol;

  String get displayValue {
    if (!showCurrency) return value;
    final String formattedValue = PriceFormatter.formatPrice(value);
    return '$formattedValue $currencySymbol';
  }

  String get tooltipValue {
    if (!showCurrency) return value;
    final String formattedValue = PriceFormatter.formatFullPrice(value);
    return '$formattedValue $currencySymbol';
  }

  String get displayLabel => translationKey?.tr() ?? label;
}

class SummeryData {

  const SummeryData({
    required this.items,
    this.progress,
    this.progressLabel,
    this.remainingLabel,
    this.progressTranslationKey,
    this.remainingTranslationKey,
    this.translationParams,
  });

  factory SummeryData.fromProject({
    required String totalPaid,
    required String totalRemaining,
    required String completionPercentage,
    required String remainingPercentage,
  }) {
    return SummeryData(
      items: <SummeryItemData>[
        SummeryItemData(
          label: 'Total Paid',
          value: totalPaid,
          color: Colors.blue,
          translationKey: 'projects.totalPaid',
          showCurrency: true,
        ),
        SummeryItemData(
          label: 'Total Remaining',
          value: totalRemaining,
          color: Colors.green,
          translationKey: 'projects.totalRemaining',
          showCurrency: true,
        ),
      ],
      progress: double.tryParse(completionPercentage.replaceAll('%', ''))?.clamp(0, 100) ?? 0 / 100,
      progressTranslationKey: 'projects.completion',
      remainingTranslationKey: 'projects.remaining',
      translationParams: <String, String>{
        'completion': completionPercentage,
        'remaining': remainingPercentage,
      },
    );
  }

  factory SummeryData.fromFinance({
    required String totalAmount,
    required String paidAmount,
    required String remainingAmount,
    required String completionPercentage,
    required String remainingPercentage,
  }) {
    return SummeryData(
      items: <SummeryItemData>[
        SummeryItemData(
          label: 'Total Amount',
          value: totalAmount,
          color: Colors.grey.shade700,
          translationKey: 'finance.total_amount',
          showCurrency: true,
        ),
        SummeryItemData(
          label: 'Paid Amount',
          value: paidAmount,
          color: Colors.blue,
          translationKey: 'finance.paid_amount',
          showCurrency: true,
        ),
        SummeryItemData(
          label: 'Remaining Amount',
          value: remainingAmount,
          color: Colors.orange,
          translationKey: 'finance.remaining_amount',
          showCurrency: true,
        ),
      ],
      progress: double.tryParse(completionPercentage.replaceAll('%', ''))?.clamp(0, 100) ?? 0 / 100,
      progressTranslationKey: 'finance.completion',
      remainingTranslationKey: 'finance.remaining',
      translationParams: <String, String>{
        'completion': completionPercentage,
        'remaining': remainingPercentage,
      },
    );
  }
  final List<SummeryItemData> items;
  final double? progress;
  final String? progressLabel;
  final String? remainingLabel;
  final String? progressTranslationKey;
  final String? remainingTranslationKey;
  final Map<String, String>? translationParams;
}

class SummeryWidget extends StatelessWidget {

  const SummeryWidget({
    super.key,
    required this.data,
    this.progressColor,
    this.backgroundColor,
    this.padding,
    this.margin,
    this.itemsAlignment = MainAxisAlignment.spaceBetween,
    this.crossAxisAlignment,
    this.showProgress = true,
    this.itemSpacing,
    this.maxItems,
    this.downloadWidget,
  });
  final SummeryData data;
  final Color? progressColor;
  final Color? backgroundColor;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final MainAxisAlignment itemsAlignment;
  final CrossAxisAlignment? crossAxisAlignment;
  final bool showProgress;
  final double? itemSpacing;
  final int? maxItems;
  final Widget? downloadWidget;

  @override
  Widget build(BuildContext context) {
    final List<SummeryItemData> displayItems = maxItems != null ? data.items.take(maxItems!).toList() : data.items;

    return Card(
      margin: margin ?? const EdgeInsets.all(16),
      child: Padding(
        padding: padding ?? const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: crossAxisAlignment ?? CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: itemsAlignment,
              children: <Widget>[
                ...List.generate(
                  displayItems.length,
                  (int index) => SummeryItem(data: displayItems[index]),
                ),
                if(downloadWidget != null) downloadWidget!,
              ],
            ),
            if (showProgress && data.progress != null) ...<Widget>[
              const SizedBox(height: 16),
              LinearProgressIndicator(
                value: data.progress,
                backgroundColor: backgroundColor ?? Colors.grey.shade200,
                valueColor: AlwaysStoppedAnimation<Color>(
                  progressColor ?? Colors.blue,
                ),
              ),
              if (data.progressTranslationKey != null && data.remainingTranslationKey != null && data.translationParams != null) ...<Widget>[
                const SizedBox(height: 8),
                Row(
                  children: <Widget>[
                    Text(
                      data.progressTranslationKey!.tr().replaceFirst('{0}', data.translationParams!['completion'] ?? '0'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const Spacer(),
                    Text(
                      data.remainingTranslationKey!.tr().replaceFirst('{0}', data.translationParams!['remaining'] ?? '0'),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class SummeryItem extends StatelessWidget {

  const SummeryItem({super.key, required this.data});
  final SummeryItemData data;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            data.displayLabel,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Tooltip(
            message: data.tooltipValue,
            child: Text(
              data.displayValue,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: data.color,
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
