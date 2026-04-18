import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../../../../../../../common/constants/index.dart';
import '../../../../../../../utils/utils.dart';
import '../../../../../data/models/weather_model.dart';

class CloudCoverChart extends StatefulWidget {
  const CloudCoverChart({super.key, required this.hours, this.isDialog = false});

  final List<Hour> hours;

  final bool isDialog;

  @override
  CloudCoverChartState createState() => CloudCoverChartState();
}

class CloudCoverChartState extends State<CloudCoverChart> {
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
    // Limit the initial display to 7 hours or less
    final int length = widget.hours.length < 7 ? widget.hours.length : 7;

    // Create chart data points from weather data
    chartData = <ChartSampleData>[
      ...List<ChartSampleData>.generate(length, (int index) {
        return ChartSampleData(xValue: index, y: widget.hours.toList()[index].cloudCover!);
      }),
    ];

    // Initialize view state flags
    isLoadMoreView = false;
    isNeedToUpdateView = false;
    isDataUpdated = true;

    // Initialize chart controls
    globalKey = GlobalKey<State>();
    _zoomPanBehavior = ZoomPanBehavior(
      enablePanning: true,
    );
  }

  SfCartesianChart _buildInfiniteScrollingChart() {
    return SfCartesianChart(
      key: GlobalKey<State>(),
      onActualRangeChanged: _handleRangeChange,
      zoomPanBehavior: _zoomPanBehavior,
      plotAreaBorderWidth: 0,
      primaryXAxis: _buildXAxis(),
      primaryYAxis: _buildYAxis(),
      series: _buildSeries(),
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
        interval: 2,
        isInversed: true,
        enableAutoIntervalOnZooming: false,
        edgeLabelPlacement: EdgeLabelPlacement.shift,
        majorGridLines: const MajorGridLines(width: 0),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel(details.text.convertToPercentage(), null);
        });
  }

  NumericAxis _buildYAxis() {
    return NumericAxis(
        maximum: 1,
        minimum: 0,
        opposedPosition: true,
        isVisible: widget.isDialog,
        axisLine: const AxisLine(width: .2),
        majorTickLines: const MajorTickLines(color: Colors.transparent),
        axisLabelFormatter: (AxisLabelRenderDetails details) {
          return ChartAxisLabel(details.text.convertToPercentage(), null);
        });
  }

  List<CartesianSeries<ChartSampleData, num>> _buildSeries() {
    return <CartesianSeries<ChartSampleData, num>>[
      SplineAreaSeries<ChartSampleData, num>(
        animationDuration: AppStrings.animationDuration.toDouble(),
        dataSource: chartData,
        borderColor: const Color(0xffFFD166),
        gradient: LinearGradient(
          colors: <Color>[
            const Color(0xffFFD166).withAlpha(0),
            const Color(0xffFFD166).withAlpha((0.4 * 255).round()),
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
