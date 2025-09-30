import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_code/config/Permissions/camera_permissions.dart';
import 'package:in_code/controllers/navbar_controller.dart';
import 'package:in_code/controllers/projects_screen_controller.dart';
import 'package:in_code/pages/scan_errorScreen.dart';
import 'package:in_code/pages/utiliti_screen.dart';
import 'package:in_code/res/colors.dart';
import 'package:in_code/widgets/camera_permission_dialog.dart';
import 'package:in_code/widgets/success_popup.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../controllers/utiliti_screen_controller.dart';

class RelabelScanner extends StatefulWidget {
  const RelabelScanner({super.key});

  @override
  State<RelabelScanner> createState() => _RelabelScannerState();
}

class _RelabelScannerState extends State<RelabelScanner>
    with WidgetsBindingObserver {
  //  final projectController = Get.put(ProjectScreenController());
  final controller = Get.put(UtilitiScreenController());
  bool showScanner = true;
  bool hasCameraPermission = false;
  bool _isPermissionCheckInProgress = false;
  bool _hasShownPermissionDialog = false;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPermissionAndStartScanner();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _hasShownPermissionDialog = false; // Reset when navigating back
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 150), () {
      _checkPermissionAndStartScanner();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && hasCameraPermission) {
      controller.stopScanner();
      controller.startScanner();
    }
  }

  Future<void> _checkPermissionAndStartScanner() async {
    if (_isPermissionCheckInProgress) return;
    _isPermissionCheckInProgress = true;
    try {
      final status = await Permission.camera.request();
      final granted = status.isGranted;
      if (!mounted) return;
      setState(() {
        hasCameraPermission = granted;
      });
      if (!granted) {
        _hasShownPermissionDialog = true;
        return;
      }
      await Future.delayed(const Duration(milliseconds: 300));
       controller.startScanner();
    } catch (e) {
      debugPrint("Permission check or scanner start failed: $e");
    } finally {
      _isPermissionCheckInProgress = false;
    }
  }

  Future<void> _handleScannerStartFailure() async {
    await showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => CameraPermissionDialog(
        onClose: () {
          Navigator.of(context).pop();
        },
        onSettings: () async {
          Navigator.of(context).pop();
          await openAppSettings();
        },
      ),
    );
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    controller.stopScanner();
    controller.resetLightState();
    super.dispose();
  }

  void rebuildScannerWithDelay() async {
    setState(() => showScanner = false);
    await Future.delayed(const Duration(milliseconds: 400));
    try {
      await controller.scannerController.stop();
      controller.scannerController.dispose();
      controller.scannerController = MobileScannerController();
      controller.startScanner();
    } catch (e) {
      print("Failed to start scanner: $e");
    } finally {
      if (mounted) {
        setState(() => showScanner = true);
      }
    }
  }

  Future<void> startQRCodeProcess(BarcodeCapture capture) async {
    if (controller.isProcessing.value) return;
    // if (!controller.subproject.value) {
    //   print("QR scan blocked: No subproject selected.");
    //   return;
    // }

    // controller.isProcessing.value = true;

    try {
      await HapticFeedback.vibrate();
      await controller.scannerController.stop();
      final data = await controller.relabelScanObject(capture);
      print("Scanned data: ${data}");
      await Future.delayed(const Duration(milliseconds: 500));
     if(data == true ){
      await showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => CustomScanDialog(
    icon: Icons.check,
    iconBackgroundColor: AppColors.successColor,
    title: "Sostituzione Completata",
    titleColor: AppColors.successColor,
    description: "Hai sostituito correttamente l'etichetta, ricordati di applicarla sull'oggetto.",
    isOneButton: true,
    oneButtontext: "Ok Fatto!",
    oneButtonColor: AppColors.successColor,
    onCancel: () {
      controller.resetLabels();
      Navigator.pop(context);
      Navigator.pop(context);
    },
    onContinue: () {
      controller.resetLabels();
      Navigator.pop(context);
      Navigator.pop(context);
    },
    oneButtonOnPressed: () {
       controller.scannerController.stop();
      controller.scannerController.dispose();
      controller.resetLabels();
       Future.delayed(Duration(milliseconds: 200), () {
    final navbarController = Get.find<NavbarController>();
    navbarController.gotoUtility(); // Index for UtilitiScreen
  });
    }
  ),
);
     } else{
       await controller.scannerController.stop();
      await controller.scannerController.stop();
     await showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => CustomScanDialog(
    icon: Icons.close,
    iconBackgroundColor: AppColors.secondaryColor,
    title: "Errore Sostituzione",
    titleColor: AppColors.secondaryColor,
    description: "Non è stato possibile sostituire l'etichetta, riprova o contatta l'assistenza.",
    isOneButton: true,
    oneButtontext: "Riprova",
    oneButtonColor: AppColors.secondaryColor,
    onCancel: () {
      controller.resetLabels();
      Navigator.pop(context);
      Navigator.pop(context);
    },
    onContinue: () {
      controller.resetLabels();
      Navigator.pop(context);
      Navigator.pop(context);
    },
    oneButtonOnPressed: () {

      controller.resetLabels();
    Navigator.pop(context);
      Navigator.pop(context);
    },
  ),
);
     }
    
    } catch (e) {
      await controller.scannerController.stop();
      await controller.scannerController.stop();
     await showDialog(
  context: context,
  barrierDismissible: false,
  builder: (_) => CustomScanDialog(
    icon: Icons.close,
    iconBackgroundColor: AppColors.secondaryColor,
    title: "Errore Sostituzione",
    titleColor: AppColors.secondaryColor,
    description: "Non è stato possibile sostituire l'etichetta, riprova o contatta l'assistenza.",
    isOneButton: true,
    oneButtontext: "Riprova",
    oneButtonColor: AppColors.secondaryColor,
    onCancel: () {
      controller.resetLabels();
      Navigator.pop(context);
      Navigator.pop(context);
    },
    onContinue: () {
      controller.resetLabels();
      Navigator.pop(context);
      Navigator.pop(context);
    },
    oneButtonOnPressed: () {
      controller.resetLabels();
      Navigator.pop(context);
    },
  ),
);
    } finally {
      controller.isProcessing.value = false;
      // controller.subproject.value = false;
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
              Align(
                alignment: Alignment.center,
                child: showScanner && hasCameraPermission
                    ? MobileScanner(
                        controller: controller.scannerController,
                        onDetect: (capture) => startQRCodeProcess(capture),
                      )
                    : const Center(child: Text('Camera permission required to scan.')),
              ),
              Positioned(
                top: height * 0.05,
                right: width * 0.05,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                    controller.stopScanner();
                    controller.resetLabels();
                  },
                  icon: const Icon(Icons.close, color: Colors.white, size: 35),
                ),
              ),
              Obx(
                () => Positioned(
                  bottom: height * .08,
                  right: width * .1,
                  left: width * .1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        style: IconButton.styleFrom(
                          backgroundColor: controller.isTorchOn.value
                              ? Colors.amber
                              : Colors.black.withAlpha((0.2 * 255).toInt()),
                        ),
                        onPressed: controller.toggleLight,
                        icon: Image.asset(
                          "assets/images/flash.png",
                          height: 30,
                          width: 30,
                          color: Colors.white,
                        ),
                      ),
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
              ),
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
}
