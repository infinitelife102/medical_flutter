import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionManager {
  Future<bool> requestPermission() async {
    AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
    if (build.version.sdkInt >= 30) {
      var re = await Permission.manageExternalStorage.request();
      if (re.isGranted) {
        log("granted");
        return true;
      } else {
        log("denied");
        return false;
      }
    } else {
      if (await Permission.storage.isGranted) {
        log("granted");
        return true;
      } else {
        var result = await Permission.storage.request();
        if (result.isGranted) {
          log("granted");
          return true;
        } else {
          log("denied");
          return false;
        }
      }
    }
  }
}
