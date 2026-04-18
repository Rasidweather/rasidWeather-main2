import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../../common/constants/strings.dart';
import '../../../../../../../utils/date_utils.dart';
import '../../../../../data/models/weather_model.dart';

class WindyChartsWidget extends StatefulWidget {
  const WindyChartsWidget({super.key, required this.hours, this.isDialog = false});

  final List<Hour> hours;
  final bool isDialog;

  @override
  WindyChartsWidgetState createState() => WindyChartsWidgetState();
}

class WindyChartsWidgetState extends State<WindyChartsWidget> {
  late double _columnWidth;
  late double _columnSpacing;
  List<ChartData>? chartData;
  TooltipBehavior? _tooltipBehavior;
  late double height;

  @override
  void initState() {
    _tooltipBehavior = TooltipBehavior(enable: true);
    getHoursData();
    fullScreenConfig();
    super.initState();
  }

  void fullScreenConfig() {
    if (widget.isDialog) {
      setState(() {
        height = 200;
        _columnWidth = 0.6;
        _columnSpacing = 0.5;
      });
    } else {
      setState(() {
        height = 100;
        _columnWidth = 0.8;
        _columnSpacing = 0.8;
      });
    }
  }

  void getHoursData() {
    int length = widget.hours.length;
    if (!widget.isDialog) {
      length = widget.hours.length < 5 ? widget.hours.length : 5;
    } else {
      length = widget.hours.length < 7 ? widget.hours.length : 7;
    }
    chartData = <ChartData>[
      ...List<ChartData>.generate(length, (int index) {
        return ChartData(
          x: formatDateTime(
             widget.hours[index].forecastStart!,
            format: 'HH',
          ),
          y: widget.hours[index].windSpeed!,
          secondSeriesYValue: widget.hours[index].windGust!,
        );
      }),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(height: height, padding: const EdgeInsets.symmetric(vertical: 10), child: _buildSpacingColumnChart());
  }

  SfCartesianChart _buildSpacingColumnChart() {
    return SfCartesianChart(
      plotAreaBorderWidth: 0,
      primaryXAxis: const CategoryAxis(
        isVisible: false,
        isInversed: true,
        majorGridLines: MajorGridLines(width: 0),
      ),
      primaryYAxis: const NumericAxis(
        isVisible: false,
        interval: 5,
        opposedPosition: true,
        axisLine: AxisLine(width: 0),
        majorTickLines: MajorTickLines(size: 0),
      ),
      series: _getDefaultColumn(),
      legend: Legend(isVisible: widget.isDialog, position: LegendPosition.bottom),
      tooltipBehavior: _tooltipBehavior,
    );
  }

  ///Get the column series
  List<ColumnSeries<ChartData, String>> _getDefaultColumn() {
    return <ColumnSeries<ChartData, String>>[
      ColumnSeries<ChartData, String>(
        animationDuration: AppStrings.animationDuration.toDouble(),
        enableTooltip: false,
        isTrackVisible: true,
        borderRadius: BorderRadius.circular(10),
        trackColor: const Color(0xffE1E1E1),
        width: _columnWidth,
        spacing: _columnSpacing,
        dataSource: chartData,
        color: const Color(0xff07A0C3),
        xValueMapper: (ChartData sales, _) => sales.x!,
        yValueMapper: (ChartData sales, _) => sales.y,
        name: 'weather.charts.wind.speed'.tr(),
      ),
      ColumnSeries<ChartData, String>(
        animationDuration: AppStrings.animationDuration.toDouble(),
        enableTooltip: false,
        isTrackVisible: true,
        borderRadius: BorderRadius.circular(10),
        trackColor: const Color(0xffE1E1E1),
        dataSource: chartData,
        width: _columnWidth,
        spacing: _columnSpacing,
        color: const Color(0xffffa153),
        xValueMapper: (ChartData sales, _) => sales.x!,
        yValueMapper: (ChartData sales, _) => sales.secondSeriesYValue,
        name: 'weather.charts.wind.gust'.tr(),
      ),
    ];
  }

  @override
  void dispose() {
    chartData!.clear();
    super.dispose();
  }
}

class ChartData {
  ChartData({
    required this.x,
    required this.y,
    required this.secondSeriesYValue,
  });

  final String? x;
  final double y;
  final double secondSeriesYValue;
}
