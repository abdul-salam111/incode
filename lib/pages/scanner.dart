import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_code/controllers/navbar_controller.dart';
import 'package:in_code/controllers/projects_screen_controller.dart';
import 'package:in_code/res/colors.dart';
import 'package:in_code/widgets/camera_permission_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../controllers/scan_controller.dart';

class ScannerScreen extends StatefulWidget {
  const ScannerScreen({super.key});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
} 

class _ScannerScreenState extends State<ScannerScreen>
    with WidgetsBindingObserver {
  final controller = Get.put(QRCodeController());
  bool showScanner = true;
  bool _settingsDialogShown = false;
  bool _isScannerInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkCameraPermissionAndStart();
  }

  Future<void> _checkCameraPermissionAndStart() async {
    final status = await Permission.camera.status;

    if (status.isGranted) {
      await _initializeScanner();
      return;
    }

    if (status.isDenied) {
      // request once
      final result = await Permission.camera.request();
      if (result.isGranted) {
        await _initializeScanner();
        return;
      }
      // if still denied (not permanent) or permanent, show dialog
      _showSettingsDialogOnceIfNeeded(result);
    } else if (status.isPermanentlyDenied || status.isRestricted) {
      _showSettingsDialogOnceIfNeeded(status);
    } else {
      // other states (e.g., limited) - try request
      final result = await Permission.camera.request();
      if (result.isGranted) {
        await _initializeScanner();
        return;
      }
      _showSettingsDialogOnceIfNeeded(result);
    }
  }

  Future<void> _initializeScanner() async {
    if (_isScannerInitialized) return;
    
    try {
      // Add a small delay to ensure proper surface initialization
      await Future.delayed(const Duration(milliseconds: 100));
      await controller.startScanner();
      _isScannerInitialized = true;
      print('scanner initialized');
    } catch (e) {
      print("Scanner initialization failed: $e");
      // Retry once after a delay
      await Future.delayed(const Duration(milliseconds: 500));
      try {
        await controller.startScanner();
        _isScannerInitialized = true;
      } catch (e) {
        print("Scanner retry failed: $e");
      }
    }
  }

void _showSettingsDialogOnceIfNeeded(PermissionStatus status) {
  if (_settingsDialogShown) return;

  if (status.isDenied || status.isPermanentlyDenied || status.isRestricted) {
    _settingsDialogShown = true;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return CameraPermissionDialog(
          onClose: () {
            Navigator.of(context).pop();
          },
          onSettings: () async {
            Navigator.of(context).pop();
            await openAppSettings();
          },
        );
      },
    );
  }
}

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Color(0xffDEDDDB),
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xffFFFFFF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xffDEDDDB),
        body: SafeArea(
          child: Stack(
            children: [
              // Scanner view with error handling
              Align(
                alignment: Alignment.center,
                child: ClipRRect(
                  child: MobileScanner(
                    controller: controller.scannerController,
                    onDetect: (capture) => startQRCodeProcess(capture),
                  ),
                ),
              ),
              
              // Scanner controls
              Positioned(
                bottom: height * .08,
                right: width * .1,
                left: width * .1,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: controller.isTorchOn.value
                            ? Colors.amber
                            : Colors.black.withAlpha((0.2 * 255).toInt()),
                      ),
                      onPressed: controller.toggleTorch,
                      icon: Image.asset(
                        "assets/images/flash.png",
                        height: 30,
                        width: 30,
                        color: Colors.white,
                      ),
                    )),
                    IconButton(
                      style: IconButton.styleFrom(
                        backgroundColor: Colors.black.withAlpha(
                          (0.2 * 255).toInt(),
                        ),
                      ),
                      onPressed: controller.switchCamera,
                      icon: Image.asset(
                        "assets/images/camera.png",
                        height: 30,
                        width: 30,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              
              // Scanner overlay animation
              Positioned(
                top: height * .1525,
                right: 0,
                left: 0,
                child: Lottie.asset("assets/scan.json"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _isScannerInitialized = false;
    controller.stopScanner();
    // controller.resetLightState();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print('didChangeAppLifecycleState ${state}');
    switch (state) {
      case AppLifecycleState.resumed:
        if (!_isScannerInitialized) {
          _checkCameraPermissionAndStart();
        } else {
          // Restart scanner if it was already initialized
          controller.startScanner();
        }
        break;
      case AppLifecycleState.paused:
      case AppLifecycleState.inactive:
      case AppLifecycleState.detached:
        controller.stopScanner();
        break;
      default:
        break;
    }
  }

  Future<void> startQRCodeProcess(BarcodeCapture capture) async {
    if (controller.isProcessing.value) return;

    controller.isProcessing.value = true;

    try {
      await HapticFeedback.vibrate();
      await controller.scannerController.stop();
      print('this is capture ${capture.barcodes}');
      print('this is capture ${capture.raw}');
      print('this is capture ${capture}');
      final data = await controller.processQrCodeAndValidateSubproject(capture);
      print("Scanned data: ${data.toString()}");
      await Future.delayed(const Duration(milliseconds: 500));
      final navbarController = Get.find<NavbarController>();
     
      final projectController = Get.find<ProjectScreenController>();
      print(
        "Selected project ID: ${data!.idProject } and ${data.idPoint}",
      );
      navbarController.navigatetoDettagliOggettoScreen(data);
    } catch (e) {
      controller.subproject.value = false;
      controller.scanError.value = e.toString();
      await controller.scannerController.stop();
      controller.subproject.value = false;
      controller.scanError.value = e.toString();
      await controller.scannerController.stop();
    } finally {
      controller.isProcessing.value = false;
      controller.subproject.value = false;
    }
  }
}
