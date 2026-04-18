import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../../common/constants/strings.dart';
import '../../../../../../../utils/date_utils.dart';
import '../../../../../data/models/weather_model.dart';

class RainGauge extends StatefulWidget {
  const RainGauge({super.key, required this.hours, this.isDialog = false});

  final List<Hour> hours;

  final bool isDialog;

  @override
  RainGaugeState createState() => RainGaugeState();
}

class RainGaugeState extends State<RainGauge> {
  late double _columnWidth;

  late double _columnSpacing;

  List<PrecipitationData>? _chartData;

  TooltipBehavior? _tooltipBehavior;

  late double _height;

  @override
  void initState() {
    super.initState();
    _tooltipBehavior = TooltipBehavior(enable: true);
    _initializeChartData();
    _configureChartSize();
  }

  void _configureChartSize() {
    setState(() {
      if (widget.isDialog) {
        _height = 200;
        _columnWidth = 0.6;
        _columnSpacing = 0.5;
      } else {
        _height = 100;
        _columnWidth = 0.8;
        _columnSpacing = 0.8;
      }
    });
  }

  void _initializeChartData() {
    final int length = _calculateDataLength();
    _chartData = List<PrecipitationData>.generate(length, (int index) {
      final Hour hour = widget.hours[index];
      return PrecipitationData(
        hour: formatDateTime(
           hour.forecastStart!,
          format: 'HH',
        ),
        amount: hour.precipitationAmount!,
        chance: hour.precipitationChance!,
      );
    });
  }

  int _calculateDataLength() {
    final int totalLength = widget.hours.length;
    if (!widget.isDialog) {
      return totalLength < 5 ? totalLength : 5;
    }
    return totalLength < 7 ? totalLength : 7;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _height,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: _buildColumnChart(),
    );
  }

  SfCartesianChart _buildColumnChart() {
    return SfCartesianChart(
      enableAxisAnimation: true,
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        isVisible: false,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
        maximum: 1,
        minimum: 0,
        opposedPosition: true,
        interval: 5,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _buildChartSeries(),
      legend: Legend(isVisible: widget.isDialog, position: LegendPosition.bottom),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  List<ColumnSeries<PrecipitationData, String>> _buildChartSeries() {
    return <ColumnSeries<PrecipitationData, String>>[
      // Precipitation chance series
      ColumnSeries<PrecipitationData, String>(
        animationDuration: AppStrings.animationDuration.toDouble(),
        enableTooltip: false,
        isTrackVisible: true,
        borderRadius: BorderRadius.circular(10),
        trackColor: const Color(0xffE1E1E1),
        dataSource: _chartData!.reversed.toList(),
        width: _columnWidth,
        spacing: _columnSpacing,
        color: const Color(0xff33d6fc),
        xValueMapper: (PrecipitationData data, _) => data.hour!,
        yValueMapper: (PrecipitationData data, _) => data.chance,
        name: 'weather.charts.rain.chance'.tr(),
      ),
      // Precipitation amount series
      ColumnSeries<PrecipitationData, String>(
        animationDuration: AppStrings.animationDuration.toDouble(),
        enableTooltip: false,
        isTrackVisible: true,
        borderRadius: BorderRadius.circular(10),
        trackColor: const Color(0xffE1E1E1),
        width: _columnWidth,
        spacing: _columnSpacing,
        dataSource: _chartData!.reversed.toList(),
        color: const Color(0xff104794),
        xValueMapper: (PrecipitationData data, _) => data.hour!,
        yValueMapper: (PrecipitationData data, _) => data.amount,
        name: 'weather.charts.rain.amount'.tr(),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData?.clear();
    super.dispose();
  }
}

class PrecipitationData {
  PrecipitationData({
    required this.hour,
    required this.amount,
    required this.chance,
  });

  final String? hour;

  final double amount;

  final double chance;
}
