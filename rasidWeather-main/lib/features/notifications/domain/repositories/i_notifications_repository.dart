import '../../../../core/repositories/base_repository.dart';
import '../../../../data/model/base/api_response.dart';
import '../../data/models/notification_model.dart';

abstract class INotificationsRepository extends BaseRepository<NotificationModel> {
  Future<ApiResponse> getNotificationsApi(Map<String, dynamic> params);

  Future<bool> subscribeTopic(String topic);
  Future<bool> unsubscribeTopic(String topic);
  Future<bool> developerTopic({String topic});

  Future<bool> sendFcmToken({
    required String token,
    required String platform, // android | ios | web
    String? deviceId,
    String? appVersion,
  });
}
