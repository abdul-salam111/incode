/*
class InterventionHistory {
  final int id;
  final String datetime;
  final String userName;
  final String typeDescription;
  final String icon;
  final String color;

  InterventionHistory({
    required this.id,
    required this.datetime,
    required this.userName,
    required this.typeDescription,
    required this.icon,
    required this.color,
  });

  factory InterventionHistory.fromJson(Map<String, dynamic> json) {
    return InterventionHistory(
      id: json['id_intervention'],
      datetime: json['datetime_intervention'],
      userName: json['user_full_name'],
      typeDescription: json['description_type_intervention'] ?? "",
      icon: json['intervention_icon'] ?? "info",
      color: json['intervention_color'] ?? "primary",
    );
  }
}
*/
class Intervention {
  final int idIntervention;
  final String datetimeIntervention;
  final int idUser;
  final String userFullName;
  final int idCompanyUser;
  final int? idCompany; // Nullable
  final String? descriptionCompany; // Nullable
  final int idTypeIntervention;
  final String descriptionTypeIntervention;
  final int idSystemIntervention;
  final String descriptionIntervention;
  final int? idProject; // Nullable
  final String? titleProject; // Nullable
  final String? subtitleProject; // Nullable
  final String? descriptionTypeProject; // Nullable
  final int? idPoint; // Nullable
  final String? descriptionPoint; // Nullable
  final String? descriptionTypePoint; // Nullable
  final Map<String, dynamic> detailsPoint;
  final int idObject;
  final String? descriptionTypeObject; // Nullable
  final Map<String, dynamic> detailsObject;
  final String interventionColor;
  final String interventionIcon;

  Intervention({
    required this.idIntervention,
    required this.datetimeIntervention,
    required this.idUser,
    required this.userFullName,
    required this.idCompanyUser,
    this.idCompany,
    this.descriptionCompany,
    required this.idTypeIntervention,
    required this.descriptionTypeIntervention,
    required this.idSystemIntervention,
    required this.descriptionIntervention,
    this.idProject,
    this.titleProject,
    this.subtitleProject,
    this.descriptionTypeProject,
    this.idPoint,
    this.descriptionPoint,
    this.descriptionTypePoint,
    required this.detailsPoint,
    required this.idObject,
    this.descriptionTypeObject,
    required this.detailsObject,
    required this.interventionColor,
    required this.interventionIcon,
  });

  factory Intervention.fromJson(Map<String, dynamic> json) {
    return Intervention(
      idIntervention: json['id_intervention'] ?? 0,
      datetimeIntervention: json['datetime_intervention'] ?? '',
      idUser: json['id_user'] ?? 0,
      userFullName: json['user_full_name'] ?? '',
      idCompanyUser: json['id_company_user'] ?? 0,
      idCompany: json['id_company'], // Already nullable
      descriptionCompany: json['description_company'],
      idTypeIntervention: json['id_type_intervention'] ?? 0,
      descriptionTypeIntervention: json['description_type_intervention'] ?? '',
      idSystemIntervention: json['id_system_intervention'] ?? 0,
      descriptionIntervention: json['description_intervention'] ?? '',
      idProject: json['id_project'],
      titleProject: json['title_project'],
      subtitleProject: json['subtitle_project'],
      descriptionTypeProject: json['description_type_project'],
      idPoint: json['id_point'],
      descriptionPoint: json['description_point'],
      descriptionTypePoint: json['description_type_point'],
      detailsPoint: json['details_point'] is Map ? json['details_point'] : {},
      idObject: json['id_object'] ?? 0,
      descriptionTypeObject: json['description_type_object'],
      detailsObject: json['details_object'] is Map ? json['details_object'] : {},
      interventionColor: json['intervention_color'] ?? 'primary',
      interventionIcon: json['intervention_icon'] ?? 'help_outline',
    );
  }
}