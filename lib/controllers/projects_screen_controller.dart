// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http show post;
import 'package:in_code/config/exceptions/app_exceptions.dart';
import 'package:in_code/config/storage/sharedpref_keys.dart';

import 'package:in_code/controllers/login_controller.dart';
import 'package:in_code/models/get_all_subprojects.dart';
import 'package:in_code/pages/no_internet_screen.dart';

import 'package:in_code/repositories/projects_repository.dart';
import 'package:in_code/res/app_urls.dart';
import 'package:in_code/utils/utils.dart';
import '../models/category.dart';

class ProjectScreenController extends GetxController {
  // Focus node for the search field
  final searchFocusNode = FocusNode();

  // List of all categories and their projects fetched from API
  final RxList<CategoriesModel> allCategories = <CategoriesModel>[].obs;

  // List to hold filtered categories based on the search
  final RxList<CategoriesModel> filteredCategories = <CategoriesModel>[].obs;

  // Controller for search TextField
  final searchController = TextEditingController().obs;
  var projectTitle = "".obs;
  var projectSubtittle = "".obs;
  // Holds the currently selected project ID
  final RxInt? selectedProjectId = RxInt(-1);
  final RxInt? selectedProjectNum = RxInt(-1);
  // Stores the current search query
  var query = "".obs;
  RxBool isDataLoaded = false.obs;
  // Maintains expansion state (expanded/collapsed) for each category
  final expandedStates = <String, bool>{}.obs;

  // Login controller instance to get user details
  final LoginController loginController = Get.put(LoginController());

  // Boolean to indicate loading state
  var isloading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Fetch all categories and their associated projects on controller init
    fetchProjectsWithCategories();
    final savedStates = box.read<Map>('expandedStates') ?? {};
    expandedStates.assignAll(savedStates.map((k, v) => MapEntry(k, v as bool)));
    initConnectivity();
    connectivity.onConnectivityChanged.listen((
      List<ConnectivityResult> results,
    ) {
      _updateConnectionStatus(results);
    });

    // Load the saved selected project ID
    final savedProjectId = box.read<int>('selectedProjectId');
    if (savedProjectId != null) {
      selectedProjectId!.value = savedProjectId;
    }
    final savedProjectModel = box.read('selectedProject');

