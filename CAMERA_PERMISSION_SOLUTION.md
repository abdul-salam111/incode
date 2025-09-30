# Camera Permission Solution for "Allow Once" Expiration

## Problem Description

The issue occurs when users select "Allow Once" for camera permissions on both iOS and Android. After the app is closed and restarted, `permission_handler` continues to report `Permission.camera.isGranted` as `true`, even though the temporary permission has expired. This causes the scanner to start but fail silently, confusing users.

## Root Cause

1. **iOS**: "Allow Once" permissions expire when the app is backgrounded or closed
2. **Android**: Temporary permissions (especially on Android 11+ / API 30+) can expire
3. **permission_handler limitation**: The plugin doesn't properly detect expired temporary permissions
4. **MobileScanner**: Fails silently when camera access is denied, even if permission appears granted

## Solution Overview

The solution implements a multi-layered approach:

### 1. Enhanced Permission Manager (`lib/config/Permissions/camera_permissions.dart`)

**Key Features:**
- **Cross-platform validation**: Works on both iOS and Android
- **Camera access validation**: Actually tests camera functionality, not just permission status
- **Permission caching**: Avoids repeated validation for recent successful checks
- **Expired permission detection**: Identifies when "Allow Once" permissions have expired
- **User-friendly dialogs**: Clear messaging about expired permissions

**Core Methods:**
```dart
// Main permission check with validation
static Future<bool> ensureCameraPermission(BuildContext context, {String? reason})

// Validates actual camera access by testing MobileScanner
static Future<bool> _validateCameraAccess()

// Enhanced check with caching
static Future<bool> checkCameraPermissionWithValidation(BuildContext context, {String? reason})

// Cache management
static void resetPermissionCache()
static void forceRevalidation()
```

### 2. Updated Scanner Screens

All scanner screens now use the enhanced permission checking:

- `lib/pages/scanner.dart`
- `lib/pages/utilia_scanner.dart`
- `lib/pages/relabel_scanner.dart`

**Key Changes:**
- Use `PermissionManager.checkCameraPermissionWithValidation()` instead of basic permission checks
- Handle scanner start failures gracefully
- Reset permission cache on app resume
- Show user-friendly error dialogs

### 3. Enhanced Error Handling

**Scanner Controller Updates (`lib/controllers/scan_controller.dart`):**
- Better error handling in `startScanner()`
- Proper state management on failures
- Re-throw errors for calling code to handle

### 4. App Lifecycle Management

**Main App (`lib/main.dart`):**
- Reset permission cache on app startup
- Handle app resume scenarios

**Scanner Screens:**
- Implement `WidgetsBindingObserver` for lifecycle management
- Reset permission cache when app resumes
- Re-validate permissions after app backgrounding

## How It Works

### 1. Permission Request Flow

```dart
// 1. Request permission
final status = await Permission.camera.request();

// 2. If granted, validate actual camera access
if (status.isGranted) {
  final isValid = await _validateCameraAccess();
  if (!isValid) {
    // Permission expired - show dialog
    await _showExpiredPermissionDialog(context);
    return false;
  }
  return true;
}
```

### 2. Camera Access Validation

```dart
static Future<bool> _validateCameraAccess() async {
  try {
    final controller = MobileScannerController();
    await controller.start();
    await Future.delayed(const Duration(milliseconds: 500));
    await controller.stop();
    await controller.dispose();
    return true;
  } catch (e) {
    print('Camera access validation failed: $e');
    return false;
  }
}
```

### 3. Caching Strategy

- Cache successful permission checks for 1 hour
- Reset cache on app startup and resume
- Force revalidation when needed

## Platform-Specific Handling

### iOS
- Handles "Allow Once" permission expiration
- Uses `NSCameraUsageDescription` in Info.plist
- Validates camera access after permission grant

### Android
- Handles temporary permissions on Android 11+
- Uses proper camera permissions in AndroidManifest.xml
- Validates camera access after permission grant

## Testing

### Test Cases Covered

1. **Fresh Install**: No permissions → Request → Grant → Work
2. **"Allow Once" on iOS**: Grant once → Close app → Reopen → Request again
3. **"Allow Once" on Android**: Grant once → Close app → Reopen → Request again
4. **Permanent Denial**: Deny → Show settings dialog
5. **App Backgrounding**: Grant → Background → Resume → Revalidate
6. **Scanner Failure**: Grant → Camera fails → Show error dialog

### Test File
- `test/permission_test.dart`: Basic validation tests

## Usage

### In Scanner Screens

```dart
Future<void> _checkPermissionAndStartScanner() async {
  final granted = await PermissionManager.checkCameraPermissionWithValidation(
    context,
    reason: "We need camera access to scan QR codes.",
  );
  
  if (granted) {
    try {
      await controller.startScanner();
      setState(() => showScanner = true);
    } catch (e) {
      await _handleScannerStartFailure();
    }
  } else {
    controller.stopScanner();
    setState(() => showScanner = false);
  }
}
```

### App Lifecycle Management

```dart
@override
void didChangeAppLifecycleState(AppLifecycleState state) {
  if (state == AppLifecycleState.resumed) {
    PermissionManager.resetPermissionCache();
    _checkPermissionAndStartScanner();
  }
}
```

## Benefits

1. **Reliable Detection**: Actually tests camera functionality, not just permission status
2. **Cross-Platform**: Works on both iOS and Android
3. **User-Friendly**: Clear error messages and retry options
4. **Performance**: Caches successful checks to avoid repeated validation
5. **Robust**: Handles various edge cases and failure scenarios

## Troubleshooting

### Common Issues

1. **Scanner starts but shows black screen**: Permission expired, will be caught by validation
2. **Permission dialog doesn't show**: Check Info.plist and AndroidManifest.xml
3. **App crashes on permission request**: Ensure proper error handling in scanner screens

### Debug Information

The solution includes comprehensive logging:
- Permission request results
- Camera validation attempts
- Scanner start failures
- Cache state changes

## Future Improvements

1. **Background Permission Monitoring**: Real-time permission state tracking
2. **Custom Permission UI**: Branded permission request dialogs
3. **Analytics**: Track permission grant/denial rates
4. **A/B Testing**: Different permission request strategies 