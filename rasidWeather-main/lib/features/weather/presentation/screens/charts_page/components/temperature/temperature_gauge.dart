import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../../common/constants/strings.dart';
import '../../../../../../../utils/date_utils.dart';
import '../../../../../data/models/weather_model.dart';

class TemperatureGauge extends StatefulWidget {
  const TemperatureGauge({super.key, required this.hours, this.isDialog = false});

  final List<Hour> hours;

  final bool isDialog;

  @override
  TemperatureGaugeState createState() => TemperatureGaugeState();
}

class TemperatureGaugeState extends State<TemperatureGauge> {
  late double _columnWidth;

  late double _columnSpacing;

  List<TemperatureData>? _chartData;

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
        _height = 180;
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
    _chartData = List<TemperatureData>.generate(length, (int index) {
      final Hour hour = widget.hours[index];
      return TemperatureData(
        hour: formatDateTime(
          hour.forecastStart!,
          format: 'HH',
        ),
        temperature: hour.temperature!,
        apparentTemperature: hour.temperatureApparent!,
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

  Widget _buildColumnChart() {
    return  Directionality(
      textDirection: ui.TextDirection.ltr,
      child: SfCartesianChart(
        enableAxisAnimation: true,
        plotAreaBorderWidth: 0,
        primaryXAxis: const CategoryAxis(
          isVisible: false,
          majorGridLines: MajorGridLines(width: 0),
        ),
        primaryYAxis: const NumericAxis(
          isVisible: false,
          opposedPosition: true,
          interval: 5,
          axisLine: AxisLine(width: 0),
          majorTickLines: MajorTickLines(size: 0),
        ),
        series: _buildChartSeries(),
        legend: Legend(isVisible: widget.isDialog, position: LegendPosition.bottom),
        tooltipBehavior: _tooltipBehavior,
      ),
    );
  }

  List<ColumnSeries<TemperatureData, String>> _buildChartSeries() {
    return <ColumnSeries<TemperatureData, String>>[
      // Apparent temperature series
      ColumnSeries<TemperatureData, String>(
        animationDuration: AppStrings.animationDuration.toDouble(),
        enableTooltip: false,
        isTrackVisible: true,
        borderRadius: BorderRadius.circular(10),
        trackColor: const Color(0xffE1E1E1),
        dataSource: _chartData!.reversed.toList(),
        width: _columnWidth,
        spacing: _columnSpacing,
        color: const Color(0xff07A0C3),
        xValueMapper: (TemperatureData data, _) => data.hour!,
        yValueMapper: (TemperatureData data, _) => data.apparentTemperature,
        name: 'weather.charts.temperature.feels_like'.tr(),
      ),
      // Actual temperature series
      ColumnSeries<TemperatureData, String>(
        animationDuration: AppStrings.animationDuration.toDouble(),
        enableTooltip: false,
        isTrackVisible: true,
        borderRadius: BorderRadius.circular(10),
        trackColor: const Color(0xffE1E1E1),
        width: _columnWidth,
        spacing: _columnSpacing,
        dataSource: _chartData!.reversed.toList(),
        color: const Color(0xffff3e3b),
        xValueMapper: (TemperatureData data, _) => data.hour!,
        yValueMapper: (TemperatureData data, _) => data.temperature,
        name: 'weather.charts.temperature.title'.tr(),
      ),
    ];
  }

  @override
  void dispose() {
    _chartData?.clear();
    super.dispose();
  }
}

class TemperatureData {
  TemperatureData({
    required this.hour,
    required this.temperature,
    required this.apparentTemperature,
  });

  final String? hour;

  final double temperature;

  final double apparentTemperature;
}
