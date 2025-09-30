import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'app_translations.dart';

class LanguageController extends GetxController {
  static LanguageController get to => Get.find();
  final _storage = GetStorage();
  final _languageKey = 'app_language';
  
  // Observable language code
  final RxString currentLanguage = 'it'.obs;
  
  @override
  void onInit() {
    super.onInit();
    loadSavedLanguage();
  }
  
  // Load saved language from storage
  void loadSavedLanguage() {
    final savedLanguage = _storage.read(_languageKey);
    if (savedLanguage != null) {
      currentLanguage.value = savedLanguage;
    } else {
      // Set Italian as default if no language is saved
      currentLanguage.value = 'it';
      _storage.write(_languageKey, 'it');
    }
  }
  
  // Change language
  void changeLanguage(String languageCode) {
    if (languageCode != currentLanguage.value) {
      currentLanguage.value = languageCode;
      _storage.write(_languageKey, languageCode);
      update();
    }
  }
  
  // Get translation for a key
  String getTranslation(String key) {
    return AppTranslations.translations[currentLanguage.value]?[key] ?? key;
  }
  
  // Get language name from code
  String getLanguageName(String code) {
    switch (code) {
      case 'en':
        return 'English';
      case 'it':
        return 'Italian';
      default:
        return code;
    }
  }
  
  // Get language flag emoji
  String getLanguageFlag(String code) {
    switch (code) {
      case 'en':
        return '🇺🇸';
      case 'it':
        return '🇮🇹';
      default:
        return '';
    }
  }
} 