    if (savedProjectModel != null) {
      final restoredModel = GetAllSubProjects.fromJson(
        Map<String, dynamic>.from(savedProjectModel),
      );

      getAllSubprojects.value = restoredModel;
    }
  }

  // Toggles the expansion state of a given category by its ID
  void toggleExpansion(String categoryId) {
    final current = expandedStates[categoryId] ?? false;
    expandedStates[categoryId] = !current;
    box.write('expandedStates', expandedStates);
  }

  // Checks if a given category is currently expanded
  bool isExpanded(String categoryId) {
    return expandedStates[categoryId] ?? false;
  }

  // Fetches all project categories and updates both master and filtered lists
  Future<void> fetchProjectsWithCategories() async {
    try {
      isloading.value = true;

      // First check internet connection
      await initConnectivity();
      if (!hasInternetConnection.value) {
        await Get.to(() => NoInternetScreen());
        return;
      }

      allCategories.value = await projectsRepostiory
          .getAllProjectsWithCategory();
      filteredCategories.value = List.from(allCategories);
      extractProjectDetailsById(selectedProjectId!.value);
      isloading.value = false;
      isDataLoaded.value = true;
    } on NoInternetException {
      isloading.value = false;
      await Get.to(
        () => NoInternetScreen(),
      ); // Use offAll to prevent going back
    } catch (e) {
      isloading.value = false;
      Get.snackbar("Error", "Failed to fetch projects");
    }
  }

  void extractProjectDetailsById(int id) {
    for (final category in filteredCategories) {
      for (final project in category.projects) {
        if (project.id == id) {
          projectTitle.value = project.title;
          projectSubtittle.value = project.subtitle;

          return;
        }
      }
    }
  }

  // Filters categories and their projects based on the search query
  void searchProjects() {
    final queryText = query.value.toLowerCase();
    if (queryText.isEmpty) {
      // If search is empty, restore original list
      filteredCategories.value = List.from(allCategories);
    } else {
      // Filter categories and projects based on search query
      filteredCategories.value = allCategories
          .map((cat) {
            final isCategoryMatch = cat.name.toLowerCase().contains(queryText);
            final filteredProjects = cat.projects
                .where(
                  (proj) =>
                      proj.title.toLowerCase().contains(queryText) ||
                      proj.subtitle.toLowerCase().contains(queryText),
                )
                .toList();

            // If category name matches, return the whole category
            if (isCategoryMatch) {
              return CategoriesModel(
                id: cat.id,
                name: cat.name,
                projects: cat.projects,
              );
            }

            // Otherwise, return category with only matching projects
            return CategoriesModel(
              id: cat.id,
              name: cat.name,
              projects: filteredProjects,
            );
          })
          // Keep only those categories which have at least one project after filtering
          .where((cat) => cat.projects.isNotEmpty)
          .toList();
    }
  }

  // Checks if a project is currently selected
  bool isSelected(int id) => selectedProjectId!.value == id;

  // Holds the fetched subprojects for the selected project
  final getAllSubprojects = GetAllSubProjects().obs;

  // Instance of repository to handle API calls
  ProjectsRepostiory projectsRepostiory = ProjectsRepostiory();

  var gettingsubjProjects = false.obs;
  // Fetch subprojects based on selected project and user ID
  // Future getAllSubProjects() async {
  //   try {
  //     gettingsubjProjects.value = true;
  //     getAllSubprojects.value = await projectsRepostiory.getAllSubProjects(
  //       version: "2",
  //       idUser: '${box.read(userId)}',
  //       projectID: selectedProjectId!.value.toString(),
  //     );
  //     gettingsubjProjects.value = false;
  //   } catch (e) {
  //     gettingsubjProjects.value = false;
  //     print(e);
  //   }
  // }

  //check internet connectivity

  final Connectivity connectivity = Connectivity();
  var hasInternetConnection = true.obs;
  var wasOffline = false.obs;

  Future<void> initConnectivity() async {
    var results = await connectivity.checkConnectivity();
    return _updateConnectionStatus(results);
  }

  Future<void> _updateConnectionStatus(List<ConnectivityResult> results) async {
    final previouslyOffline = !hasInternetConnection.value;
    // Check if any of the results indicate an active connection
    hasInternetConnection.value = results.any(
      (result) => result != ConnectivityResult.none,
    );

    // Set wasOffline flag when connection is lost
    if (!hasInternetConnection.value) {
      wasOffline.value = true;
    }
  }

  Future<void> selectProject(int id, BuildContext context) async {
    try {
      if (box.read('selectedProject') != null) {
        box.remove('selectedProject');
      }

      // Check internet connection before proceeding
      await initConnectivity();
      if (!hasInternetConnection.value) {
        await Get.to(NoInternetScreen());
        return;
      }

      gettingsubjProjects.value = true;
      selectedProjectId!.value = id;
      print({
        'version': '2',
        'id_user': '${box.read(userId)}',
        'id_project': id.toString(),
      });
      var uri = Uri.parse(AppUrls.getAllsubProjects);
      final response = await http.post(
        uri,
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {
          'version': '2',
          'id_user': '${box.read(userId)}',
          'id_project': id.toString(),
        },
      );

      if (response.statusCode == 200) {
        final parsedData = GetAllSubProjects.fromJson(
          json.decode(response.body),
        );

        getAllSubprojects.value = parsedData;
        box.write('selectedProjectId', id);
        box.write("selectedProject", getAllSubprojects.value);
      } else {
        throw Exception('Failed to select project: ${response.statusCode}');
      }

      gettingsubjProjects.value = false;
    } on NoInternetException {
      Utils.anotherFlushbar(context, "Connessione disconnessa", Colors.red);
    } catch (e) {
      gettingsubjProjects.value = false;
      selectedProjectId!.value = -1;
    }
  }
}
