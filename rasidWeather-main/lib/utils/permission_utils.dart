import 'package:app_settings/app_settings.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static Future<bool> requestPermission(Permission permission) async {
    final PermissionStatus status = await permission.request();
    return status == PermissionStatus.granted;
  }

  // return permission status
  static Future<PermissionStatus> getPermissionStatus(Permission permission) async {
    return permission.status;
  }

  static Future<bool> checkPermissionStatus(Permission permission) async {
    final PermissionStatus status = await permission.status;
    return status == PermissionStatus.granted;
  }
  //method to check if permission is denied forever

  static Future<bool> shouldShowRequestPermissionRationale(Permission permission) async {
    return permission.shouldShowRequestRationale;
  }

  static Future<void> openAppSettings(Permission permission) async {
    if (permission == Permission.notification) {
      return AppSettings.openAppSettings();
    } else if (permission == Permission.camera) {
      return AppSettings.openAppSettings();
    } else if (permission == Permission.location) {
      return AppSettings.openAppSettings();
    }
  }
}
