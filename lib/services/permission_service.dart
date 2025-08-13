import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static const List<Permission> _requiredPermissions = [
    Permission.camera,
    Permission.location,
  ];

  static Future<bool> checkAllPermissions() async {
    for (final permission in _requiredPermissions) {
      if (!await permission.isGranted) {
        return false;
      }
    }
    return true;
  }

  static Future<void> requestAllPermissions() async {
    for (final permission in _requiredPermissions) {
      if (!await permission.isGranted) {
        await permission.request();
      }
    }
  }

  static Future<bool> requestAndCheckPermissions() async {
    await requestAllPermissions();
    return await checkAllPermissions();
  }

  static Future<PermissionStatus> getCameraPermissionStatus() async {
    return await Permission.camera.status;
  }

  static Future<PermissionStatus> getLocationPermissionStatus() async {
    return await Permission.location.status;
  }

  static Future<bool> shouldShowCameraRationale() async {
    return await Permission.camera.shouldShowRequestRationale;
  }

  static Future<bool> shouldShowLocationRationale() async {
    return await Permission.location.shouldShowRequestRationale;
  }
}
