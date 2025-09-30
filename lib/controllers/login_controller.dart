import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:in_code/config/exceptions/app_exceptions.dart';
import 'package:in_code/config/storage/sharedpref_keys.dart';

import 'package:in_code/core/language/language_controller.dart';
import 'package:in_code/models/login_model.dart';
import 'package:in_code/pages/navbar.dart';

import 'package:in_code/repositories/authRepository.dart';
import 'package:in_code/res/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/success_popup.dart';

class LoginController extends GetxController {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocusNode = FocusNode();
RxBool isEmailValid = false.obs;
  RxBool isPasswordValid = false.obs;
  RxBool islogging = false.obs;
  RxBool isPasswordVisible = false.obs;
    RxString emailErrorText = ''.obs;
  RxString passwordErrorText = ''.obs;
  
  final languageController = Get.find<LanguageController>();

  LoginResponseModel? loginResponseModel;

  Future<void> launchFenixHubURL() async {
    final Uri url = Uri.parse('https://www.fenixhub.it/');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw 'Could not launch $url';
    }
  }

  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  AuthReository authReository = AuthReository();
  
  Future loginUser() async {
    try {
      islogging.value = true;
      loginResponseModel = await authReository.loginUser(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
      await box.write(userId, loginResponseModel!.userId);
      await box.write(userFirstName, loginResponseModel!.firstName);
      await box.write(userLastName, loginResponseModel!.lastName);
      await box.write(userEmail, loginResponseModel!.email);
      await box.write(userinformation, loginResponseModel!.lastLogin.toString());
      await Get.offAll(() => Navbar());
      islogging.value = false;
      
    } on WrongCredentialsException {
      islogging.value = false;
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => CustomScanDialog(
          oneButtonOnPressed: () {
            Get.back();
          },
          isOneButton: true,
          titleColor: AppColors.secondaryColor,
          icon: Icons.close,
          iconBackgroundColor: AppColors.secondaryColor,
          continueButtonColor: AppColors.secondaryColor,
          title: "Accesso non riuscito",
          description:
              "Le credenziali inserite non consentono l'accesso, controlla nuovamente e-mail e password",
          onCancel: () {
            Get.back();
          },
          onContinue: () {
            Get.back();
          },
        ),
      );
    } on NoInternetException {
      islogging.value = false;
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => CustomScanDialog(
          oneButtonOnPressed: () {
            Get.back();
          },
          isOneButton: true,
          titleColor: AppColors.secondaryColor,
          icon: Icons.close,
          iconBackgroundColor: AppColors.secondaryColor,
          continueButtonColor: AppColors.secondaryColor,
          title: "Errore di connessione",
          description:
              "Controlla la tua connessione internet e riprova.",
          onCancel: () {
            Get.back();
          },
          onContinue: () {
            Get.back();
          },
        ),
      );
    } catch (e) {
      print('error: $e');
      islogging.value = false;
      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => CustomScanDialog(
          oneButtonOnPressed: () {
            Get.back();
          },
          isOneButton: true,
          titleColor: AppColors.secondaryColor,
          icon: Icons.close,
          iconBackgroundColor: AppColors.secondaryColor,
          continueButtonColor: AppColors.secondaryColor,
          title: "Errore",
          description: "Stiamo riscontrando problemi di connessione al server",
          onCancel: () {
            Get.back();
          },
          onContinue: () {
            Get.back();
          },
        ),
      );
   
    }
  }

  void showErrorDialog(String message) {
    showDialog(
      context: Get.context!,
      builder: (context) {
        return SimpleDialog(
          title: const Text("Error"),
          contentPadding: const EdgeInsets.all(20),
          children: [
            Text(message),
          ],
        );
      },
    );
  }
}
