import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../utils/utils.dart';
import '../../../data/models/weather_model.dart';

/// A custom SliverAppBar for the weather charts screen.
/// Shows a title, date range, and a scrollable TabBar for days.
@immutable
class WeatherChartsAppBar extends StatelessWidget {
  const WeatherChartsAppBar({
    super.key,
    required this.days,
    required this.tabController,
    required this.innerBoxIsScrolled,
  });

  final List<Day> days;
  final TabController tabController;
  final bool innerBoxIsScrolled;

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: false,
      centerTitle: true,
      elevation: 10,
      pinned: true,
      backgroundColor: Colors.white,
      toolbarHeight: 100.h,
      title: _buildTitle(context),
      forceElevated: innerBoxIsScrolled,
      bottom: _buildTabBar(context),
    );
  }

  Widget _buildTitle(BuildContext context) {
    final DateTime? start = _safeForecastStart(days.isNotEmpty ? days.first : null);
    final DateTime? end = _safeForecastStart(days.isNotEmpty ? days.last : null);

    return Row(
      children: <Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'weather.charts.title'.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 20.sp,
              ) ??
                  TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                  ),
            ),
            SizedBox(height: 5.h),
            Row(
              children: <Widget>[
                if (start != null && end != null) ...<Widget>[
                  Text(
                    formatDateTime(start, format: 'dd MMM').toString(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    ' | ',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    formatDateTime(end, format: 'dd MMM').toString(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ] else ...<Widget>[
                  Text(
                    'common.no_data'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
        const Spacer(),
      ],
    );
  }

  PreferredSizeWidget _buildTabBar(BuildContext context) {
    // لو مافي بيانات
    if (days.isEmpty || tabController.length == 0) {
      return TabBar(
        controller: tabController,
        tabs: <Widget>[
          Tab(text: 'common.no_data'.tr()),
        ],
      );
    }

    // لا نعرض Tabs أكثر من طول الكنترولر
    final int tabCount = tabController.length;
    final List<Day> daysToShow = days.length > tabCount ? days.sublist(0, tabCount) : days;

    // لو كل الأيام forecastStart فيها null
    final bool allNull = daysToShow.every((Day d) => d.forecastStart == null);
    if (allNull) {
      return TabBar(
        controller: tabController,
        isScrollable: true,
        tabs: <Widget>[
          Tab(text: 'common.no_data'.tr()),
        ],
      );
    }

    return TabBar(
      tabAlignment: TabAlignment.start,
      padding: EdgeInsets.only(bottom: 12.h, left: 12.w, right: 12.w),
      overlayColor: MaterialStateProperty.all(Colors.transparent),
      physics: const AlwaysScrollableScrollPhysics(),
      controller: tabController,
      isScrollable: true,
      indicatorSize: TabBarIndicatorSize.tab,
      labelColor: Colors.white,
      labelStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
        color: Colors.white,
      ) ??
          TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
      unselectedLabelStyle: Theme.of(context).textTheme.displayMedium?.copyWith(
        fontSize: 12.sp,
        fontWeight: FontWeight.w600,
      ) ??
          TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
          ),
      indicator: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: const Color(0xff2BB0DD),
      ),
      tabs: daysToShow.map(_buildDayTab).toList(),
    );
  }

  Widget _buildDayTab(Day day) {
    final DateTime? dt = _safeForecastStart(day);
    final String label = dt == null
        ? 'common.no_data'.tr()
        : '${'date.weekdays_full.${dt.weekday}'.tr()} | ${formatDateTime(dt, format: 'dd MMM')}';

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Tab(
        height: 40.h,
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  DateTime? _safeForecastStart(Day? day) {
    try {
      return day?.forecastStart;
    } catch (_) {
      return null;
    }
  }
}
