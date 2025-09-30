import 'package:get/get.dart';

import '../core/language/language_controller.dart'; // Update the import path as needed

extension StringValidationExtensions on String {
  // Check if the string is a valid email
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(this);
  }

  // Check if the string is a valid password (e.g., at least 8 characters)
  bool get isValidPassword => length >= 8;

  // Check if the string is a valid phone number (e.g., 10 digits)
  bool get isValidPhone {
    final phoneRegex = RegExp(r'^[0-9]{10}$');
    return phoneRegex.hasMatch(this);
  }

  // Check if the string is a valid name (only letters and spaces)
  bool get isValidName {
    final nameRegex = RegExp(r'^[a-zA-Z ]+$');
    return nameRegex.hasMatch(this);
  }
}

class Validator {
  static final _languageController = Get.find<LanguageController>();

  static String t(String key) => _languageController.getTranslation(key);

  // Generic validator for required fields
  static String? validateRequired(String? value, {String? fieldName}) {
    if (value == null || value.trim().isEmpty) {
      return fieldName == null
          ? t('fieldRequired')
          : '$fieldName ${t('fieldRequired')}';
    }
    return null;
  }

  // Email validation
  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return t('fieldRequired');
    }
    if (!value.isValidEmail) {
      return t('valid email');
    }
    return null;
  }

  // Password validation
  static String? validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return t('fieldRequired');
    }
    if (!value.isValidPassword) {
      return t('valid password');
    }
    return null;
  }

  // Phone number validation
  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return t('phoneRequired');
    }
    if (!value.isValidPhone) {
      return t('invalidPhone');
    }
    return null;
  }

  // Name validation
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return t('nameRequired');
    }
    if (!value.isValidName) {
      return t('invalidName');
    }
    return null;
  }
}
