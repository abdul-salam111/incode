import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_code/config/Permissions/camera_permissions.dart';
import 'package:in_code/controllers/utiliti_screen_controller.dart';
import 'package:in_code/pages/relabel_projectscreen.dart';
import 'package:in_code/res/res.dart';
import 'package:in_code/widgets/camera_permission_dialog.dart';
import 'package:lottie/lottie.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/components.dart';
import 'package:vibration/vibration.dart';
import '../../widgets/round_button.dart';

class UtilitaScannerScreen extends StatefulWidget {
  const UtilitaScannerScreen({super.key});

  @override
  State<UtilitaScannerScreen> createState() => _UtilitaScannerScreenState();
}

class _UtilitaScannerScreenState extends State<UtilitaScannerScreen> with WidgetsBindingObserver {
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

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height;
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      backgroundColor: const Color(0xffDEDDDB),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: hasCameraPermission
                ? MobileScanner(
                    controller: controller.scannerController,
                    onDetect: (BarcodeCapture capture) async {
                      final scannedValue =
                          capture.barcodes.first.rawValue?.trim() ?? "";

                      if (scannedValue.isEmpty ||
                          scannedValue == controller.oldLabel.value ||
                          scannedValue == controller.newLabel.value ||
                          controller.isProcessing.value ||
                          controller.isShowingDialog.value) {
                        return;
                      }

                      controller.isProcessing.value = true;

                      if (await Vibration.hasVibrator()) {
                        Vibration.vibrate(duration: 100);
                      }

                      if (controller.oldLabel.isEmpty) {
                        controller.oldLabel.value = scannedValue;
                        controller.isShowingDialog.value = true;

                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => CustomScanDialog(
                            icon: Icons.check,
                            iconBackgroundColor: AppColors.successColor,
                            title: "Scansione Completata",
                            description:
                                "Ho letto il codice da sostituire, clicca ora su continua e inquadra il nuovo codice",
                            onCancel: () {
                              controller.resetLabels();
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            onContinue: () {
                              controller.isProcessing.value = false;
                              controller.isShowingDialog.value = false;
                              Navigator.pop(context);
                            },
                            oneButtonOnPressed: () {
                              controller.resetLabels();
                              Navigator.pop(context);
                            },
                          ),
                        );
                      } else if (controller.newLabel.isEmpty) {
                        controller.newLabel.value = scannedValue;
                        controller.isShowingDialog.value = true;

                        bool isSuccess = await controller.relabelObject();
                        print('====== ${isSuccess}');
                        await showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (_) => CustomScanDialog(
                            icon: isSuccess ? Icons.check : Icons.close,
                            iconBackgroundColor: isSuccess
                                ? AppColors.successColor
                                : AppColors.secondaryColor,
                            title: isSuccess
                                ? "Sostituzione Completata"
                                : "Errore Sostituzione",
                            titleColor:  isSuccess
                                ? AppColors.successColor
                                : AppColors.secondaryColor,
                            description: isSuccess
                                ? "Hai sostituito correttamente l'etichetta, ricordati di applicarla sull'oggetto."
                                : "Non è stato possibile sostituire l'etichetta, riprova o contatta l'assistenza.",
                            isOneButton: true,
                            oneButtontext:  isSuccess ?"Ok Fatto!" : "Riprova",
                            oneButtonColor: isSuccess
                                ? AppColors.successColor
                                : AppColors.secondaryColor,
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
                      }
                    },
                  )
                : const Center(child: Text('Camera permission required to scan.')),
          ),

          // Title
          Positioned(
            top: height * 0.13,
            left: 0,
            right: 0,
            child: Obx(
              () => Center(
                child: Text(
                  controller.oldLabel.isEmpty
                      ? "Scansiona etichetta vecchia"
                      : "Scansiona etichetta nuova",
                  style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          // Close button
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

          // Flash & camera buttons
          Obx(
            () => Positioned(
              bottom: height * .2,
              right: width * .1,
              left: width * .1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    style: IconButton.styleFrom(
                      backgroundColor: controller.isTorchOn.value
                          ? Colors.amber
                          : Colors.black.withOpacity(0.2),
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
                      backgroundColor: Colors.black.withOpacity(0.2),
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

          // Scanner animation
          Positioned(
            top: height * .1525,
            right: 0,
            left: 0,
            child: Lottie.asset("assets/scan.json"),
          ),

          // "Etichetta non leggibile" button
          Obx(
            () => controller.oldLabel.isEmpty
                ? Align(
                    alignment: Alignment.bottomCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: SizedBox(
                        width: 189,
                        height: 63,
                        child: RoundButton(
                          radius: 20,
                          text: "Etichetta non leggibile",
                          fontsize: 15,
                          backgroundColor: const Color(0xff830D17),
                          onPressed: () async {

                           controller.stopScanner();
controller.resetLabels();
await Future.delayed(Duration(milliseconds: 100));

Get.off(() => RelabelProjectScreen());
                          },
                        ),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
