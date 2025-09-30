class Project {
  final int idProject;
  final String title;
  final String subtitle;
  final int idCompany;

  Project({
    required this.idProject,
    required this.title,
    required this.subtitle,
    required this.idCompany,
  });

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      idProject: json['id_project'],
      title: json['title'],
      subtitle: json['subtitle'],
      idCompany: json['id_company'],
    );
  }
}

class ProjectCategory {
  final String idCategory;
  final String category;
  final List<Project> projects;

  ProjectCategory({
    required this.idCategory,
    required this.category,
    required this.projects,
  });

  factory ProjectCategory.fromJson(Map<String, dynamic> json) {
    var projectsList = (json['projects'] as List)
        .map((project) => Project.fromJson(project))
        .toList();

    return ProjectCategory(
      idCategory: json['id_category'],
      category: json['category'],
      projects: projectsList,
    );
  }
}
