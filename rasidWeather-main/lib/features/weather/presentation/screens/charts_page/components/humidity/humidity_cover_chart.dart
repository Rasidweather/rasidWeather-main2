import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../../common/constants/strings.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../data/models/weather_model.dart';

class HumidityCoverChart extends StatefulWidget {
  const HumidityCoverChart({super.key, required this.hours, this.isDialog = false});

  final List<Hour> hours;

  final bool isDialog;

  @override
  _HumidityCoverChartState createState() => _HumidityCoverChartState();
}

class _HumidityCoverChartState extends State<HumidityCoverChart> {
  _HumidityCoverChartState();

  ChartSeriesController<ChartSampleData, num>? seriesController;

  late List<ChartSampleData> chartData;

  late bool isLoadMoreView;
  late bool isNeedToUpdateView;
  late bool isDataUpdated;

  double? oldAxisVisibleMin;
  double? oldAxisVisibleMax;

  late ZoomPanBehavior _zoomPanBehavior;

  late GlobalKey<State> globalKey;

  @override
  void initState() {
    _initializeVariables();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.isDialog ? 200.h : 100.h,
      padding: EdgeInsets.zero,
      child: _buildInfiniteScrollingChart(),
    );
  }

  void _initializeVariables() {
    final int length = widget.hours.length < 7 ? widget.hours.length : 7;

    // Create chart data points from weather data
    chartData = <ChartSampleData>[
      ...List<ChartSampleData>.generate(length, (int index) {
        return ChartSampleData(xValue: index, y: widget.hours[index].humidity!);
      }),
    ];

    // Initialize control flags
    isLoadMoreView = false;
    isNeedToUpdateView = false;
    isDataUpdated = true;

    // Initialize chart components
    globalKey = GlobalKey<State>();
    _zoomPanBehavior = ZoomPanBehavior(enablePanning: true);
  }

  SfCartesianChart _buildInfiniteScrollingChart() {
    return SfCartesianChart(
      key: GlobalKey<State>(),
      onActualRangeChanged: _handleRangeChange,
      zoomPanBehavior: _zoomPanBehavior,
      plotAreaBorderWidth: 0,
      primaryXAxis: _buildXAxis(),
      primaryYAxis: _buildYAxis(),
      series: getSeries(),
    );
  }

  void _handleRangeChange(ActualRangeChangedArgs args) {
    if (args.orientation == AxisOrientation.horizontal) {
      if (isLoadMoreView) {
        args.visibleMin = oldAxisVisibleMin;
        args.visibleMax = oldAxisVisibleMax;
      }
      oldAxisVisibleMin = double.parse(args.visibleMin.toString());
      oldAxisVisibleMax = double.parse(args.visibleMax.toString());
    }
    isLoadMoreView = false;
  }

  NumericAxis _buildXAxis() {
    return NumericAxis(
        isVisible: false,
        name: 'XAxis',
        isInversed: true,
        enableAutoIntervalOnZooming: false,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: const MajorGridLines(width: 0),
        axisLabelFormatter: (AxisLabelRenderDetails details) => ChartAxisLabel(details.text.split('.')[0], null));
  }

  NumericAxis _buildYAxis() {
    return NumericAxis(
        isVisible: widget.isDialog,
        maximum: 1,
        minimum: 0,
        opposedPosition: true,
        axisLine: const AxisLine(width: .2),
        majorTickLines: const MajorTickLines(color: Colors.transparent),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel(details.text.convertToPercentage(), const TextStyle(fontSize: 10));
        });
  }

  List<CartesianSeries<ChartSampleData, num>> getSeries() {
    return <CartesianSeries<ChartSampleData, num>>[
      SplineAreaSeries<ChartSampleData, num>(
        animationDuration: AppStrings.animationDuration.toDouble(),
        dataSource: chartData,
        borderColor: const Color(0xffD1495B),
        gradient: LinearGradient(
          colors: <Color>[
            const Color(0xffD1495B).withAlpha(0),
            const Color(0xffD1495B).withAlpha((0.4 * 255).round()),
          ],
          stops: const <double>[0.2, 0.9],
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
        ),
        markerSettings: MarkerSettings(isVisible: widget.isDialog),
        xValueMapper: (ChartSampleData sales, _) => sales.xValue,
        yValueMapper: (ChartSampleData sales, _) => sales.y,
        onRendererCreated: (ChartSeriesController<ChartSampleData, num> controller) =>
            seriesController = controller as ChartSeriesController<ChartSampleData, num>?,
      ),
    ];
  }

  Widget getProgressIndicator() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsets.zero,
        child: Container(
          width: 50,
          alignment: Alignment.centerRight,
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: <Color>[Color.fromRGBO(33, 33, 33, 0.0), Color.fromRGBO(33, 33, 33, 0.74)], stops: <double>[0.0, 1]),
          ),
          child: const SizedBox(
            height: 35,
            width: 35,
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              backgroundColor: Colors.transparent,
              strokeWidth: 3,
            ),
          ),
        ),
      ),
    );
  }

  List<int> getIndexes(int length) {
    final List<int> indexes = <int>[];
    for (int i = length - 1; i >= 0; i--) {
      indexes.add(chartData.length - 1 - i);
    }
    return indexes;
  }

  int getRandomInt(int min, int max) {
    final Random random = Random();
    final int result = min + random.nextInt(max - min);
    return result < 50 ? 95 : result;
  }

  @override
  void dispose() {
    seriesController = null;
    super.dispose();
  }
}

class ChartSampleData {
  ChartSampleData({required this.xValue, required this.y});

  final num xValue;

  final num y;
}
