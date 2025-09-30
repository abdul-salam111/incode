import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_code/config/exceptions/app_exceptions.dart';
import 'package:in_code/config/network/network_services_api.dart';

import 'package:http/http.dart' as http;
import 'package:in_code/models/login_model.dart';
import 'package:in_code/models/reset_password_model.dart';
import 'package:in_code/widgets/success_popup.dart';

import '../res/res.dart';

class AuthReository {
  final network = NetworkServicesApi();
  Future<LoginResponseModel> loginUser(
      {required String email, required String password}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse(AppUrls.login));
      request.fields.addAll({
        'version': '2.0',
        'email': email,
        'password': password,
      });

      http.StreamedResponse response = await request.send();
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        var data = jsonDecode(responseBody);
        print('Login successful: $data');
        return LoginResponseModel.fromJson(data);
      } else if (response.statusCode == 401) {
        print('Unauthorized: ${response.statusCode}');
        throw WrongCredentialsException();
      } else {
        throw Exception();
      }
    } on NoInternetException catch (error) {
      throw Exception(error);
    }
  }

  Future<bool> resetPassword(ResetPasswordModel resetPassword) async {
    try {
      var uri = Uri.parse("http://www.in-code.cloud:8888/api/1/user/set_password");
      var request = http.MultipartRequest('POST', uri);
      resetPassword.toJson().forEach((key, value) {
        request.fields[key] = value;
      });

      // Send the request
      var response = await request.send();
     print('this is response ${response.statusCode}');
      if (response.statusCode == 200) {
        return true;
      } else if (response.statusCode == 400) {
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => CustomScanDialog(
            onContinue: () => Get.back(),
            onCancel: () => 
            Get.back(),
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
            description: "La tua richiesta non è valida. Riprova.",
          ),
        );
        return false;
        // throw BadRequestException();
      } else if (response.statusCode == 401) {
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => CustomScanDialog(
            onContinue: () => Get.back(),
            onCancel: () => 
            Get.back(),
            oneButtonOnPressed: () {
              Get.back();
              print('Unauthorized');
            },
            isOneButton: true,
            titleColor: AppColors.secondaryColor,
            icon: Icons.close,
            iconBackgroundColor: AppColors.secondaryColor,
            continueButtonColor: AppColors.secondaryColor,
            title: "Non autorizzato",
            description: "Accesso negato. Controlla le tue credenziali.",
          ),
        );
        return false;
        // throw UnauthorizedException();
      } else {
        throw Exception("Error: ${response.statusCode}");
      }
    } catch (e) {
      if (e is NoInternetException) {
        showDialog(
          context: Get.context!,
          barrierDismissible: false,
          builder: (_) => CustomScanDialog(
            onContinue: () => Get.back(),
            onCancel: () => 
            Get.back(),
            oneButtonOnPressed: () {
              Get.back();
              print('No Internet');
            },
            isOneButton: true,
            titleColor: AppColors.secondaryColor,
            icon: Icons.close,
            iconBackgroundColor: AppColors.secondaryColor,
            continueButtonColor: AppColors.secondaryColor,
            title: "Errore di connessione",
            description: "Controlla la tua connessione internet e riprova.",
          ),
        );
        return false;
        // throw NoInternetException();
      } else if (e is UnauthorizedException) {
        throw UnauthorizedException();
      } else if (e is BadRequestException) {
        throw BadRequestException();
      }

      throw Exception(e);
    }
  }
}
