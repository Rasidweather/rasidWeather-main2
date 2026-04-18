part of 'notifications_cubit.dart';

class NotificationsState extends BaseState {

  const NotificationsState({
    this.weatherNotifications = const <NotificationModel>[],
    this.customNotifications = const <NotificationModel>[],
    this.pageSize = 10,
    this.totalRows = 0,
    this.currentPage = 1,
    this.refresh = false,
    super.isLoading = false,
    super.error,
  });
  final List<NotificationModel> weatherNotifications;
  final List<NotificationModel> customNotifications;
  final int pageSize;
  final int totalRows;
  final int currentPage;
  @override
  final bool refresh;

  @override
  NotificationsState copyWith({
    List<NotificationModel>? weatherNotifications,
    List<NotificationModel>? customNotifications,
    int? pageSize,
    int? totalRows,
    int? currentPage,
    bool? refresh,
    bool? isLoading,
    String? error,
  }) {
    return NotificationsState(
      weatherNotifications: weatherNotifications ?? this.weatherNotifications,
      customNotifications: customNotifications ?? this.customNotifications,
      pageSize: pageSize ?? this.pageSize,
      totalRows: totalRows ?? this.totalRows,
      currentPage: currentPage ?? this.currentPage,
      refresh: refresh ?? this.refresh,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => <Object?>[
        weatherNotifications,
        customNotifications,
        pageSize,
        totalRows,
        currentPage,
        refresh,
        isLoading,
        error,
      ];
}
