class AppUrls {
  static const String baseUrl = 'http://www.in-code.cloud:8888/api/1';

  // Auth endpoints
  static const String login = '$baseUrl/sign-in';
  static const String resetPassword =
      'http://www.in-code.cloud:8888/api/1/user/reset_password';
  static const String setPassword = '$baseUrl/set-password';
  static const String getAllCategories = '$baseUrl/project';
  // Project endpoints
  static const String projects = '$baseUrl/projects';
  static const String categories = '$baseUrl/categories';

  // Intervention endpoints
  static const String interventions = '$baseUrl/interventions';

  // Profile endpoints
  static const String profile = '$baseUrl/profile';
  static const String getAllsubProjects = "$baseUrl/project/get";
}

// late GetAllCategoriesModel getAllCategoriesModel;
  // Future fetchCategoriesWithProjects() async {
  //   try {
  //     isloading.value = true;
  //    getAllCategoriesModel= await projectsRepostiory.getAllProjectsWithCategory();
  //    allCategories.value=getAllCategoriesModel.
  //   } catch (e) {}
  // }