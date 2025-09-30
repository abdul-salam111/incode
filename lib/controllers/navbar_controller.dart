import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:in_code/controllers/dettaglioggetto_controller.dart';
import 'package:in_code/controllers/projects_screen_controller.dart';
import 'package:in_code/controllers/scan_controller.dart';
import 'package:in_code/models/scannedQrCode_data.dart';
import 'package:in_code/pages/assegnaOggetto.dart';
import 'package:in_code/pages/cambia_seleziona_punto.dart';
import 'package:in_code/pages/dettaglioggetto_2.dart';
import 'package:in_code/pages/esegui_Interventi.dart';
import 'package:in_code/pages/interventionScreen.dart';
import 'package:in_code/pages/nodettaglioggeto.dart';
import 'package:in_code/pages/profile_screen.dart';
import 'package:in_code/pages/projects/projects_screen.dart';
import 'package:in_code/pages/dettaglioggetto_1.dart';
import 'package:in_code/pages/relabel_detailscreen.dart';
import 'package:in_code/pages/relabel_projectscreen.dart';
import 'package:in_code/pages/relabel_scanner.dart';
import 'package:in_code/pages/scanner.dart';
import 'package:in_code/pages/seleziona_punto.dart';
import 'package:in_code/pages/type_object_manual.dart';
import 'package:in_code/pages/utiliti_screen.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class NavbarController extends GetxController {
  var selectedIndex = 0.obs;

  final ScrollController interventiScrollController = ScrollController();
  void goBack() {
    Get.back();
  }
  void goToTab(int index) {
    print("Selected index: $index");
    // if (selectedIndex.value == 5 && index != 5) {
    // // Optionally reset scanned page when user leaves it
    // pages[5] =  DettagliOggettoScreen1(data: null);
    // }

    if (selectedIndex.value == index) {
      if (index == 1) {
        if (interventiScrollController.hasClients) {
          print("Scrolling to top of interventions");
          interventiScrollController.animateTo(
            0,
            duration: const Duration(milliseconds: 1000),
            curve: Curves.easeOut,
          );
        }
      }
    } else {
      selectedIndex.value = index;
    }
  }
  void navigatetoAssegnaOggetto(){
      pages[15] = AssegnaOggetto();
      selectedIndex.value = 15;
  }
  void navigatetoTypeObjectScreen(codeobject){
    pages[14] = TypeObjectScreen(codeObject: codeobject,); // Use the provided data
  selectedIndex.value = 14;
  }
  void navigatetoRelableScanner() {
  pages[13] = RelabelScanner(); // Use the provided data
  selectedIndex.value = 13;
}
  void navigatetoDetailRelabelScreen(){
    print('onDetailLabel screen');
    pages[12] = DetailRelabelScreen(); 
      selectedIndex.value = 12;
  }
 void navigatetoRelabelProjectScreen() {
  try {
    final scannerController = Get.find<MobileScannerController>();
    scannerController.stop();
  } catch (_) {}

  WidgetsBinding.instance.addPostFrameCallback((_) {
    print('onDetailLabel screen');
    pages[11] = DetailRelabelScreen();
    selectedIndex.value = 11;
  });
}
 void navigatetoDettagliOggettoScreen1(ScannedQrCodeDataModel data) {
  pages[5] = DettagliOggettoScreen1(data: data); // Use the provided data
  selectedIndex.value = 5;
}
 void navigatetoDettagliOggettoScreen(ScannedQrCodeDataModel data) {
  pages[7] = UnifiedDettagliOggettoScreen(data: data); // Use the provided data
  selectedIndex.value = 7;
}
void navigateTocambiaPosizone(){
 pages[10] = CambiaPosizioneScreen(); // Use the provided data
  selectedIndex.value = 10;
}

void navigatetoSelezinaPunto() {
  pages[9] = SelezionaPuntoScreen(); // Use the provided data
  selectedIndex.value = 9;
}
void navigatetoNoDettagliOggettoScreen(ScannedQrCodeDataModel data) {
  pages[8] = NodettaglioggetoScreen(data: data); // Use the provided data
  selectedIndex.value = 8;
}
 void navigateEseguiInterventoScreen() {
  pages[6] = EseguiInterventoScreen();
   selectedIndex.value = 6; // Ensure this is an instance of the screen widget
  
}

void gotoUtility(){
  selectedIndex.value = 3; // Set the index for the ScannerScreen
  pages[3] = UtilitiScreen();
}
void goToScanner() {
  selectedIndex.value = 2; // Set the index for the ScannerScreen
  pages[2] = ScannerScreen();
 } // Ensure the ScannerScreen is initialized

  var pages = [
    ProjectScreen(),
    InterventiScreen(),
    ScannerScreen(),
    UtilitiScreen(),
    ProfileScreen(),
    DettagliOggettoScreen1(data:  null),
    UnifiedDettagliOggettoScreen(data: ScannedQrCodeDataModel()), // Provide a default instance
    // DettagliOggettoScreen2(data: null),
    NodettaglioggetoScreen(data: null), // Initialize with null data
    EseguiInterventoScreen(),
    SelezionaPuntoScreen(),
    CambiaPosizioneScreen(),
    RelabelProjectScreen(),
    DetailRelabelScreen(),
    AssegnaOggetto(),
    RelabelScanner(),
     TypeObjectScreen(codeObject: ''), // Initialize with an empty string
  ];

  void logoutAndResetControllers() {
    // Delete all relevant controllers to reset state
    Get.delete<QRCodeController>(force: true);
    Get.delete<ProjectScreenController>(force: true);
    Get.delete<DettaglioOggettoController>(force: true);
    // Add any other controllers you use here
    // Optionally clear storage or other state
    // GetStorage().erase();
  }
}
