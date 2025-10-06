import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_code/models/intervention_model.dart';
import 'package:in_code/repositories/interventions.dart';

class InterventionController extends GetxController {
  var isLoading = false.obs;
  var interventions = <InterventionModel>[].obs; // Displayed interventions
  var allInterventions =
      <InterventionModel>[].obs; // All interventions cached locally
  var hasMoreData = true.obs;
  var currentPage = 0.obs;
  final int itemsPerPage = 20;
  var hasConnectionError = false.obs;
  var isInitialLoad = true.obs; // Track if we've loaded all data from API

  InterventionController() {
    fetchAllInterventionsFromAPI();
  }

  InterventionsRepository interventionsRepository = InterventionsRepository();

  // Fetch all interventions from API once
  Future<void> fetchAllInterventionsFromAPI() async {
    if (isLoading.value) return;

    try {
      isLoading.value = true;
      hasConnectionError.value = false;

      final response = await interventionsRepository
          .fetchAllInterventions(
            offset: 0,
            limit: 1000, 
          )
          .timeout(const Duration(seconds: 30));

      final decodedData = jsonDecode(response);

      if (decodedData is List) {
        allInterventions.value = decodedData
            .map((e) => InterventionModel.fromJson(e))
            .toList();

        // Load first page
        isInitialLoad.value = false;
        isLoading.value = false; // Reset loading before calling loadNextPage
        await loadNextPage();
      } else {
        throw Exception('Expected a list but got ${decodedData.runtimeType}');
      }
    } catch (e) {
      hasConnectionError.value = true;
      isInitialLoad.value = false;
      debugPrint("Error fetching interventions: $e");
      isLoading.value = false;
    }
  }

  // Load next page from local cache with simulated delay
  Future<void> loadNextPage() async {
    if (isLoading.value || !hasMoreData.value) return;

    // If we haven't loaded from API yet, don't proceed
    if (isInitialLoad.value) return;

    try {
      isLoading.value = true;

      // Simulate API delay of 1 second
      await Future.delayed(const Duration(seconds: 1));

      final startIndex = currentPage.value * itemsPerPage;
      final endIndex = startIndex + itemsPerPage;

      // Check if we have more data
      if (startIndex >= allInterventions.length) {
        hasMoreData.value = false;
        return;
      }

      // Get the next page of interventions
      final nextPageInterventions = allInterventions.sublist(
        startIndex,
        endIndex > allInterventions.length ? allInterventions.length : endIndex,
      );

      // Add to displayed interventions
      interventions.addAll(nextPageInterventions);

      // Update page and check if there's more data
      currentPage.value++;
      if (endIndex >= allInterventions.length) {
        hasMoreData.value = false;
      }
    } catch (e) {
      debugPrint("Error loading next page: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void resetPagination() {
    interventions.clear();
    currentPage.value = 0;
    hasMoreData.value = true;

    // If we already have data cached, just reload first page
    if (allInterventions.isNotEmpty) {
      loadNextPage();
    } else {
      // Otherwise fetch from API
      isInitialLoad.value = true;
      hasConnectionError.value = false;
      fetchAllInterventionsFromAPI();
    }
  }

  void resetConnectionError() {
    hasConnectionError.value = false;
  }

  ///////////////////code for searching and filtering intervention////////////////
  final RxString searchQuery = ''.obs;
  final searchController = TextEditingController();

  // Computed property that returns filtered interventions
  List<InterventionModel> get filteredInterventions {
    if (searchQuery.value.isEmpty) {
      return interventions;
    }

    final query = searchQuery.value.toLowerCase().trim();

    return interventions.where((intervention) {
      // Search in intervention type description
      if (intervention.descriptionTypeIntervention?.toLowerCase().contains(
            query,
          ) ==
          true) {
        return true;
      }

      // Search in user full name
      if (intervention.userFullName?.toLowerCase().contains(query) == true) {
        return true;
      }

      // Search in intervention description/notes
      if (intervention.descriptionIntervention?.toLowerCase().contains(query) ==
          true) {
        return true;
      }

      // Search in company description
      if (intervention.descriptionCompany?.toLowerCase().contains(query) ==
          true) {
        return true;
      }

      // Search in project type description
      if (intervention.descriptionTypeProject?.toLowerCase().contains(query) ==
          true) {
        return true;
      }

      // Search in project title
      if (intervention.titleProject?.toLowerCase().contains(query) == true) {
        return true;
      }

      // Search in project subtitle
      if (intervention.subtitleProject?.toLowerCase().contains(query) == true) {
        return true;
      }

      // Search in point description
      if (intervention.descriptionPoint?.toLowerCase().contains(query) ==
          true) {
        return true;
      }

      // Search in point type description
      if (intervention.descriptionTypePoint?.toLowerCase().contains(query) ==
          true) {
        return true;
      }

      // Search in object type description
      if (intervention.descriptionTypeObject?.toLowerCase().contains(query) ==
          true) {
        return true;
      }

      // Search in point details
      if (intervention.detailsPoint != null) {
        final detailsMap = intervention.detailsPoint!.toJson();
        if (_searchInMap(detailsMap, query)) {
          return true;
        }
      }

      // Search in object details
      if (intervention.detailsObject != null) {
        final detailsMap = intervention.detailsObject!.toJson();
        if (_searchInMap(detailsMap, query)) {
          return true;
        }
      }

      return false;
    }).toList();
  }

  // Helper method to search within map values
  bool _searchInMap(Map<String, dynamic> map, String query) {
    for (var value in map.values) {
      if (value != null && value.toString().toLowerCase().contains(query)) {
        return true;
      }
    }
    return false;
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
