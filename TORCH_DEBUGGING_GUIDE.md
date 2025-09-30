# Torch Toggle Debugging Guide

## Problem
The torch toggle button is not working properly. This guide helps identify where the issue might be.

## Debugging Steps

### 1. Check Button Press
- ✅ Added debug prints to all torch buttons
- ✅ Check console for "Torch button pressed!" messages
- ✅ Verify button is actually being pressed

### 2. Check Scanner Initialization
- ✅ Added checks to ensure scanner is started before torch toggle
- ✅ Added debug prints for scanner state
- ✅ Verify `_isScannerStarted` is true

### 3. Check Torch Functionality
- ✅ Added debug prints in `toggleLight()` method
- ✅ Check console for "Attempting to toggle torch..." messages
- ✅ Verify `scannerController.toggleTorch()` is being called

### 4. Check State Management
- ✅ Added debug prints for `isTorchOn.value` changes
- ✅ Verify state is being updated correctly
- ✅ Check if UI is reflecting state changes

## Debug Console Output to Look For

### Expected Output (Working):
```
Torch button pressed!
Attempting to toggle torch... Current state: false
Torch toggled: true
```

### Possible Issues:

#### Issue 1: Button Not Pressed
```
// No output - button not being pressed
```

#### Issue 2: Scanner Not Started
```
Torch button pressed!
Scanner not started, starting first...
Attempting to toggle torch... Current state: false
Torch toggled: true
```

#### Issue 3: Torch Error
```
Torch button pressed!
Attempting to toggle torch... Current state: false
Toggle light error: [error message]
```

#### Issue 4: State Not Updating
```
Torch button pressed!
Attempting to toggle torch... Current state: false
Torch toggled: true
// But button doesn't turn yellow
```

## Files Modified for Debugging:
- `lib/controllers/scan_controller.dart` - Added debug prints and error handling
- `lib/controllers/utiliti_screen_controller.dart` - Added debug prints and error handling
- `lib/pages/scanner.dart` - Added button press debugging
- `lib/pages/relabel_scanner.dart` - Added button press debugging
- `lib/pages/utilia_scanner.dart` - Added button press debugging

## Test Steps:
1. Open any scanner page
2. Press the torch button
3. Check console output
4. Verify button color changes
5. Check if torch actually turns on/off

## Common Solutions:

### If Button Not Pressed:
- Check if button is properly positioned
- Verify touch target size
- Check for overlapping widgets

### If Scanner Not Started:
- Ensure camera permissions are granted
- Check if scanner initialization is working
- Verify mobile_scanner version compatibility

### If Torch Error:
- Check device torch availability
- Verify mobile_scanner version
- Check for permission issues

### If State Not Updating:
- Verify Obx widget is properly observing state
- Check if UI is rebuilding correctly
- Verify state variable is properly declared as observable

## Next Steps:
1. Run the app and test torch functionality
2. Check console output for debug messages
3. Identify which step is failing
4. Apply appropriate fix based on debug output 