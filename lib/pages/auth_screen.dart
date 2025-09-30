import 'package:animate_do/animate_do.dart';
import 'package:enefty_icons/enefty_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_code/controllers/login_controller.dart';
import 'package:in_code/widgets/app_textfield.dart';
import 'package:in_code/constants/input_formatters.dart';
import 'package:in_code/core/language/language_controller.dart';
import 'package:in_code/core/language/language_selector.dart';
import 'package:in_code/pages/reset_password_screen.dart';
import 'package:in_code/res/res.dart';
import 'package:in_code/widgets/validators.dart';

class AuthScreen extends GetView<LoginController> {
  AuthScreen({super.key});

  final loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    final languageController = Get.find<LanguageController>();
    var height = MediaQuery.of(context).size.height;
    controller.emailController.text = "supporto@in-code.it";
    controller.passwordController.text="DEV2025dev";
    return WillPopScope(
      onWillPop: () async {
      // Prevent back navigation
      return false;
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
                colors: [Color(0xFFDD1527), Color(0xFF7D0C16)],
              ),
              ),
              child: FadeInUp(
              child: Form(
                key: loginFormKey,
                child: ListView(
                clipBehavior: Clip.antiAliasWithSaveLayer,
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(height: height * 0.1),
                  Align(
                  alignment: Alignment.topRight,
                  child: LanguageSelector(),
                  ).paddingSymmetric(horizontal: 15),
                  Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                  ),
                  child: Column(
                    children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 100,
                    ),
                    const SizedBox(height: 20),
                    Obx(
                      () => Text(
                      languageController.getTranslation(
                        'loginHint',
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                        title: languageController.getTranslation(
                          'email',
                        ),
                        requiredErrorMessage: languageController.getTranslation('fieldRequired'),
                        isRequired: true,
                        textCapitalization:
                          TextCapitalization.none,
                        hintText: languageController
                          .getTranslation('emailHint'),
                        controller: controller.emailController,
                        inputFormatters: [
                          ...InputFormat.denySpace,
                          LengthLimitingTextInputFormatter(200),
                        ],
                        keyboardType: TextInputType.emailAddress,
                        validator: Validator.validateEmail,
                        autofillHints: const [
                          AutofillHints.email,
                        ],
                        onChanged: (value) {
                          final result = Validator.validateEmail(value);
                          controller.isEmailValid.value = result == null;
                        },
                        suffixWidget: Obx(
                          () => controller.isEmailValid.value
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
                    ),
                    const SizedBox(height: 15),
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

                        textCapitalization:
                          TextCapitalization.none,
                        focusNode: controller.passwordFocusNode,
                        cursorColor: AppColors.primaryColor,
                        title: languageController.getTranslation(
                          'password',
                        ),
                        isRequired: true,
                        hintText: languageController
                          .getTranslation('passwordHint'),
                          requiredErrorMessage: languageController.getTranslation('fieldRequired'),
                        controller:
                          controller.passwordController,
                        keyboardType: TextInputType.text,
                        validator: Validator.validatePassword,
                        obscureText:
                          !controller.isPasswordVisible.value,
                        autofillHints: const [
                          AutofillHints.password,
                        ],
                        inputFormatters: [
                          ...InputFormat.denySpace,
                          LengthLimitingTextInputFormatter(200),
                        ],
                        suffixWidget: InkWell(
                          onTap: () {
                          if (!controller
                            .passwordFocusNode.hasFocus) {
                            FocusScope.of(context).requestFocus(
                            controller.passwordFocusNode,
                            );
                          }
                          controller.togglePassword();
                          },
                          child: Icon(
                          controller.isPasswordVisible.value
                            ? EneftyIcons.eye_slash_bold
                            : EneftyIcons.eye_bold,
                          size: 20,
                          color: Colors.black,
                          ),
                        ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width *
                          0.04,
                        top: MediaQuery.of(context).size.height *
                          0.01,
                      ),
                      child: GestureDetector(
                        onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                          builder: (context) =>
                            ResetPasswordScreen(),
                          ),
                        );
                        },
                        child: Obx(
                        () => Text(
                          languageController.getTranslation(
                          'forgotPassword',
                          ),
                          textAlign: TextAlign.start,
                          style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context)
                              .size
                              .width *
                            0.03,
                          fontWeight: FontWeight.w700,
                          decorationColor: Colors.white,
                          ),
                        ),
                        ),
                      ),
                      ),
                    ),
                    const SizedBox(height: 30),
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
          _buildCompanyText(languageController),
          const SizedBox(height: 10),
          ],
        ),
        Positioned(
          top: height * 0.71,
          right: 0,
          left: 0,
          child: _buildLoginBtn(controller, languageController),
        ),
        ],
      ),
      ),
    );
  }

  GestureDetector _buildLoginBtn(
    LoginController controller,
    LanguageController languageController,
  ) {
    return GestureDetector(
      onTap: () {
        if (!controller.islogging.value) {
          if (loginFormKey.currentState!.validate()) {
        controller.loginUser();
          }
          print('Login button pressed');
        }
      },
      child: Center(
        child: Container(
          width: 170,
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
              ),
            ],
          ),
          child: Obx(
            () => controller.islogging.value
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFF7D0C16)),
                  )
                : Text(
                    languageController.getTranslation('login'),
                    style: const TextStyle(
                      fontSize: 20,
                      color: AppColors.secondaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget _buildCompanyText(LanguageController languageController) {
    return Obx(
      () => RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: languageController.getTranslation('createdWith'),
              style: const TextStyle(
                color: Colors.black,
                fontSize: 17,
                fontWeight: FontWeight.w400,
              ),
            ),
            const WidgetSpan(
              child: Icon(Icons.favorite, color: Colors.red, size: 20),
            ),
            TextSpan(
              text: languageController.getTranslation('by '),
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
                // decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  controller.launchFenixHubURL();
                },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildReg(LanguageController languageController) {
    return InkWell(
      onTap: () {
        controller.emailController.clear();
        controller.passwordController.clear();
        Get.offAllNamed("/signup-screen");
      },
      child: Container(
        height: 66,
        color: Colors.black,
        alignment: Alignment.center,
        child: Obx(
          () => RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: languageController.getTranslation('noAccount'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                TextSpan(
                  text: languageController.getTranslation('registerNow'),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
