import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_code/config/storage/sharedpref_keys.dart';
import 'package:in_code/pages/auth_screen.dart';
import 'package:in_code/pages/navbar.dart';
import 'package:in_code/res/res.dart';
import 'package:in_code/widgets/components.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    await Future.delayed(const Duration(seconds: 3));
    print("this is the user id ${box.read(userId)}");
    if (box.read(userId) != null) {
      Get.offAll(() => Navbar());
    } else {
      Get.offAll(() => AuthScreen());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primaryColor, AppColors.secondaryColor],
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Center(
                child: appLogo(
                  width: context.width * 0.3,
                  height: context.height * 0.1,
                ),
              ),
              Positioned(
                bottom: context.height * 0.04, // Adjusted to be responsive
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Versione ",
                        style: context.bodyMedium!.copyWith(color: Colors.grey),
                      ),
                      TextSpan(
                        text: "2.0",
                        style: context.bodyMedium!.copyWith(
                          color: Colors.white,
                        ), // or use Colors.grey.shade400 for a softer tone
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Prevent moving back from this screen
    ModalRoute.of(context)?.addScopedWillPopCallback(() async => false);
  }
}
