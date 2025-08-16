import 'dart:io';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PermissionsService {
  /// Request permission to access gallery/images
  static Future<bool> requestImagesPermission() async {
    if (!Platform.isAndroid) return true;

    // Android 13+ me PHOTOS permission use karo, otherwise fallback storage
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

  /// Request storage permission for PDFs/files
  static Future<bool> requestPdfPermission() async {
    if (!Platform.isAndroid) return true;

    final androidInfo = await DeviceInfoPlugin().androidInfo;
    int sdkInt = androidInfo.version.sdkInt;

    if (sdkInt >= 30) {
      // Android 11+ (Scoped Storage)
      if (await Permission.manageExternalStorage.isGranted) return true;
      var status = await Permission.manageExternalStorage.request();
      return status.isGranted;
    } else {
      // Android 10 and below
      var status = await Permission.storage.request();
      return status.isGranted;
    }
  }

  /// Open app settings if permission is denied permanently
  static Future<void> openSettingsDialog() async {
    bool opened = await openAppSettings();
    if (!opened) {
      debugPrint("Failed to open app settings");
    }
  }
}
