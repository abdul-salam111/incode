import 'package:flutter/material.dart';
import 'package:get/get.dart';


import 'package:in_code/models/reset_password_model.dart';
import 'package:in_code/pages/profile_screen.dart';
import 'package:in_code/repositories/authRepository.dart';

import '../config/storage/sharedpref_keys.dart';

class SetPasswordController extends GetxController {
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  var isPasswordTouched = false.obs;
  var isConfirmPasswordTouched = false.obs;
  var passwordError = ''.obs;
  var confirmPasswordError = ''.obs;
  var passwordsMatch = false.obs;

  // Separate observables for each requirement
  var hasMinLength = false.obs;
  var hasNumber = false.obs;
  var hasUpperLower = false.obs;
  var isValid = false.obs;
  var isLoading = false.obs;

  void togglePassword() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPassword() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  void validatePassword() {
    final password = passwordController.text;
final confirmPassword = confirmPasswordController.text;

passwordsMatch.value =
    password.isNotEmpty &&
    confirmPassword.isNotEmpty &&
    password == confirmPassword;
    // Update each condition independently
    hasMinLength.value = password.length >= 8;
    hasNumber.value = RegExp(r'[0-9]').hasMatch(password);
    hasUpperLower.value = RegExp(r'(?=.*[a-z])(?=.*[A-Z])').hasMatch(password);

    // Error handling
    if (isPasswordTouched.value) {
      passwordError.value = password.isEmpty ? 'La password non può essere vuota' : '';
    }

    if (isConfirmPasswordTouched.value) {
      confirmPasswordError.value = (confirmPasswordController.text.isNotEmpty &&
          password != confirmPasswordController.text)
          ? 'Passwords do not match'
          : '';
    }

    isValid.value = hasMinLength.value &&
        hasNumber.value &&
        hasUpperLower.value &&
        (password == confirmPasswordController.text);
  }

  @override
  void onInit() {
    super.onInit();

    passwordController.addListener(() {
      Future.microtask(() => validatePassword());
    });

    confirmPasswordController.addListener(() {
      Future.microtask(() => validatePassword());
    });
  }

  @override
  void onClose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  AuthReository authReository = AuthReository();
  Future resetUserPassword() async {
    try {
      isLoading.value = true;
      bool isChanged = await authReository.resetPassword(
        ResetPasswordModel(
          version: '2.0',
          idUser: box.read(userId).toString(),
          email: box.read(userEmail).toString().trim(),
          password: passwordController.text.trim(),
        ),
      );
      if (isChanged) {
        Get.snackbar(
          'Successo',
          'Password modificata correttamente',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        passwordController.clear();
        confirmPasswordController.clear();
       Future.delayed(Duration(milliseconds: 500), () {
Get.to(ProfileScreen());
});
      } else {
        Get.snackbar(
          'Errore',
          'Non è stato possibile modificare la password, Riprova',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
      isLoading.value = false;
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      isLoading.value = false;
    }
  }
}