




import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NetworkManager extends GetxController {
  static NetworkManager get to => Get.find();

  final Connectivity _connectivity = Connectivity();
  var hasInternetConnection = true.obs;
  var wasOffline = false.obs;
  var _hasShownRestoreNotification = false.obs;

  // ✅ New field to track the last screen before going offline
  Widget? lastScreenBeforeOffline;

  @override
  void onInit() {
    super.onInit();
    _initConnectivity();
    _setupConnectivityListener();
  }

  Future<void> _initConnectivity() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnectionStatus(result);
    } catch (e) {
      debugPrint("Error checking connectivity: $e");
    }
  }

  void _setupConnectivityListener() {
    _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
      final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
      _updateConnectionStatus(result);
    });
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    final previouslyOffline = !hasInternetConnection.value;
    hasInternetConnection.value = result != ConnectivityResult.none;
    print("hasInternetConnection: ${hasInternetConnection.value}");

    if (!hasInternetConnection.value) {
      _hasShownRestoreNotification.value = false;
      wasOffline.value = true;
      _showNetworkGoneNotification();
    }

    if (previouslyOffline && hasInternetConnection.value && !_hasShownRestoreNotification.value) {
      _hasShownRestoreNotification.value = true;
      wasOffline.value = false;
      _showNetworkRestoredNotification();
    }
  }

  void _showNetworkGoneNotification() {
    if (Get.currentRoute != '/no_internet') {
      Get.snackbar(
        "Connessione Disconessa",
        "Per favore controllare la connessione internet",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }
  }

  void _showNetworkRestoredNotification() {
    Get.snackbar(
      "Connessione Ristabilita",
      "Connessione internet ripristinata",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
    );
  }

  // Reset the notification flag when going offline
  void resetNotificationFlag() {
    if (!hasInternetConnection.value) {
      _hasShownRestoreNotification.value = false;
    }
  }

  // Force reset notification flag (useful when navigating to NoInternetScreen)
  void forceResetNotificationFlag() {
    _hasShownRestoreNotification.value = false;
    wasOffline.value = true;
  }

  // Check connectivity and throw exception if offline
  Future<void> checkConnectivityOrThrow() async {
    final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    if (result == ConnectivityResult.none) {
      throw Exception('No internet connection');
    }
  }

  // ✅ Use this instead of Get.to / Get.offAll for tracking
  void navigateWithTracking(Widget screen, {bool clearStack = false}) {
    lastScreenBeforeOffline = screen;

    if (clearStack) {
      Get.offAll(() => screen);
    } else {
      Get.to(() => screen);
    }
  }
}

// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class NetworkManager extends GetxController {
//   static NetworkManager get to => Get.find();
  
//   final Connectivity _connectivity = Connectivity();
//   var hasInternetConnection = true.obs;
//   var wasOffline = false.obs;
//   var _hasShownRestoreNotification = false.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     _initConnectivity();
//     _setupConnectivityListener();
//   }

//   Future<void> _initConnectivity() async {
//     try {
//       final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
//       final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
//       _updateConnectionStatus(result);
//     } catch (e) {
//       debugPrint("Error checking connectivity: $e");
//     }
//   }

//   void _setupConnectivityListener() {
//     _connectivity.onConnectivityChanged.listen((List<ConnectivityResult> results) {
//       final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
//       _updateConnectionStatus(result);
//     });
//   }

//   void _updateConnectionStatus(ConnectivityResult result) {
//     final previouslyOffline = !hasInternetConnection.value;
//     hasInternetConnection.value = result != ConnectivityResult.none;
//     print("hasInternetConnection: ${hasInternetConnection.value}");
//     // Reset notification flag when going offline
//     if (!hasInternetConnection.value) {
//       _hasShownRestoreNotification.value = false;
//       wasOffline.value = true;
//       _showNetworkGoneNotification();
//     }

//     // Show network restored notification only once per session
//     if (previouslyOffline && hasInternetConnection.value && !_hasShownRestoreNotification.value) {
//       _hasShownRestoreNotification.value = true;
//       wasOffline.value = false;
//       _showNetworkRestoredNotification();
//     }
//   }
//   void _showNetworkGoneNotification(){
//  Get.snackbar(
//       "Network Disconnected",
//       "Please check your internet connection",
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.red,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 3),
//     );
//    }
//   void _showNetworkRestoredNotification() {
//     Get.snackbar(
//       "Network Restored",
//       "Internet connection has been restored",
//       snackPosition: SnackPosition.TOP,
//       backgroundColor: Colors.green,
//       colorText: Colors.white,
//       duration: const Duration(seconds: 3),
//     );
//   }

//   // Reset the notification flag when going offline
//   void resetNotificationFlag() {
//     if (!hasInternetConnection.value) {
//       _hasShownRestoreNotification.value = false;
//     }
//   }
  
//   // Force reset notification flag (useful when navigating to NoInternetScreen)
//   void forceResetNotificationFlag() {
//     _hasShownRestoreNotification.value = false;
//     wasOffline.value = true;
//   }

//   // Check connectivity and throw exception if offline
//   Future<void> checkConnectivityOrThrow() async {
//     final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
//     final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
//     if (result == ConnectivityResult.none) {
//       throw Exception('No internet connection');
//     }
//   }
// } 