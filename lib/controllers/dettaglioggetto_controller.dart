import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_code/controllers/scan_controller.dart';
import 'package:in_code/models/scannedQrCode_data.dart';
import 'package:in_code/res/colors.dart';
import 'package:in_code/widgets/success_popup.dart';

class DettaglioOggettoController extends GetxController {
  QRCodeController qrCodecontroller = Get.put(QRCodeController());

  RxBool isLoading = false.obs;
  var url = 'http://www.in-code.cloud:8888/api/1/object/move';

  Future<void> DettaglioggettoPostData(
    int iduser,
    String codeobject,
    int idProject,
    int idpoint,
    int movementtype,
  ) async {
    try {
      isLoading.value = true;
      print('Credentials ${iduser} ${codeobject} ${idProject} ${idpoint} ${movementtype}');
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'multipart/form-data',
         
        },
        body: jsonEncode({
          'version': 2.0,
          'id_user': iduser,
          'code_object': codeobject,
          'id_project': idProject,
          'id_point': idpoint,
          'movement_type': movementtype,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var data = response.body;
        print('✅ Data posted successfully: $data');
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => CustomScanDialog(
            onContinue: () => Get.back(),
            onCancel: () => Get.back(),
            oneButtonOnPressed: () {
              Get.back();
              print('Success dialog dismissed');
            },
            isOneButton: true,
            titleColor: Colors.green,
            icon: Icons.check_circle,
            iconBackgroundColor: Colors.green,
            continueButtonColor: Colors.green,
            title: "Successo",
            description: "Data posted successfully!",
          ),
        );
      } else {
        print('❌ Failed to post data: ${response.statusCode}');
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => CustomScanDialog(
            onContinue: () => Get.back(),
            onCancel: () => Get.back(),
            oneButtonOnPressed: () {
              Get.back();
              print('Bad Request');
            },
            isOneButton: true,
            titleColor: AppColors.secondaryColor,
            icon: Icons.close,
            iconBackgroundColor: AppColors.secondaryColor,
            continueButtonColor: AppColors.secondaryColor,
            title: "Errore di richiesta",
            description: "Try again later or contact support.",
          ),
        );
      }
    } catch (e) {
      print('🔥 Error occurred: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitObjectInterventions({
    required double version,
    required int idUser,
    required String codeObject,
    required List<Map<String, dynamic>> interventions,
  }) async {
    const String url = 'http://www.in-code.cloud:8888/api/1/object/interventions/set';

    try {
      isLoading.value = true;

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'version': version,
          'id_user': idUser,
          'code_object': codeObject,
          'interventions': interventions,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Interventions submitted successfully: $data');
      } else {
        print('❌ Failed: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('❗ Exception while submitting: $e');
    } finally {
      isLoading.value = false;
    }
  }

Future<void> removeObjectFromProject({
  required double version,
  required int idUser,
  required String codeObject,
  required int idProject,
  int? idPoint,
}) async {
  final url = Uri.parse('http://www.in-code.cloud:8888/api/1/object/move');

  final Map<String, dynamic> body = {
    'version': 2.0,
    'id_user': idUser,
    'code_object': codeObject,
    'id_project': idProject,
    'movement_type': 3,
    if (idPoint != null) 'id_point': idPoint,
  };

  try {
    isLoading.value = true;

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print('✅ Oggetto rimosso con successo.');

      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => CustomScanDialog(
          onContinue: () => Get.back(),
          onCancel: () => Get.back(),
          oneButtonOnPressed: () => Get.back(),
          isOneButton: true,
          titleColor: Colors.green,
          icon: Icons.check_circle,
          iconBackgroundColor: Colors.green,
          continueButtonColor: Colors.green,
          title: "Successo",
          description: "Oggetto rimosso con successo.",
        ),
      );
    } else {
      String errorMsg = '';
      if (response.statusCode == 400) {
        errorMsg = 'Richiesta non valida o parametri mancanti.';
      } else if (response.statusCode == 401) {
        errorMsg = 'Versione app non valida o utente disattivato.';
      } else if (response.statusCode == 404) {
        errorMsg = 'Oggetto non trovato o permessi insufficienti.';
      } else {
        errorMsg = 'Errore sconosciuto (${response.statusCode})';
      }

      showDialog(
        context: Get.context!,
        barrierDismissible: false,
        builder: (_) => CustomScanDialog(
          onContinue: () => Get.back(),
          onCancel: () => Get.back(),
          oneButtonOnPressed: () => Get.back(),
          isOneButton: true,
          titleColor: Colors.red,
          icon: Icons.error,
          iconBackgroundColor: Colors.red,
          continueButtonColor: Colors.red,
          title: "Errore",
          description: errorMsg,
        ),
      );
    }
  } catch (e) {
    print('Errore di connessione: $e');

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (_) => CustomScanDialog(
        onContinue: () => Get.back(),
        onCancel: () => Get.back(),
        oneButtonOnPressed: () => Get.back(),
        isOneButton: true,
        titleColor: Colors.red,
        icon: Icons.error_outline,
        iconBackgroundColor: Colors.red,
        continueButtonColor: Colors.red,
        title: "Errore di connessione",
        description: "Si è verificato un errore: $e",
      ),
    );
  } finally {
    isLoading.value = false;
  }
}

}
