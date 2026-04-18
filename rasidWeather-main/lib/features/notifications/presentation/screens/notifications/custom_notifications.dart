import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/core.dart';
import '../../../../../data/model/article_model.dart';
import '../../../../../views/base/cached_image.dart';
import '../../../../../views/base/weather_container.dart';
import '../../../../../views/screens/articles_screen/cards/card4.dart';

import '../../../data/models/notification_model.dart';
import '../../cubit/notifications_cubit.dart';

class CustomNotifications extends StatefulWidget {
  const CustomNotifications({super.key});

  @override
  CustomNotificationsState createState() => CustomNotificationsState();
}

class CustomNotificationsState extends State<CustomNotifications> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  Future<void> getData() async {
    await context
        .read<NotificationsCubit>()
        .getNotificationsList(type: NotificationType.custom);
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async => getData(),
      child: BlocBuilder<NotificationsCubit, NotificationsState>(
        builder: (BuildContext context, NotificationsState state) {
          // حالة وجود بيانات
          if (!state.isLoading && state.customNotifications.isNotEmpty) {
            return ListView.builder(
              padding: const EdgeInsets.only(top: 30, bottom: 20),
              physics: const AlwaysScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: state.customNotifications.length,
              itemBuilder: (_, int index) {
                return notificationItem(state.customNotifications[index]);
              },
            );
          }

          // حالة خطأ
          if (!state.isLoading && state.error != null) {
            return Center(
              child: EmptyWidget(
                icon: Icons.notifications_none,
                title: '',
                subtitle: state.error.toString(),
              ),
            );
          }

          // حالة لا توجد إشعارات
          if (!state.isLoading && state.customNotifications.isEmpty) {
            return const Center(
              child: EmptyWidget(
                icon: Icons.notifications_none,
                title: 'لا توجد اشعارات مخصصة حتى الآن',
                subtitle: 'سوف تتلقى اشعارات هنا',
              ),
            );
          }

          // حالة التحميل
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget notificationItem(NotificationModel customNotification) {
    // نحول النوتيفيكيشن إلى ArticleModel لاستخدام Card4
    final ArticleModel article = ArticleModel(
      title: customNotification.title,
      description: customNotification.content,
      mainImage: customNotification.image != null
          ? MainImage(main: customNotification.image)
          : null,
      id: customNotification.id,
      createdAt: customNotification.createdAt,
      isPremium: false,
      hasFavorited: false,
      isLiked: false,
      source: '',
      videoUrl: '',
      views: '0',
      countComments: '0',
      categories: <Category>[],
    );

    return FutureBuilder<bool>(
      future: context
          .read<NotificationsCubit>()
          .isNotificationSeen(customNotification.id!),
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
          color: isSeen
              ? Theme.of(context).scaffoldBackgroundColor
              : Theme.of(context).colorScheme.onSecondary,
          onTap: () async {
            navigateDialog(
              context: context,
              child: customNotificationDialog(customNotification, article),
            );
          },
        );
      },
    );
  }

  Widget customNotificationDialog(
      NotificationModel customNotification,
      ArticleModel article,
      ) {
    // نعلِّم الإشعار كمقروء عند فتح الديالوج
    context
        .read<NotificationsCubit>()
        .markNotificationAsSeen(customNotification.id!);

    return SizedBox(
      height: MediaQuery.sizeOf(context).height * .5,
      child: WeatherContainer(
        radius: 25,
        color: Colors.white,
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 2.h),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Handle bar للبوتوم شيت
            Container(
              width: 40.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 10.h, top: 5.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Colors.grey[300],
              ),
            ),

            // زر الإغلاق
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                icon: Icon(Icons.close, color: Colors.grey[700]),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Close',
              ),
            ),

            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // الصورة
                  if (customNotification.image != null)
                    Hero(
                      tag: customNotification.image!,
                      child: Container(
                        height: 200.h,
                        width: double.infinity,
                        margin: EdgeInsets.symmetric(vertical: 10.h),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: CustomCacheImage(
                            imageUrl: customNotification.image!,
                            radius: 15.0,
                          ),
                        ),
                      ),
                    ),

                  // العنوان
                  if (article.title != null)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        article.title!,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),

                  // المحتوى
                  if (article.description != null)
                    Padding(
                      padding: EdgeInsets.only(bottom: 15.h),
                      child: Text(
                        article.description!,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.black54,
                          height: 1.5,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
