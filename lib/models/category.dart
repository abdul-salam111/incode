class GetAllCategoriesModel {
  final int id;
  final String title;
  final String subtitle;
  final int companyId;

  GetAllCategoriesModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.companyId,
  });

  factory GetAllCategoriesModel.fromJson(Map<String, dynamic> json) =>
      GetAllCategoriesModel(
        id: json['id_project'],
        title: json['title'],
        subtitle: json['subtitle'],
        companyId: json['id_company'],
      );
}

class CategoriesModel {
  final int id;
  final String name;
  final List<GetAllCategoriesModel> projects;

  CategoriesModel({
    required this.id,
    required this.name,
    required this.projects,
  });

  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      CategoriesModel(
        id: int.parse(json['id_category']),
        name: json['category'],
        projects: (json['projects'] as List)
            .map((p) => GetAllCategoriesModel.fromJson(p))
            .toList(),
      );
}
