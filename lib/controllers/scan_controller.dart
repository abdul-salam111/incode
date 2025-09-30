// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_code/config/brightness/brightness_service.dart';
import 'package:in_code/config/storage/sharedpref_keys.dart';
import 'package:in_code/controllers/navbar_controller.dart';
import 'package:in_code/controllers/projects_screen_controller.dart';
import 'package:in_code/models/scannedQrCode_data.dart';
import 'package:in_code/pages/assegnaOggetto.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_settings/app_settings.dart';


class QRCodeController extends GetxController {
  MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  ProjectScreenController projectScreenController = Get.put(
    ProjectScreenController(),
  );

  var isTorchOn = false.obs;
  var camera = false.obs;
  var isFrontCamera = false.obs;
  var previousBrightness = 0.5.obs; // Store previous brightness value
  var scannedImage = "".obs;
  var isLoading = false.obs;
  var subproject = false.obs;
  var scanError = "".obs;
  var isProcessing = false.obs;
  var scannedData = ''.obs;
  final isControllerInitializing = false.obs;
  var hasPermission = false.obs;
  var permissionDialogShown = false.obs;
  var isControllingBrightness = false.obs;

  bool _isScannerStarted = false;

  @override
  void onInit() {
    super.onInit();
    _checkPermissionDialogShown();
    _initializeCameraPosition();
  }

  void _initializeCameraPosition() {
    // Default to back camera (false = back camera, true = front camfluera)
    isFrontCamera.value = false;
    print("Initialized with Back camera");
  }

  // Get current camera position
  String getCurrentCameraPosition() {
    return isFrontCamera.value ? "Front" : "Back";
  }

  // Check if torch is available for current camera
  bool isTorchAvailable() {
    // Front camera typically doesn't have a physical torch
    // Back camera usually has torch capability
    return !isFrontCamera.value;
  }

  void _checkPermissionDialogShown() {
    permissionDialogShown.value = box.read('camera_permission_dialog_shown') ?? false;
  }

  // Method to reset permission dialog state (for testing purposes)
  void resetPermissionDialogState() {
    permissionDialogShown.value = false;
    box.remove('camera_permission_dialog_shown');
  }

  Future<bool> checkCameraPermission() async {
    final status = await Permission.camera.status;
    hasPermission.value = status == PermissionStatus.granted;
    return status == PermissionStatus.granted;
  }

  Future<PermissionStatus> getCameraPermissionStatus() async {
    return await Permission.camera.status;
  }

  Future<bool> requestCameraPermission() async {
    final status = await Permission.camera.request();
    hasPermission.value = status == PermissionStatus.granted;
    
    // Only show dialog if permission is permanently denied and dialog hasn't been shown
    if (status == PermissionStatus.permanentlyDenied && !permissionDialogShown.value) {
      showPermissionDialog();
    }
    
    return status == PermissionStatus.granted;
  }

