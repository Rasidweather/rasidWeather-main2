import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/core.dart';
import '../../data/models/notification_model.dart';
import '../cubit/notifications_cubit.dart';
import 'notifications/custom_notifications.dart';
import 'notifications/weather_notifications.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  NotificationScreenState createState() => NotificationScreenState();
}

class NotificationScreenState extends State<NotificationScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final int _weatherUnreadCount = 0;
  final int _contentUnreadCount = 0;
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Tab> _tabs = <Tab>[Tab(text: 'news notifications'.tr()), Tab(text: 'custom notifications'.tr())];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
    _tabController.addListener(_handleTabChange);
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _loadNotifications();
    await _loadUnreadCounts();
  }

  void _handleTabChange() {
    if (!_tabController.indexIsChanging) {
      setState(() {
        _currentIndex = _tabController.index;
      });
      _pageController.animateToPage(
        _tabController.index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentIndex = page;
      _tabController.animateTo(page);
    });
  }

  Future<void> _loadNotifications() async {
    if(mounted) {
      try {
        await context.read<NotificationsCubit>().getNotificationsList(type: NotificationType.weather);
        await context.read<NotificationsCubit>().getNotificationsList(type: NotificationType.custom);
      } catch (e) {
        printLog('Error loading notifications: $e');
      }
    }
  }

  Future<void> _onRefresh() async {
    await _loadNotifications();
    await _loadUnreadCounts();
  }

  Future<void> _loadUnreadCounts() async {
    if (!mounted) {
      return;
    }

    // final int weatherCount = await DatabaseHelper.instance.getUnreadCount();
    // final int contentCount = await DatabaseHelper.instance.getUnreadCount(type: NotificationType.content);
    //
    // if (mounted) {
    //   setState(() {
    //     _weatherUnreadCount = weatherCount;
    //     _contentUnreadCount = contentCount;
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('notifications.title'.tr()),
        centerTitle: true,
      ),
      bottomNavigationBar: Container(
          height: 70.h,
          decoration: BoxDecoration(
            color: Colors.orange.shade200,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Icon(CupertinoIcons.delete_simple,color: Colors.white,size: 18,),
              Text('notifications.auto_delete_message'.tr(), style: TextStyle(color: Colors.white, fontSize: 12.sp)),
              SizedBox(height: 10.h)
            ],
          )
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Column(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: _buildTab(
                      index: 0,
                      title: 'تنبيهات الطقس',
                      unreadCount: _weatherUnreadCount,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _buildTab(
                      index: 1,
                      title: 'تنبيهات متخصصة',
                      unreadCount: _contentUnreadCount,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: _handlePageChanged,
                physics: const BouncingScrollPhysics(),
                children: const <Widget>[
                  WeatherNotifications(),
                  CustomNotifications(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required int index,
    required String title,
    required int unreadCount,
  }) {
    final bool isSelected = _currentIndex == index;

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        setState(() {
          _currentIndex = index;
        });
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutCubic,
        );
        _tabController.animateTo(index);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.grey[300],
          borderRadius: BorderRadius.circular(25),
          boxShadow: isSelected ? <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ] : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (unreadCount > 0) ...<Widget>[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  unreadCount.toString(),
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabChange);
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }
}
