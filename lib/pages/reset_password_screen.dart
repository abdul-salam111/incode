import 'package:animate_do/animate_do.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

import 'package:get/get.dart';
import 'package:in_code/widgets/app_textfield.dart';
import 'package:in_code/constants/input_formatters.dart';
import 'package:in_code/controllers/login_controller.dart';
import 'package:in_code/controllers/reset_password_controller.dart';
import 'package:in_code/core/language/language_controller.dart';
import 'package:in_code/res/res.dart';

import '../widgets/validators.dart';

class ResetPasswordScreen extends StatelessWidget {
  ResetPasswordScreen({super.key});

  final loginFormKey = GlobalKey<FormState>();
RxBool isEmailValid = false.obs;
  @override
  Widget build(BuildContext context) {
    final ResetPasswordController controller =
        Get.put(ResetPasswordController());
          final languageController = Get.find<LanguageController>();
    final loginController = Get.put(LoginController());
    var height = MediaQuery.of(context).size.height;
    // final box = GetStorage();
    final languagecontroller = Get.put(LanguageController());

    return GestureDetector(
      onTap: () {
        context.focusScope.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: Stack(
          children: [
            Column(
              children: <Widget>[
                SizedBox(
                  height: height * 0.75,
                  child: ClipPath(
                    clipper: OvalBottomBorderClipper(),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment(0.00, -1.00),
                          end: Alignment(0, 1),
                          colors: [
                            Color(0xFFDD1527),
                            Color(0xFF7D0C16),
                          ],
                        ),
                      ),
                      child: FadeInUp(
                        child: Form(
                          key: controller.formkey,
                          child: ListView(
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            padding: EdgeInsets.zero,
                            children: [
                              SizedBox(
                                height: height * 0.1,
                              ),
                              // Align(
                              //   alignment: Alignment.topRight,
                              //   child: _buildLanguageDropdown(),
                              // ).paddingSymmetric(horizontal: 15),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 50),
                                child: Column(
                                  children: [
                                    HeightBox(context.height * 0.09),
                                    Image.asset(
                                      'assets/images/logo.png',
                                      height: 100,
                                    ),
                                    HeightBox(context.height * 0.05),
                                    Obx(
                                      () => Text(
                                        languagecontroller.getTranslation(
                                            'forgotPasswordTitle'),
                                        textAlign: TextAlign.center,
                                        style:  TextStyle(
                                          fontSize: 25,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    HeightBox(context.height * 0.01),
                                    Obx(
                                      () => Text(
                                        languagecontroller.getTranslation(
                                            'forgotPasswordDescription'),
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          fontSize: 13,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    HeightBox(context.height * 0.02),
                                    Obx(
                                      () => Theme(
                                        data: Theme.of(context).copyWith(
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.primaryColor, // cursor color
      selectionColor: AppColors.primaryColor.withOpacity(0.3), // text highlight
      selectionHandleColor: AppColors.primaryColor, // tear-drop handle color
    ),
  ),
                                        child: CustomTextFormField(
                                          cursorColor: AppColors.primaryColor,
                                          title: languagecontroller
                                              .getTranslation('email'),
                                          isRequired: true,
                                          requiredErrorMessage: languageController.getTranslation('fieldRequired'),
                                          textCapitalization:
                                              TextCapitalization.none,
                                          hintText: languagecontroller
                                              .getTranslation('emailHint'),
                                          controller: controller.emailController,
                                                                            onChanged: (value) {
                                                                controller.isEmailValid.value =
                                                                  Validator.validateEmail(value) ==
                                                                    null;
                                                                controller.emailErrorText.value =
                                                                  Validator.validateEmail(value) !=
                                                                      null
                                                                    ? 
                                                                      'valid email'
                                                                    : '';
                                                              },
                                          validator: Validator.validateEmail ,
                                          inputFormatters: InputFormat.denySpace,
                                          keyboardType:
                                              TextInputType.emailAddress,
                                          autofillHints: const [
                                            AutofillHints.email
                                          ],
                                          suffixWidget: controller.isEmailValid.value
                                                                  ? Image.asset(
                                                                    'assets/images/Tick.png',
                                                                    height: 20,
                                                                    width: 20,
                                                                  )
                                                                  : Icon(
                                                                    Icons.email,
                                                                    size: 20,
                                                                    color: Colors.black,
                                                                  ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 15),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                _buildCompanyText(
                    loginController, controller, languagecontroller),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
            Positioned(
              top: height * 0.71,
              right: 0,
              left: 0,
              child: _buildLoginBtn(
                  controller, loginController, languagecontroller),
            ),
            Positioned(
              top: height * 0.06,
              // right: 0,
              left: 10,
              child: GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  GestureDetector _buildLoginBtn(ResetPasswordController controller,
      LoginController loginController, LanguageController languagecontroller) {
    return GestureDetector(
      onTap: () {
        if (controller.formkey.currentState!.validate()) {
          controller.resetPassword();
        }
      },
      child: Center(
        child: Container(
          width: 203,
          height: 53,
          alignment: Alignment.center,
          decoration: ShapeDecoration(
            color: const Color.fromARGB(255, 255, 255, 255),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
            shadows: const [
              BoxShadow(
                color: Color(0x33000000),
                blurRadius: 9.90,
                offset: Offset(0, 4),
                spreadRadius: 0,
              )
            ],
          ),
          child: Obx(
            () => controller.isLoading.value
                ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF7D0C16),
                    ),
                  )
                : Obx(
                    () => Text(
                      languagecontroller.getTranslation('RecoverPassword'),
                      style: const TextStyle(
                        fontSize: 16,
                        color: AppColors.secondaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyText(
      LoginController loginController,
      ResetPasswordController controller,
      LanguageController languagecontroller) {
    final controller = Get.put(LoginController());
    return Obx(
      () => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: languagecontroller.getTranslation('createdWith'),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            const WidgetSpan(
              child: Icon(
                Icons.favorite,
                color: Colors.red,
                size: 20,
              ),
            ),
            TextSpan(
              text: languagecontroller.getTranslation('by '),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextSpan(
              text: 'Fenix ​​HUB',
              style: const TextStyle(
                color: AppColors.redDarkColor,
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  controller.launchFenixHubURL();
                },
            ),
            // TextSpan(
            //   text: ' Fenix ​​HUB',
            //   style: const TextStyle(
            //     color: Colors.redAccent,
            //     fontSize: 18,
            //     fontWeight: FontWeight.w700,
            //   ),
            //   recognizer: TapGestureRecognizer()
            //     ..onTap = controller.launchFenixHubURL,
            // ),
          ],
        ),
      ),
    );
  }

  // Widget buildReg() {
  //   return InkWell(
  //     onTap: () {
  //       controller.emailController.clear();
  //       controller.passwordController.clear();
  //       Get.offAllNamed("/signup-screen");
  //     },
  //     child: Container(
  //       height: 66,
  //       color: Colors.black,
  //       alignment: Alignment.center,
  //       child: Obx(
  //         () => RichText(
  //           text: TextSpan(
  //             children: [
  //               TextSpan(
  //                 text: controller.translations[
  //                     controller.currentLanguage.value]!['noAccount']!,
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 17,
  //                   fontWeight: FontWeight.w400,
  //                 ),
  //               ),
  //               TextSpan(
  //                 text: controller.translations[
  //                     controller.currentLanguage.value]!['registerNow']!,
  //                 style: const TextStyle(
  //                   color: Colors.white,
  //                   fontSize: 18,
  //                   fontFamily: 'Roboto',
  //                   fontWeight: FontWeight.w700,
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
