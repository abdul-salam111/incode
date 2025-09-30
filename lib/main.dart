import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_code/core/language/language_controller.dart';
import 'package:in_code/config/network/network_manager.dart';
import 'package:in_code/pages/splash_screen.dart';
import 'package:in_code/res/res.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  await GetStorage.init();

  // Initialize language controller
  Get.put(LanguageController());
  // Initialize language controller
  Get.put(LanguageController());
  // Initialize network manager
  Get.put(NetworkManager());
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
       locale: const Locale('it'), // Set default locale to Italian
  supportedLocales: const [
    Locale('it'),
  ],
  localizationsDelegates: const [
    GlobalMaterialLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
  ],
theme: ThemeData(
    primaryColor:AppColors.primaryColor,
    colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryColor),
    useMaterial3: true, // optional, if you are using Material 3
  ),
      debugShowCheckedModeBanner: false,
      title: 'Incode',
      home: SplashScreen(),
    );
  }
}
