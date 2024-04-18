import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<bool> requestLocationPermission(
      {bool openSetting = true}) async {
    var status = await Permission.location.request();
    Logger().d("status: $status");
    if (status.isDenied || status.isPermanentlyDenied) {
      return false;
    }
    return true;
  }

  static Future<bool> requestCameraPermission() async {
    var status = await Permission.camera.request();
    Logger().d("status: $status");
    if (status.isDenied || status.isPermanentlyDenied) {
      return false;
    }
    return true;
  }
}
