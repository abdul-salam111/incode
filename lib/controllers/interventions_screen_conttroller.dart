import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_code/models/intervention_model.dart';
import 'package:in_code/pages/no_internet_screen.dart';
import 'package:in_code/repositories/interventions.dart';
import 'package:in_code/res/colors.dart';
import 'package:in_code/widgets/success_popup.dart';
class InterventionController extends GetxController {
  var isLoading = false.obs;
  var interventions = <InterventionModel>[].obs;
  var hasMoreData = true.obs;
  var currentPage = 0.obs;
  final int itemsPerPage = 20;
  var hasConnectionError = false
      .obs; 

  InterventionController() {
    fetchAllInterventions();
  }

  InterventionsRepository interventionsRepository = InterventionsRepository();

  Future fetchAllInterventions() async {
    if (isLoading.value || !hasMoreData.value) return;
    
    try {
      isLoading.value = true;
      hasConnectionError.value = false; 
      
      final response = await interventionsRepository.fetchAllInterventions(
        offset: (currentPage.value * itemsPerPage),
        limit: itemsPerPage,
      ).timeout(const Duration(seconds: 10));

      final decodedData = jsonDecode(response);

      if (decodedData is List) {
        final newInterventions = decodedData
            .map((e) => InterventionModel.fromJson(e))
            .toList();

        if (newInterventions.isEmpty) {
          hasMoreData.value = false;
        } else {
          interventions.addAll(newInterventions);
          if (newInterventions.length >= itemsPerPage) {
            currentPage.value++;
          } else {
            hasMoreData.value = false;
          }
        }
      } else {
        throw Exception('Expected a list but got ${decodedData.runtimeType}');
      }
    } catch (e) {
      hasConnectionError.value = true;
      debugPrint("Error fetching interventions: $e");
      // print("hasConnectionError.value: ${hasConnectionError.value}");
    } finally {
      isLoading.value = false;
    }
  }

  void resetPagination() {
    interventions.clear();
    currentPage.value = 0;
    hasMoreData.value = true;
    hasConnectionError.value = false;
    fetchAllInterventions();
  }

  void resetConnectionError() {
    hasConnectionError.value = false;
  }
}