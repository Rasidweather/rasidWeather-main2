import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../../helper/router_helper.dart';
import '../../../../../../utils/date_utils.dart';
import '../../../../../../utils/ui_utils.dart';
import '../../../../../../views/base/ui_widget.dart';
import '../../../../../../views/base/weather_container.dart';
import '../../../../data/models/weather_model.dart';
import '../../../cubit/weather_cubit.dart';
import '../../../widgets/hours_widget/hourly_item.dart';

class HourlyWeather extends StatelessWidget {
  const HourlyWeather({super.key});

  static double? _tC(Hour h) => h.temperature;

  String _tempLabelKey(double? c) {
    if (c == null) return '';
    if (c <= 4) return 'weather.temperature_labels.very_cold';
    if (c >= 5 && c <= 16) return 'weather.temperature_labels.cold';
    if (c >= 16 && c <= 26) return 'weather.temperature_labels.mild';
    if (c >= 26 && c <= 35) return 'weather.temperature_labels.warm';
    if (c >= 35 && c <= 44) return 'weather.temperature_labels.hot';
    if (c >= 44 && c <= 60) return 'weather.temperature_labels.very_hot';
    return '';
  }

  String _formatAlertTime(String? raw) {
    if (raw == null || raw.isEmpty) return '';
    final DateTime? parsed = DateTime.tryParse(raw);
    if (parsed == null) return raw;
    return formatDateTime(parsed, format: 'HH:mm') ?? raw;
  }

  String _buildAlertMessage(ThunderstormSummary summary) {
    final String description = summary.description?.toString() ?? '';
    final String start = _formatAlertTime(summary.start);
    final String end = _formatAlertTime(summary.end);

    if (description.isEmpty) return '';
    if (start.isEmpty && end.isEmpty) {
      return 'تنبيه يتوقع حدوث $description';
    }
    if (start.isEmpty) {
      return 'تنبيه يتوقع حدوث $description حتى $end';
    }
    if (end.isEmpty) {
      return 'تنبيه يتوقع حدوث $description من الساعة $start';
    }
    return 'تنبيه يتوقع حدوث $description من الساعة $start إلى $end';
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<WeatherCubit, WeatherState>(
      buildWhen: (WeatherState prev, WeatherState curr) => prev.hours != curr.hours || prev.current != curr.current,
      builder: (BuildContext context, WeatherState state) {
        final List<Hour>? hours = state.hours;

        if (hours != null && hours.isNotEmpty) {
          final int count = hours.length < 24 ? hours.length : 24;

          final List<ThunderstormSummary> summaries = state.thunderstormSummary ?? <ThunderstormSummary>[];
          final int summaryLength = summaries.length > 2 ? 2 : summaries.length;

          return UiWidget(
            child: (Appearance appearance) => WeatherContainer(
              margin: const EdgeInsets.symmetric(horizontal: 20.0),
              padding: const EdgeInsets.fromLTRB(10, 15, 10, 10),

              // ✅ تعديل بسيط فقط داخل header: نخليها Column فيها المتنبئ + اسم اليوم
              header: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (summaryLength > 0)
                    ...List.generate(summaryLength, (int i) {
                      final String text = _buildAlertMessage(summaries[i]);
                      if (text.isEmpty) return const SizedBox.shrink();
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4.0),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Text(
                            '•  $text',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12.0.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      );
                    }),

                  Text(
                    'date.weekdays_short.${state.current!.meta!.asOf!.weekday}'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              leading: Text(
                'date.format.month_day'.tr(args: <String>[
                  state.current!.meta!.asOf!.day.toString(),
                  'date.months_short.${state.current!.meta!.asOf!.month}'.tr(),
                ]),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13.0.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              content: _HourlyForecastScroll(
                tiles: List.generate(count, (int i) {
                  final Hour h = hours[i];
                  final String? hh = formatDateTime(h.forecastStart!, format: 'HH:00');
                  final bool startOfDay = hh == '00:00';

                  return _HourTile(
                    hour: h,
                    tempLabel: _tempLabelKey(_tC(h)), // ← نرسل مفتاح الترجمة
                    showDayBadge: startOfDay,
                  );
                }),
                moreButton: _buildMoreButton(context),
              ),
            ),
          );
        }

        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        return const SizedBox.shrink();
      },

    );
  }

  Widget _buildMoreButton(BuildContext context) {
    return UiWidget(
      child: (Appearance ui) => GestureDetector(
        onTap: () => RouterHelper.getDaysScreenRoute(index: 0),
        child: SizedBox(
          width: 72,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(vertical: 40.h, horizontal: 10.w),
            decoration: BoxDecoration(
              color: convertHexaToColor(ui.textColor!),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              'common.more'.tr(),
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}

class _HourTile extends StatelessWidget {
  const _HourTile({
    required this.hour,
    required this.tempLabel,
    required this.showDayBadge,
  });

  final Hour hour;
  final String tempLabel;
  final bool showDayBadge;

  @override
  Widget build(BuildContext context) {
    const double kTileWidth = 72;

    return SizedBox(
      width: kTileWidth,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showDayBadge)
            Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'بداية يوم',
                style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.w600),
              ),
            )
          else
            const SizedBox(height: 16),

          HourlyItem(hour: hour),

          if (tempLabel.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6.0),
              child: Text(
                tempLabel.tr(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _HourlyForecastScroll extends StatefulWidget {
  const _HourlyForecastScroll({
    required this.tiles,
    required this.moreButton,
  });

  final List<Widget> tiles;
  final Widget moreButton;

  @override
  State<_HourlyForecastScroll> createState() => _HourlyForecastScrollState();
}

class _HourlyForecastScrollState extends State<_HourlyForecastScroll>
    with AutomaticKeepAliveClientMixin {
  final ScrollController _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      height: 190,
      child: ListView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.all(8.0),
        children: <Widget>[
          ...widget.tiles,
          widget.moreButton,
        ],
      ),
    );
  }
}
