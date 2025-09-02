import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';

class PermissionService {
  static final Map<Permission, PermissionStatus> _permissionStatus = {};
  
  // Initialize method for consistency with other services
  Future<void> initialize() async {
    // No initialization needed as this is a static service
    // But we provide this method for consistency
  }

  /// Request location permission with proper handling
  static Future<PermissionStatus> requestLocationPermission() async {
    try {
      final status = await Permission.locationWhenInUse.status;
      
      if (status.isDenied) {
        // Request the permission first time
        final result = await Permission.locationWhenInUse.request();
        _permissionStatus[Permission.locationWhenInUse] = result;
        return result;
      } else if (status.isPermanentlyDenied) {
        // The user opted to never see the permission request dialog again
        await openAppSettings();
        return status;
      }
      
      _permissionStatus[Permission.locationWhenInUse] = status;
      return status;
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
      return PermissionStatus.denied;
    }
  }

  /// Request notification permission with proper handling
  static Future<PermissionStatus> requestNotificationPermission() async {
    try {
      final status = await Permission.notification.status;
      
      if (status.isDenied) {
        // Request the permission first time
        final result = await Permission.notification.request();
        _permissionStatus[Permission.notification] = result;
        return result;
      } else if (status.isPermanentlyDenied) {
        // The user opted to never see the permission request dialog again
        await openAppSettings();
        return status;
      }
      
      _permissionStatus[Permission.notification] = status;
      return status;
    } catch (e) {
      debugPrint('Error requesting notification permission: $e');
      return PermissionStatus.denied;
    }
  }

  /// Check if a permission is granted
  static bool isGranted(Permission permission) {
    try {
      return _permissionStatus[permission]?.isGranted ?? false;
    } catch (e) {
      debugPrint('Error checking permission status: $e');
      return false;
    }
  }

  /// Show a rationale dialog if the permission was denied
  static Future<bool> showPermissionRationale(
    BuildContext context, {
    required String title,
    required String message,
    required String denyButtonText,
    required String settingsButtonText,
  }) async {
    try {
      return await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: Text(denyButtonText),
            ),
            TextButton(
              onPressed: () async {
                await openAppSettings();
                if (context.mounted) {
                  Navigator.of(context).pop(true);
                }
              },
              child: Text(settingsButtonText),
            ),
          ],
        ),
      ) ?? false;
    } catch (e) {
      debugPrint('Error showing permission rationale: $e');
      return false;
    }
  }

  /// Request all required permissions for the app
  static Future<Map<Permission, PermissionStatus>> requestAllPermissions() async {
    try {
      final permissions = await [
        Permission.locationWhenInUse,
        Permission.notification,
      ].request();

      _permissionStatus.addAll(permissions);
      return permissions;
    } catch (e) {
      debugPrint('Error requesting all permissions: $e');
      return {};
    }
  }
}
