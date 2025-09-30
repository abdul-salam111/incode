import 'dart:convert';
import 'dart:io';
import 'package:in_code/config/brightness/brightness_service.dart';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_code/config/exceptions/app_exceptions.dart';

import 'package:in_code/config/storage/sharedpref_keys.dart';
import 'package:in_code/models/category.dart';
import 'package:in_code/models/relabel_model.dart';
import 'package:in_code/pages/no_internet_screen.dart';
import 'package:in_code/repositories/projects_repository.dart';
import 'package:in_code/repositories/relabel_repository.dart';
import 'package:in_code/utils/utils.dart';
import 'package:mobile_scanner/mobile_scanner.dart';



class UtilitiScreenController extends GetxController {
  static const platform = MethodChannel('com.example.brightness');
  
  MobileScannerController scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );
 final searchFocusNode = FocusNode();
  final isProcessing = false.obs;
  final isShowingDialog = false.obs;
  final isTorchOn = false.obs;
  final camera = false.obs;
  final isFrontCamera = false.obs;
  final previousBrightness = 0.5.obs; // Store previous brightness value
  final isLoading = false.obs;
  final isloading = false.obs; // Added definition for isloading
  final isDataLoaded = false.obs; // Added definition for isDataLoaded
  final oldLabel = "".obs;
  final newLabel = "".obs;
    void toggleExpansion(String categoryId) {
    final current = expandedStates[categoryId] ?? false;
    expandedStates[categoryId] = !current;
    box.write('expandedStates', expandedStates);
  }
    final expandedStates = <String, bool>{}.obs;
  int relable_idproject = 0;
   bool isSelected(int id) => selectedProjectId!.value == id;
    bool isExpanded(String categoryId) {
    return expandedStates[categoryId] ?? false;
  }
  final query = ''.obs;
    final searchController = TextEditingController().obs;
  final RxInt selectedProjectId = RxInt(-1);
    final RxList<CategoriesModel> filteredCategories = <CategoriesModel>[].obs;
  RxMap<String, dynamic> oldProjectMap = <String, dynamic>{}.obs;
  bool _isScannerStarted = false;
  final scannedImagedata = ''.obs;
    var projectTitle = "".obs;
  var projectSubtittle = "".obs;
  var dataFetched = false.obs;
  final RxList<CategoriesModel> allCategories = <CategoriesModel>[].obs;

  final RelabelRepository relabelRepository = RelabelRepository();

  @override
  void onInit() {
    super.onInit();
    _initializeCameraPosition();
  }

  void _initializeCameraPosition() {
    // Default to back camera (false = back camera, true = front camera)
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

  void startScanner() {
    if (!_isScannerStarted) {
      // Start with the correct camera based on current state
      final CameraFacing desiredFacing = isFrontCamera.value
          ? CameraFacing.front
          : CameraFacing.back;
      scannerController.start(cameraDirection: desiredFacing);
      _isScannerStarted = true;
    }
  }

  void stopScanner() {
    if (_isScannerStarted) {
      scannerController.stop();
      _isScannerStarted = false;
    }
  }

  @override
  void onClose() {
    stopScanner();
    resetLightState();
    super.onClose();
  }

  Future<void> resetLightState() async {
    try {
      if (isTorchOn.value) {
        if (isFrontCamera.value) {
          // Reset brightness for front camera
          await BrightnessService.resetBrightness();
        } else {
          // Toggle torch for back camera
          await scannerController.toggleTorch();
        }
        isTorchOn.value = false;
        print("Light state reset for ${getCurrentCameraPosition()} camera");
      }
    } catch (_) {}
  }

  Future<void> toggleLight() async {
    try {
      print("Current camera: ${getCurrentCameraPosition()}, isFrontCamera: ${isFrontCamera.value}");
      
      // Direct camera position check - more reliable
      if (isFrontCamera.value) {
        // Front camera - use brightness control
        print("Using brightness control for front camera");
        if (!isTorchOn.value) {
          // Turn ON - set maximum brightness
          final success = await BrightnessService.setBrightnessMax();
          isTorchOn.value = true;
          print("Maximum brightness enabled on front camera");
        } else {
          // Turn OFF - restore previous brightness
          final success = await BrightnessService.resetBrightness();
          isTorchOn.value = false;
          print("Brightness restored on front camera");
        }
      } else {
        // Back camera - use physical torch
        print("Using physical torch for back camera");
        await scannerController.toggleTorch();
        isTorchOn.value = !isTorchOn.value;
        print("Toggle physical torch: ${isTorchOn.value} on ${getCurrentCameraPosition()} camera");
      }
    } catch (_) {}
  }


  Future<void> switchCamera() async {
    try {
      final bool wasFront = isFrontCamera.value;
      final bool wasTorchOn = isTorchOn.value;

      // Turn off torch/brightness before switching camera if it's currently on
      if (wasTorchOn) {
        if (wasFront) {
          // Reset brightness for front camera via shared service
          await BrightnessService.resetBrightness();
        } else {
          // Toggle torch for back camera
          await scannerController.toggleTorch();
        }
        isTorchOn.value = false;
      }

      await scannerController.switchCamera();

      // Update camera position tracking
      isFrontCamera.value = !wasFront;
      camera.value = !camera.value;
      print("Camera switched to: ${isFrontCamera.value ? 'Front' : 'Back'} camera");
    } catch (_) {}
  }
   
    void searchProjects() {
    final queryText = query.value.toLowerCase();
    if (queryText.isEmpty) {
      // If search is empty, restore original list
      filteredCategories.value = List.from(allCategories);
    } else {
      print("Searching for: $queryText");
      // Filter categories and projects based on search query
      filteredCategories.value = allCategories
          .map((cat) {
            final isCategoryMatch = cat.name.toLowerCase().contains(queryText);
            final filteredProjects = cat.projects
                .where(
                  (proj) =>
                      proj.title.toLowerCase().contains(queryText) ||
                      proj.subtitle.toLowerCase().contains(queryText),
                )
                .toList();
               
            // If category name matches, return the whole category
            if (isCategoryMatch) {
              return CategoriesModel(
                id: cat.id,
                name: cat.name,
                projects: cat.projects,
              );

            }

            // Otherwise, return category with only matching projects
            return CategoriesModel(
              id: cat.id,
              name: cat.name,
              projects: filteredProjects,
            );
          })
          // Keep only those categories which have at least one project after filtering
          .where((cat) => cat.projects.isNotEmpty)
          .toList();
    }
  }
  Future<void> fetchProjectsWithCategories() async {
    try {
      isloading.value = true;

      // First check internet connection
      // await initConnectivity();
      // if (!hasInternetConnection.value) {
      //   await Get.to(() => NoInternetScreen());
      //   return;
      // }

      allCategories.value = await projectsRepostiory
          .getAllProjectsWithCategory();
      filteredCategories.value = List.from(allCategories);
      print("Fetched categories: ${filteredCategories.value}");
      extractProjectDetailsById(selectedProjectId!.value);
      isloading.value = false;
      isDataLoaded.value = true;
    } on NoInternetException {
      // isloading.value = false;
      // await Get.to(
      //   () => NoInternetScreen(),
      // ); // Use  offAll to prevent going back
    } catch (e) {
      isloading.value = false;
      isDataLoaded.value = false;
      Get.snackbar("Error", "Failed to fetch projects");
    }
  }
  void extractProjectDetailsById(int id) {
  for (final category in filteredCategories) {
    for (final project in category.projects) {
      if (project.id == id) {
        projectTitle.value = project.title;
        projectSubtittle.value = project.subtitle;
        print('🎯 Project Found: $projectTitle - $projectSubtittle');
        return;
      }
    }
  }
  print('⚠️ No project found with id $id');
}
  void resetLabels() {
    oldLabel.value = "";
    newLabel.value = "";
    isProcessing.value = false;
    isShowingDialog.value = false;
  }

  Future<bool> relabelObject() async {
    try {
      isLoading.value = true;
      bool result = await relabelRepository.relabelObject(RelabelModel(
        version: "2",
        idUser: box.read(userId).toString(),
        oldLabel: oldLabel.value,
        newLabel: newLabel.value,
      ));
      isLoading.value = false;
      return result;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Errore", e.toString());
      return false;
    }
  }

  var hasInternetConnection = true.obs;
  var wasOffline = false.obs;
  final Connectivity connectivity = Connectivity();

  Future<void> initConnectivity() async {
    var results = await connectivity.checkConnectivity();
    return _updateConnectionStatus(results);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final previouslyOffline = !hasInternetConnection.value;
    hasInternetConnection.value = results.any((result) => result != ConnectivityResult.none);

    // Only update the connection status, don't show notifications
    // Network restoration notifications should be handled centrally
  }

  var gettingsubjProjects = false.obs;
  ProjectsRepostiory projectsRepostiory = ProjectsRepostiory();

  Future<void> selectProject(int id, BuildContext context) async {
    try {
      await initConnectivity();
      if (!hasInternetConnection.value) {
        await Get.to(NoInternetScreen());
        return;
      }

      gettingsubjProjects.value = true;
      selectedProjectId.value = id;

      final url = Uri.parse('http://www.in-code.cloud:8888/api/1/project/get');
      print('id_user: ${box.read(userId)} | id_project: $id');

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'version': '2',
          'id_user': '${box.read(userId)}',
          'id_project': '$id',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('data: $data');
          oldProjectMap.clear();
          oldProjectMap.addAll(data);
          Utils.anotherFlushbar(context, "Progetto selezionato con successo", Colors.green);
          dataFetched.value = true;
          if(oldProjectMap.isNotEmpty){
            dataFetched.value = true;
          }
          // selectedProjectId.value = -1;
      
      } else {
        print("HTTP Error: \${response.statusCode}");
        Utils.anotherFlushbar(
          context,
          "Errore server: \${response.statusCode}",
          Colors.red,
        );
        selectedProjectId.value = -1;
        dataFetched.value = false;
      }
    } catch (e) {
      print("❗ Exception: $e");
      Utils.anotherFlushbar(context, e.toString(), Colors.red);
      selectedProjectId.value = -1;
    } finally {
      gettingsubjProjects.value = false;
    }
  }
   Future<bool> relabelScanObject( BarcodeCapture capture,) async {
    try {
       final barcode = capture.barcodes.firstWhere(
        (b) => b.rawValue != null && b.rawValue!.isNotEmpty,
        orElse: () => Barcode(rawValue: null),
      );
      final code = barcode.rawValue;
      if (code == null) throw Exception("QR code vuoto o non valido.");
      print("this is old and new label ${relable_idproject},fggsg ${scannedImagedata.value}");
      scannedImagedata.value = code;
      isLoading.value = true;
      print('try relabel ${relable_idproject.toString()} ${newLabel.value}');
      bool result = await relabelRepository.relabelObject(RelabelModel(
        version: "2.0",
        idUser: box.read(userId).toString(),
        oldLabel: relable_idproject.toString(),
        newLabel: scannedImagedata.value,
      ));
      isLoading.value = false;
      return result;
    } catch (e) {
      isLoading.value = false;
      Get.snackbar("Errore", e.toString());
      return false;
    }
  }
}

