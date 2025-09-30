import 'package:flutter/services.dart';

class BrightnessService {
  static const MethodChannel _brightnessChannel = MethodChannel('brightness_control');
  static bool _isControllingBrightness = false;
  
  static bool get isControllingBrightness => _isControllingBrightness;
  
  static Future<void> initialize() async {
    // Initialize if needed
  }
  
  static void dispose() {
    if (_isControllingBrightness) {
      resetBrightness();
    }
  }
  
  /// Set brightness to maximum
  static Future<bool> setBrightnessMax() async {
    try {
      await _brightnessChannel.invokeMethod('setBrightnessMax');
      _isControllingBrightness = true;
      return true;
    } catch (e) {
      print('Error setting brightness: $e');
      return false;
    }
  }
  
  /// Reset brightness to system control
  static Future<bool> resetBrightness() async {
    try {
      await _brightnessChannel.invokeMethod('resetBrightness');
      _isControllingBrightness = false;
      return true;
    } catch (e) {
      print('Error resetting brightness: $e');
      return false;
    }
  }
  
  /// Toggle brightness between max and normal
  static Future<bool> toggleBrightness() async {
    if (_isControllingBrightness) {
      return await resetBrightness();
    } else {
      return await setBrightnessMax();
    }
  }
}