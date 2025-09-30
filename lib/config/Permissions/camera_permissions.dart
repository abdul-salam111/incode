import 'package:flutter/material.dart';
import 'package:permission_guard/permission_guard.dart';
import 'package:permission_handler/permission_handler.dart';

class CameraPermissionGuard {
  static Widget wrapWithPermissionGuard({
    required Widget child,
    required Permission permission,
    PermissionGuardOptions? options,
    VoidCallback? onPermissionGranted,
    void Function(PermissionStatus status)? onPermissionStatusChanged,
  }) {
    return PermissionGuard(
      permission: permission,
      child: child,
      options: options ?? const PermissionGuardOptions(),
      onPermissionGranted: onPermissionGranted,
      onPermissionStatusChanged: onPermissionStatusChanged,
    );
  }

  static Future<bool> isCameraPermissionGranted() async {
    return await Permission.camera.isGranted;
  }
}
