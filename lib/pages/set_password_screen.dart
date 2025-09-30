// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:in_code/res/res.dart';
import 'package:in_code/widgets/components.dart';

import '../../controllers/set_password_controller.dart';

class SetPasswordScreen extends StatefulWidget {
  SetPasswordScreen({super.key});

  @override
  State<SetPasswordScreen> createState() => _SetPasswordScreenState();
}

class _SetPasswordScreenState extends State<SetPasswordScreen> {
 final controller = Get.put(SetPasswordController());
  @override
void initState() {
  super.initState();
  controller.validatePassword();
}


  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (val) {
  controller.passwordController.clear();
  controller.confirmPasswordController.clear();

  controller.isPasswordTouched.value = false;
  controller.isConfirmPasswordTouched.value = false;

  controller.passwordError.value = '';
  controller.confirmPasswordError.value = '';
  controller.passwordsMatch.value = false;
  controller.isValid.value = false;

  controller.hasMinLength.value = false;
  controller.hasNumber.value = false;
  controller.hasUpperLower.value = false;
}
,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Modifica Password',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          centerTitle: true,
          backgroundColor: AppColors.secondaryColor,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity, // E
          decoration: BoxDecoration(color: Colors.white),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.secondaryColor.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Iconsax.lock,
                          size: 40,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'Crea la tua nuova password',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    // Center(
                    //   child: Text(
                    //     'Your password must be at least 8 characters',
                    //     style: TextStyle(
                    //       fontSize: 14,
                    //       color: Colors.grey[600],
                    //     ),
                    //   ),
                    // ),
                    const SizedBox(height: 32),

                    // Password Field
                    Text(
                      'Nuova Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme: TextSelectionThemeData(
                            cursorColor: AppColors.primaryColor, // cursor color
                            selectionColor: AppColors.primaryColor.withOpacity(
                              0.3,
                            ), // text highlight
                            selectionHandleColor: AppColors
                                .primaryColor, // tear-drop handle color
                          ),
                        ),
                        child: TextField(
                          cursorColor: AppColors.primaryColor,
                          controller: controller.passwordController,
                          obscureText: !controller.isPasswordVisible.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.secondaryColor,
                                width: 2,
                              ),
                            ),
                            hintText: 'Inserisci la tua nuova password',
                            hintStyle: TextStyle(fontSize: 14),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: Icon(
                              Iconsax.lock,
                              color: AppColors.secondaryColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[600],
                              ),
                              onPressed: controller.togglePassword,
                            ),
                          ),
                          onChanged: (val) {
                            controller.validatePassword();
                            controller.isPasswordTouched.value = true;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => controller.passwordError.value.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 12, top: 4),
                              child: Text(
                                controller.passwordError.value,
                                style: const TextStyle(
                                  color: AppColors.secondaryColor,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Confirm Password Field
                    const SizedBox(height: 20),
                    Text(
                      'Conferma Password',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Obx(
                      () => Theme(
                        data: Theme.of(context).copyWith(
                          textSelectionTheme: TextSelectionThemeData(
                            cursorColor: AppColors.primaryColor, // cursor color
                            selectionColor: AppColors.primaryColor.withOpacity(
                              0.3,
                            ), // text highlight
                            selectionHandleColor: AppColors
                                .primaryColor, // tear-drop handle color
                          ),
                        ),
                        child: TextField(
                          cursorColor: AppColors.primaryColor,
                          controller: controller.confirmPasswordController,
                          obscureText:
                              !controller.isConfirmPasswordVisible.value,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: Color(0xFF7D0C16),
                                width: 2,
                              ),
                            ),
                            hintText: 'Conferma la tua nuova password',
                            hintStyle: TextStyle(fontSize: 14),
                            filled: true,
                            fillColor: Colors.white,
                            prefixIcon: const Icon(
                              Iconsax.lock,
                              color: AppColors.secondaryColor,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.isConfirmPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Colors.grey[600],
                              ),
                              onPressed: controller.toggleConfirmPassword,
                            ),
                          ),
                          onChanged: (val) {
                            controller.validatePassword();
                            controller.isPasswordTouched.value = true;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Obx(
                      () => controller.confirmPasswordError.value.isNotEmpty
                          ? Padding(
                              padding: const EdgeInsets.only(left: 12, top: 4),
                              child: Text(
                                controller.confirmPasswordError.value,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // Password strength indicator
                    const SizedBox(height: 24),
                    Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                controller.hasMinLength.value
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                color: controller.hasMinLength.value
                                    ? Colors.green
                                    : Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Almeno 8 caratteri',
                                style: TextStyle(
                                  color: controller.hasMinLength.value
                                      ? Colors.green
                                      : Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                controller.hasNumber.value
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                color: controller.hasNumber.value
                                    ? Colors.green
                                    : Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Contiene numeri',
                                style: TextStyle(
                                  color: controller.hasNumber.value
                                      ? Colors.green
                                      : Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                controller.hasUpperLower.value
                                    ? Icons.check_circle
                                    : Icons.check_circle_outline,
                                color: controller.hasUpperLower.value
                                    ? Colors.green
                                    : Colors.grey,
                                size: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Contiene lettere maiuscole e minuscole',
                                style: TextStyle(
                                  color: controller.hasUpperLower.value
                                      ? Colors.green
                                      : Colors.grey[600],
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 4),
                    Obx(() {
                      final match = controller.passwordsMatch.value;
                      return Row(
                        children: [
                          Icon(
                            match
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            color: match ? Colors.green : Colors.grey,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Le password coincidono',
                            style: TextStyle(
                              color: match ? Colors.green : Colors.grey[600],
                              fontSize: 13,
                            ),
                          ),
                        ],
                      );
                    }),

                    const SizedBox(height: 4),
                    // Submit Button
                    const SizedBox(height: 32),
                    Obx(
                      () => SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              controller.isValid.value &&
                                  !controller.isLoading.value
                              ? controller.resetUserPassword
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.isValid.value
                                ? AppColors.secondaryColor
                                : Colors.grey[300],
                            foregroundColor: controller.isValid.value
                                ? Colors.white
                                : Colors.grey[600],
                            disabledBackgroundColor: Colors.grey[300],
                            disabledForegroundColor: Colors.grey[600],
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 2,
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: LoadingIndicator(size: 20),
                                )
                              : const Text(
                                  'Modifica Password',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
