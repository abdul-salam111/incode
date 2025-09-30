package com.example.in_code

import android.view.WindowManager
import android.os.Build
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * MainActivity with Brightness Control Feature
 * 
 * This activity implements platform-specific brightness control methods
 * that can be called from Flutter via platform channels.
 * 
 * Features:
 * - Set brightness to maximum without requiring system permissions
 * - Reset brightness to system control
 * - Maintain original brightness state
 * - Support for manual brightness control via notification panel
 */
class MainActivity : FlutterActivity() {
    companion object {
        private const val BRIGHTNESS_CHANNEL = "brightness_control"
        private const val TAG = "BrightnessControl"
    }
    
    private var originalBrightness: Float = WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, BRIGHTNESS_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "setBrightnessMax" -> {
                    setBrightnessToMaximum(result)
                }
                "resetBrightness" -> {
                    resetBrightnessToSystem(result)
                }
                "getPlatformInfo" -> {
                    getPlatformInfo(result)
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }
    
    /**
     * Set window brightness to maximum (1.0f)
     * This method doesn't require WRITE_SETTINGS permission
     */
    private fun setBrightnessToMaximum(result: MethodChannel.Result) {
        try {
            runOnUiThread {
                // Store original brightness if not already stored
                if (originalBrightness == WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE) {
                    originalBrightness = window.attributes.screenBrightness
                    println("$TAG: Original brightness stored: $originalBrightness")
                }
                
                // Set window brightness to maximum
                val layoutParams = window.attributes
                layoutParams.screenBrightness = 1.0f
                window.attributes = layoutParams
                
                println("$TAG: Brightness set to maximum (1.0f)")
            }
            result.success(true)
        } catch (e: Exception) {
            println("$TAG: Error setting brightness: ${e.message}")
            result.error("BRIGHTNESS_ERROR", "Failed to set brightness to maximum", e.message)
        }
    }
    
    /**
     * Reset window brightness to system control
     * This allows manual brightness control via notification panel
     */
    private fun resetBrightnessToSystem(result: MethodChannel.Result) {
        try {
            runOnUiThread {
                // Reset to system brightness control
                val layoutParams = window.attributes
                layoutParams.screenBrightness = WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
                window.attributes = layoutParams
                
                // Reset stored brightness
                originalBrightness = WindowManager.LayoutParams.BRIGHTNESS_OVERRIDE_NONE
                
                println("$TAG: Brightness reset to system control")
            }
            result.success(true)
        } catch (e: Exception) {
            println("$TAG: Error resetting brightness: ${e.message}")
            result.error("BRIGHTNESS_ERROR", "Failed to reset brightness", e.message)
        }
    }
    
    /**
     * Get platform information for debugging
     */
    private fun getPlatformInfo(result: MethodChannel.Result) {
        try {
            val info = mapOf(
                "platform" to "Android",
                "sdkVersion" to Build.VERSION.SDK_INT,
                "currentBrightness" to window.attributes.screenBrightness,
                "originalBrightness" to originalBrightness,
                "supportsWindowBrightness" to true
            )
            result.success(info)
        } catch (e: Exception) {
            result.error("PLATFORM_ERROR", "Failed to get platform info", e.message)
        }
    }
}
