import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import 'package:in_code/core/language/language_controller.dart';
import 'package:in_code/res/res.dart';

class ResetPasswordController extends GetxController {
  final TextEditingController emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  RxBool isLoading = false.obs;
  final storage = GetStorage();
  final languageController = Get.find<LanguageController>();
  RxBool isEmailValid = false.obs;
  RxString emailErrorText = ''.obs;

  Future<void> resetPassword() async {
    try {
      isLoading.value = true;

      final uri = Uri.parse(AppUrls.resetPassword);
      final request = http.MultipartRequest('POST', uri);

      // Set headers
      request.headers['Content-Type'] = 'multipart/form-data';

      // Add fields
      request.fields['version'] = '1';
      request.fields['email'] = emailController.text.trim();

      // Send request
      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      print('Response status: ${response.body}');
      isLoading.value = false;
      if (response.statusCode == 400) {
        final errorMessage = response.body.isNotEmpty
            ? response.body
            : 'Invalid request. Please check your input.';
        Get.snackbar(
          languageController.getTranslation('error'),
          errorMessage,
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.errorColor,
        );
        return;
      }
      if (response.statusCode == 401) {
        Get.snackbar(
          languageController.getTranslation('error'),
          'Unauthorized access. Please log in again.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.errorColor,
        );
        return;
      }
      if (response.statusCode == 200) {
        Get.snackbar(
          languageController.getTranslation('success'),
          'Reset password link has been sent to your email',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.successColor,
        );
        // Get.back();
      } else {
        Get.snackbar(
          languageController.getTranslation('error'),
          'Failed to send reset password link',
          snackPosition: SnackPosition.TOP,
          backgroundColor: AppColors.errorColor,
        );
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar(
        languageController.getTranslation('error'),
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  final formkey = GlobalKey<FormState>();
}
