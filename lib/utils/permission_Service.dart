import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionsService {
  static Future<bool> requestImagesPermission() async {
    if (!Platform.isAndroid) return true;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 33) {
      var status = await Permission.photos.status;
      if (!status.isGranted) {
        status = await Permission.photos.request();
      }
      return status.isGranted;
    } else {
      var status = await Permission.storage.status;
      if (!status.isGranted) {
        status = await Permission.storage.request();
      }
      return status.isGranted;
    }
  }

  static Future<bool> requestPdfPermission() async {
    if (!Platform.isAndroid) return true;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 30) {
      if (await Permission.manageExternalStorage.isGranted) return true;
      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    } else {
      var status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  static Future<void> openSettingsDialog() async {
    bool opened = await openAppSettings();
    if (!opened) {
      debugPrint("Failed to open app settings");
    }
  }
}
