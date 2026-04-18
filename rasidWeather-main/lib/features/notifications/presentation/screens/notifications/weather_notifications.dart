import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/core.dart';
import '../../../../../data/model/article_model.dart';

import '../../../../../helper/router_helper.dart';
import '../../../../../views/screens/articles_screen/cards/card4.dart';
import '../../../../language/cubit/language_cubit.dart';
import '../../../data/models/notification_model.dart';
import '../../cubit/notifications_cubit.dart';

class WeatherNotifications extends StatelessWidget {
  const WeatherNotifications({super.key});

  Future<void> getData(BuildContext context) async {
    await context.read<NotificationsCubit>().getNotificationsList(type: NotificationType.weather);
  }

  Widget notificationItem(BuildContext context, NotificationModel weatherNotification) {
    final ArticleModel article = ArticleModel(
      id: weatherNotification.reviewableId,
      title: weatherNotification.title ?? '',
      description: weatherNotification.content,
      mainImage: MainImage(
        main: weatherNotification.image ?? '',
        original: weatherNotification.image ?? '',
      ),
      createdAt: weatherNotification.createdAt,
      isPremium: false,
      hasFavorited: false,
      isLiked: false,
    );

    return FutureBuilder<bool>(
      future: context.read<NotificationsCubit>().isNotificationSeen(weatherNotification.id!),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        final bool isSeen;
        if (snapshot.connectionState == ConnectionState.waiting) {
          isSeen = false;
        } else {
          isSeen = snapshot.data ?? false;
        }
        return Card4(
          article: article,
          notify: !isSeen,
          color: isSeen ? Theme.of(context).scaffoldBackgroundColor : Theme.of(context).colorScheme.onSecondary,
          onTap: () async {
            final bool isArabicLanguage = context.read<LanguageCubit>().isArabic();
            if (weatherNotification.reviewableId != null && isArabicLanguage) {
              RouterHelper.getArticleDetailsRoute(weatherNotification.reviewableId!, article: article);
            }
            context.read<NotificationsCubit>().markNotificationAsSeen(weatherNotification.id!);
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get data when widget is first built
    getData(context);

    return RefreshIndicator(
      onRefresh: () => getData(context),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (BuildContext context, NotificationsState state) {
          if (!state.isLoading && state.weatherNotifications.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.weatherNotifications.length,
              itemBuilder: (BuildContext context, int index) {
                return notificationItem(context, state.weatherNotifications[index]);
              },
            );
          }
          if (!state.isLoading && state.error != null) {
            return Center(
              child: EmptyWidget(
                icon: Icons.notifications_none,
                title: '',
                subtitle: state.error.toString(),
              ),
            );
          }
          if (!state.isLoading && state.weatherNotifications.isNotEmpty) {
            return const Center(
              child: EmptyWidget(
                icon: Icons.notifications_none,
                title: 'لا توجد اشعارات مخصصة حتى الآن',
                subtitle: 'سوف تتلقى اشعارات هنا',
              ),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
