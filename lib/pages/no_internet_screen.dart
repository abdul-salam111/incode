
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:in_code/pages/navbar.dart';
import 'package:in_code/res/res.dart';
import 'package:in_code/utils/utils.dart';
import 'package:in_code/config/network/network_manager.dart';

class NoInternetScreen extends StatefulWidget {
  @override
  _NoInternetScreenState createState() => _NoInternetScreenState();
}

class _NoInternetScreenState extends State<NoInternetScreen>
    with SingleTickerProviderStateMixin {
  final NetworkManager networkManager = Get.find<NetworkManager>();
  late final AnimationController _controller;
  
 @override
void initState() {
  super.initState();
  _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 2),
  )..repeat();
}

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}

Future<void> initConnectivity() async {
  await networkManager.checkConnectivityOrThrow();
  return _updateConnectionStatus();
}

// ✅ Update this method to use NetworkManager
Future<void> _updateConnectionStatus() async {
  print("Checking connectivity via NetworkManager");

  // Check if internet is available
  try {
    await networkManager.checkConnectivityOrThrow();
    
    // Show snackbar
    // Get.snackbar(
    //   "Network Restored",
    //   "Internet connection has been restored",
    //   snackPosition: SnackPosition.TOP,
    //   backgroundColor: Colors.green,
    //   colorText: Colors.white,
    //   duration: const Duration(seconds: 3),
    // );
    try {
        Get.back();
      } catch (e) {
        // This is initial app launch, navigate to main app
      Future.delayed(const Duration(seconds: 2), () {
      Get.offAll(() => Navbar());
    });
      }
    // Navigate to main navbar after a short delay
    
  } catch (e) {
    print("No internet connection available");
  }
}



  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Check current internet connectivity before allowing back navigation
        try {
          await networkManager.checkConnectivityOrThrow();
          return true;
        } catch (e) {
          return false;
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: const BorderRadiusDirectional.only(
                  bottomEnd: Radius.circular(30),
                  bottomStart: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  70.heightBox,
                  Center(
                    child: Image.asset(
                      "assets/images/nowifi.png",
                      height: 50,
                    ),
                  ),
                  10.heightBox,
                  Text(
                    "Connessione assente",
                    style: context.headlineSmall!.copyWith(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  10.heightBox,
                  Text(
                    "Attualmente sei offline, controlla\nla tua connessione rete",
                    style: context.bodyLarge!.copyWith(
                      fontSize: 14,
                      color: AppColors.halfwhiteColor.withAlpha((0.8 * 255).toInt()),
                    ),
                    textAlign: textAlignCenter,
                  ),
                  10.heightBox,
                  GestureDetector(
                 onTap: () async {
  print("Checking internet connection...");
  try {
    await networkManager.checkConnectivityOrThrow();
    // Navigate to main navbar when internet is restored
    await Get.offAll(() => Navbar());
  } catch (e) {
    Utils.anotherFlushbar(
        context, "Connessione disconnessa", Colors.red);
    return;
  }
},
                    child: Container(
                      padding: screenPadding,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          30.heightBox,
                          const Icon(
                            Iconsax.refresh,
                            color: Colors.black,
                            size: 15,
                          ),
                          5.widthBox,
                          const Text("Riprova"),
                        ],
                      ),
                    ),
                  ),
                  30.heightBox,
                ],
              ),
            ),
            const Spacer(),
            /// Rotating Spinner
            RotationTransition(
              turns: _controller,
              child: Image.asset(
                "assets/images/Spinner.png",
                height: 50,
              ),
            ),
            10.heightBox,
            Text(
              "Connessione assente",
              style: context.headlineSmall!.copyWith(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            60.heightBox,
          ],
        ),
      ),
    );
  }
}