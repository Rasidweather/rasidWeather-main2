import 'dart:async';
import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../common/widgets/loader_widget.dart';
import '../../features/cities/presentation/cubit/cities_cubit.dart';
import '../../features/notifications/presentation/cubit/notifications_cubit.dart';
import '../../features/weather/data/models/weather_model.dart';
import '../../features/weather/presentation/cubit/weather_cubit.dart';
import '../../generated/assets.dart';
import '../../helper/router_helper.dart';
import '../../utils/ui_utils.dart';
import 'image_widget.dart';
import 'subscription_button.dart';

class HomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key, required this.appearance});

  final Appearance appearance;

  @override
  State<HomeAppBar> createState() => _HomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _HomeAppBarState extends State<HomeAppBar> {
  ScrollNotificationObserverState? _scrollNotificationObserver;
  bool _scrolledUnder = false;
  StreamSubscription<void>? _notificationsSubscription;
  late NotificationsCubit _notificationsCubit;
  final ValueNotifier<bool> _hasUnreadNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    super.initState();
    _notificationsCubit = context.read<NotificationsCubit>();
    _setupNotificationsListener();
    // Load notifications when app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkUnreadNotifications();
      // context.read<NotificationsCubit>().getNotifications(refresh: true);
    });
  }

  void _setupNotificationsListener() {
    _notificationsSubscription =
        _notificationsCubit.onNotificationsUpdate.listen((_) {
      _checkUnreadNotifications();
    });
  }

  Future<void> _checkUnreadNotifications() async {
    final bool hasUnread = await _notificationsCubit.hasUnreadNotifications();
    _hasUnreadNotifier.value = hasUnread;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _scrollNotificationObserver?.removeListener(_handleScrollNotification);
    _scrollNotificationObserver = ScrollNotificationObserver.maybeOf(context);
    _scrollNotificationObserver?.addListener(_handleScrollNotification);
  }

  @override
  void dispose() {
    _notificationsSubscription?.cancel();
    _hasUnreadNotifier.dispose();
    if (_scrollNotificationObserver != null) {
      _scrollNotificationObserver!.removeListener(_handleScrollNotification);
      _scrollNotificationObserver = null;
    }
    super.dispose();
  }

  void _handleScrollNotification(ScrollNotification notification) {
    if (notification is ScrollUpdateNotification) {
      final bool oldScrolledUnder = _scrolledUnder;
      final ScrollMetrics metrics = notification.metrics;
      switch (metrics.axisDirection) {
        case AxisDirection.up:
          // Scroll view is reversed
          _scrolledUnder = metrics.extentAfter > 0;
        case AxisDirection.down:
          _scrolledUnder = metrics.extentBefore > 0;
        case AxisDirection.right:
        case AxisDirection.left:
          break;
      }

      if (_scrolledUnder != oldScrolledUnder) {
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isVideo = widget.appearance.type == 'video';
    final Color backgroundColor = isVideo
        ? Colors.transparent
        : convertHexaToColor(widget.appearance.background!.first);
    final Color textColor = convertHexaToColor(widget.appearance.textColor!);
    Widget appBarContent = ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: _scrolledUnder ? 6 : 3, // 👈 Blur ناعم جدًا
          sigmaY: _scrolledUnder ? 6 : 3,
        ),
        child: ColoredBox(
          color: backgroundColor.withOpacity(
            _scrolledUnder ? 0.35 : 0.25, // 👈 شفافية ناعمة
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const SizedBox(width: 10),

                  /// CITY BUTTON
                  Expanded(
                    child: InkWell(
                      onTap: () async => RouterHelper.getCitiesRoute(),
                      child: Row(
                        children: <Widget>[
                          BlocBuilder<WeatherCubit, WeatherState>(
                            buildWhen: (WeatherState prev, WeatherState curr) =>
                            prev.isLoading != curr.isLoading,
                            builder: (BuildContext context, WeatherState weatherState) {
                              return SizedBox(
                                width: 24,
                                height: 23.76,
                                child: weatherState.isLoading
                                    ? const LoaderWidget()
                                    : ImageView.svgAsset(
                                  Assets.svgLocation,
                                  color: textColor,
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 10),
                          BlocBuilder<CitiesCubit, CitiesState>(
                            buildWhen: (CitiesState p, CitiesState c) =>
                            p.selectedCity != c.selectedCity,
                            builder: (BuildContext context, CitiesState state) {
                              if (state is SelectedCitySuccess) {
                                return Text(
                                  state.selectedCity!.name!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: textColor,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w500,
                                  ),
                                );
                              }
                              return Text(
                                'common.loading'.tr(),
                                style: TextStyle(color: textColor),
                              );
                            },
                          ),
                          const SizedBox(width: 6),
                          ImageView.svgAsset(
                            Assets.svgDownArrow,
                            color: textColor.withOpacity(0.9),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),

                  const SubscriptionButton(),

                  ValueListenableBuilder<bool>(
                    valueListenable: _hasUnreadNotifier,
                    builder: (_, bool hasUnread, __) {
                      return IconButton(
                        onPressed: () =>
                            RouterHelper.getNotificationRoute(),
                        icon: ImageView.svgAsset(
                          hasUnread
                              ? Assets.svgNotificationBadge
                              : Assets.svgNotification,
                          color: hasUnread ? null : textColor,
                        ),
                      );
                    },
                  ),
                ],
              ),

              // خط فاصل خفيف جدًا
              if (!_scrolledUnder)
                const Divider(
                  height: 1,
                  thickness: 0.3,
                  color: Colors.white24,
                ),
            ],
          ),
        ),
      ),
    );

    return appBarContent;


    if (_scrolledUnder && !isVideo) {
      appBarContent = ColoredBox(
        color: backgroundColor.withOpacity(.7),
        child: ClipRRect(
            child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: appBarContent)),
      );
    }

    return appBarContent;
  }
}
