import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

import '../../../../../../../bloc/app_cubit/app_cubit.dart';
import '../../../../../../../common/constants/strings.dart';
import '../../../../../data/models/weather_model.dart';

class PressureGauge extends StatefulWidget {
  const PressureGauge({super.key, required this.hours, this.isDialog = false});

  final List<Hour> hours;

  final bool isDialog;

  @override
  PressureGaugeState createState() => PressureGaugeState();
}

class PressureGaugeState extends State<PressureGauge> {
  bool isWebFullView = false;

  late double _size;

  @override
  void initState() {
    _configureChartSize();
    super.initState();
  }

  void _configureChartSize() {
    setState(() {
      _size = widget.isDialog ? 150.sp : 100.sp;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      height: _size,
      child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[if (widget.isDialog) Expanded(child: _buildPressureLegend()), _buildPressureGauge()]),
    );
  }

  Widget _buildPressureLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _buildLegendItem(color: const Color(0xff76C893), label: 'weather.charts.pressure.lowPressure'.tr()),
          _buildLegendItem(color: const Color(0xff8ED2E7), label: 'weather.charts.pressure.normalPressure'.tr()),
          _buildLegendItem(color: const Color(0xff96ADF3), label: 'weather.charts.pressure.highPressure'.tr()),
        ],
      ),
    );
  }

  Widget _buildLegendItem({required Color color, required String label}) {
    return Row(
      children: <Widget>[
        Container(
          height: 8.w,
          width: 8.w,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }

  Widget _buildPressureGauge() {
    if (widget.hours.isEmpty) {
      return SizedBox(
        height: _size,
        width: _size,
        child: Center(
          child: Text(
            'weather.noData'.tr(),
            style: TextStyle(
              color: Theme.of(context).colorScheme.onSurface,
              fontSize: 14.sp,
            ),
          ),
        ),
      );
    }
    return widget.isDialog ? _buildInteractivePressureGauge() : _buildStaticPressureGauge();
  }

  Widget _buildInteractivePressureGauge() {
    return BlocBuilder<AppCubit, AppStates>(
      builder: (BuildContext context, AppStates state) {
        final int index = state is ChangePressureState ? state.index : 0;
        if (index < 0 || index >= widget.hours.length) {
          return _buildGaugeContainer(pressure: widget.hours.first.pressure!, showValue: true);
        }
        return _buildGaugeContainer(pressure: widget.hours[index].pressure!, showValue: true);
      },
    );
  }

  Widget _buildStaticPressureGauge() {
    return _buildGaugeContainer(pressure: widget.hours.first.pressure!, showValue: false);
  }

  Widget _buildGaugeContainer({
    required double pressure,
    required bool showValue,
  }) {
    return SizedBox(
      height: _size,
      width: _size,
      child: SfRadialGauge(axes: <RadialAxis>[
        RadialAxis(
            showLabels: false,
            showTicks: false,
            startAngle: 270,
            endAngle: 270,
            radiusFactor: 0.8,
            axisLineStyle: const AxisLineStyle(
              thickness: 0.1,
              color: Color.fromARGB(30, 0, 169, 181),
              thicknessUnit: GaugeSizeUnit.factor,
              cornerStyle: CornerStyle.startCurve,
            ),
            pointers: <GaugePointer>[
              _buildRangePointer(),
              _buildMarkerPointer(pressure),
            ],
            annotations: <GaugeAnnotation>[
              if (showValue) _buildPressureAnnotation(pressure) else _buildUnitAnnotation(),
            ]),
      ]),
    );
  }

  RangePointer _buildRangePointer() {
    return RangePointer(
      value: 100,
      width: 0.1,
      sizeUnit: GaugeSizeUnit.factor,
      enableAnimation: true,
      animationDuration: AppStrings.animationDuration.toDouble(),
      animationType: AnimationType.linear,
      cornerStyle: CornerStyle.startCurve,
      gradient: const SweepGradient(colors: <Color>[
        Color(0xFF98A6F5),
        Color(0xFF8ED2E7),
        Color(0xFF76C893),
      ], stops: <double>[
        0.25,
        0.75,
        1
      ]),
    );
  }

  MarkerPointer _buildMarkerPointer(double pressure) {
    return MarkerPointer(
      value: _convertPressureToPercentage(pressure),
      markerType: MarkerType.circle,
      markerHeight: isWebFullView ? 25 : 8,
      markerWidth: isWebFullView ? 25 : 8,
      enableAnimation: true,
      animationDuration: AppStrings.animationDuration.toDouble(),
      animationType: AnimationType.linear,
      color: const Color(0xFFFFFFFF),
      borderWidth: 1,
      borderColor: const Color(0xFF8ED2E7),
    );
  }

  GaugeAnnotation _buildPressureAnnotation(double pressure) {
    return GaugeAnnotation(
      widget: Text(
        'hPa \n$pressure',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xff3D3C3C).withOpacity(.75),
        ),
      ),
    );
  }

  GaugeAnnotation _buildUnitAnnotation() {
    return GaugeAnnotation(
      positionFactor: 0.1,
      widget: Text(
        'hPa',
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w700,
          color: const Color(0xff3D3C3C).withOpacity(.75),
        ),
      ),
    );
  }

  double _convertPressureToPercentage(double pressure) {
    if (pressure > 1000) {
      return 70; // High pressure
    } else if (pressure <= 1000 || pressure >= 1013.25) {
      return 40; // Normal pressure
    } else {
      return 10; // Low pressure
    }
  }
}