  void showPermissionDialog() {
    permissionDialogShown.value = true;
    box.write('camera_permission_dialog_shown', true);
    
    Get.dialog(
      AlertDialog(
        title: const Text('Camera Permission Required'),
        content: const Text(
          'Camera permission is required to scan QR codes. Please go to Settings and enable camera access for this app.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              AppSettings.openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  Future<void> startScanner() async {
    try {
      final subprojects = projectScreenController.getAllSubprojects.value;
      print("Starting scanner...${subprojects}");
      print("Subproject value: ${subprojects.associationList}");
      subproject.value = true;

      if (!_isScannerStarted) {
        // Ensure we start with the correct camera direction based on current state
        final CameraFacing desiredFacing = isFrontCamera.value
            ? CameraFacing.front
            : CameraFacing.back;
        await scannerController.start(cameraDirection: desiredFacing);
        _isScannerStarted = true;
        debugPrint('Scanner started with camera: '
            '${isFrontCamera.value ? 'Front' : 'Back'}');
      }
    } catch (e) {
      print("Scanner start failed: $e");
    }
  }

  void stopScanner() {
    if (_isScannerStarted) {
      scannerController.stop();
      _isScannerStarted = false;
      subproject.value = false;
    }
  }

  @override
  void onClose() {
    stopScanner();
    // resetLightState();
     if (isControllingBrightness.value) {
      BrightnessService.resetBrightness();
    }
    super.onClose();
  }

  // Future<void> resetLightState() async {
  //   try {
  //     if (isTorchOn.value) {
  //       if (isFrontCamera.value) {
  //         // Reset brightness for front camera
  //         await _resetBrightness();
  //       } else {
  //         // Toggle torch for back camera
  //         await scannerController.toggleTorch();
  //       }
  //       isTorchOn.value = false;
  //       print("Light state reset for ${getCurrentCameraPosition()} camera");
  //     }
  //   } catch (e) {
  //     print("Reset light error: $e");
  //   }
  // }

  void toggleTorch() async {
    await scannerController.toggleTorch();
      isTorchOn.value = !isTorchOn.value;
    // debugPrint('Torch toggled. Front camera: $, Torch: $_isTorchOn');
    // Only toggle brightness when BOTH front camera AND torch are active
    if (isFrontCamera.value && isTorchOn.value) {
      final success = await BrightnessService.toggleBrightness();
      if (success) {
          isControllingBrightness.value = BrightnessService.isControllingBrightness;
      }
    } else {
      // Reset brightness when torch is off or not front camera
      if (isControllingBrightness.value) {
        final success = await BrightnessService.resetBrightness();
        if (success) {
         
            isControllingBrightness.value = false;

        }
      }
    }
  }

  // Future<void> _setMaximumBrightness() async {
  //   try {
  //     print("Flutter: Calling setMaxBrightness");
  //     const platform = MethodChannel('com.example.brightness');
  //     // Native method that stores current brightness and sets to maximum
  //     await platform.invokeMethod('setMaxBrightness');
  //     print("Flutter: Maximum brightness set natively");
  //   } catch (e) {
  //     print("Error setting brightness: $e");
  //   }
  // }

  // Future<void> _resetBrightness() async {
  //   try {
  //     print("Flutter: Calling restoreBrightness");
  //     const platform = MethodChannel('com.example.brightness');
  //     // Native method that restores previous brightness
  //     await platform.invokeMethod('restoreBrightness');
  //     print("Flutter: Brightness restored natively");
  //   } catch (e) {
  //     print("Error resetting brightness: $e");
  //   }
  // }

   void switchCamera() async {
     final bool wasFront = isFrontCamera.value;
     final bool wasTorchOn = isTorchOn.value;
     debugPrint('Switching camera. Was front: $wasFront, torch on: $wasTorchOn');

     // If torch/brightness is on, turn it off BEFORE switching
     if (wasTorchOn) {
       if (wasFront) {
         // Front camera uses brightness control – reset it
         if (isControllingBrightness.value) {
           final success = await BrightnessService.resetBrightness();
           if (success) {
             isControllingBrightness.value = false;
           }
         }
       } else {
         // Back camera uses physical torch – ensure it is turned off
         try {
           await scannerController.toggleTorch();
         } catch (_) {}
       }
       // Update UI state for torch button color
       isTorchOn.value = false;
     }

     // Now switch camera
     await scannerController.switchCamera();
     isFrontCamera.value = !wasFront;

     debugPrint('Camera switched. Is front now: ${isFrontCamera.value}, torch on: ${isTorchOn.value}');
   }

  Future<ScannedQrCodeDataModel?> processQrCodeAndValidateSubproject(
    BarcodeCapture capture,
  ) async {
    isLoading.value = true;

    try {
      // 📦 Extract QR code
      final barcode = capture.barcodes.firstWhere(
        (b) => b.rawValue != null && b.rawValue!.isNotEmpty,
        orElse: () => Barcode(rawValue: null),
      );
      final code = barcode.rawValue;
      print("this is code ${code}");
      if (code == null) throw Exception("QR code vuoto o non valido.");

      scannedImage.value = code;
      stopScanner();

      // 🌐 API Request
      final uri = Uri.parse('http://www.in-code.cloud:8888/api/1/object/get');

      final request = http.MultipartRequest('POST', uri)
        ..fields['version'] = '2'
        ..fields['id_user'] = "${box.read(userId)}"
        ..fields['scanned_code'] = code;
      final url = Uri.tryParse(code);
      final baseUrl = (url != null && url.hasScheme && url.hasAuthority)
          ? '${url.scheme}://${url.host}'
          : null;
      print('==== ${baseUrl}');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      print('responsser body ${responseBody}');
       final Map<String, dynamic> responseData = jsonDecode(responseBody);

  final int idTypeObject = responseData['id_type_object'] ?? 0;
  final dynamic descriptionTypeObject = responseData['description_type_object'];
  final int idObject = responseData['id_object'] ?? 0;
  final navbarController = Get.find<NavbarController>();
  if (idTypeObject == 0 || descriptionTypeObject == null || idObject == 0) {
    Get.to(() => const AssegnaOggetto());
  } 

      if (response.statusCode != 200) {
        print("Response status code: ${response.statusCode}");
        throw Exception("Errore nella scansione: $responseBody");
      }
      //  final jsonResponse = json.decode(responseBody);

      //     if ((jsonResponse['id_type_object'] == null || jsonResponse['id_type_object'] == 0) &&
      //     baseUrl == "https://www.in-code.it") {
      //     final naviagtionController = Get.find<NavbarController>();
      //     naviagtionController.navigatetoTypeObjectScreen(scannedImage.value);
      //   return null;
      // }
      /// ✅ Correct check: null or empty list

      final subprojectList =
          projectScreenController.getAllSubprojects.value.objectsList;
      print("Subproject List: $subprojectList");

      // ✅ Only parse now
      final data = ScannedQrCodeDataModel.fromJson(json.decode(responseBody));
      return data;
    } catch (e) {
      throw Exception("Errore durante la scansione: $e");
    } finally {
      await startScanner();
      isLoading.value = false;
    }
  }


}