class ProjectResponse {
  List<PointModel>? pointsList;
  List<TypeInterventionModel>? typeInterventionList;
  List<dynamic>? associationList;

  ProjectResponse({
    this.pointsList,
    this.typeInterventionList,
    this.associationList,
  });

  factory ProjectResponse.fromJson(Map<String, dynamic> json) {
    return ProjectResponse(
      pointsList: json['points_list'] != null
          ? List<PointModel>.from(
          json['points_list'].map((x) => PointModel.fromJson(x)))
          : null,
      typeInterventionList: json['type_intervention_list'] != null
          ? List<TypeInterventionModel>.from(json['type_intervention_list']
          .map((x) => TypeInterventionModel.fromJson(x)))
          : null,
      associationList: json['association_list'],
    );
  }
}

class PointModel {
  int? idPoint;
  String? descriptionPoint;
  int? idTypePoint;
  String? descriptionTypePoint;
  int? idPosition;
  Map<String, dynamic>? detailsPoint;

  PointModel({
    this.idPoint,
    this.descriptionPoint,
    this.idTypePoint,
    this.descriptionTypePoint,
    this.idPosition,
    this.detailsPoint,
  });

  factory PointModel.fromJson(Map<String, dynamic> json) {
    return PointModel(
      idPoint: json['id_point'],
      descriptionPoint: json['description_point'],
      idTypePoint: json['id_type_point'],
      descriptionTypePoint: json['description_type_point'],
      idPosition: json['id_position'],
      detailsPoint: json['details_point'],
    );
  }
}

class TypeInterventionModel {
  int? idTypeIntervention;
  String? descriptionTypeIntervention;
  int? idProject;
  int? idTypeObject;
  int? idSystemIntervention;


  TypeInterventionModel({
    this.idTypeIntervention,
    this.descriptionTypeIntervention,
    this.idProject,
    this.idTypeObject,
    this.idSystemIntervention,
  });

  factory TypeInterventionModel.fromJson(Map<String, dynamic> json) {
    return TypeInterventionModel(
      idTypeIntervention: json['id_type_intervention'],
      descriptionTypeIntervention: json['description_type_intervention'],
      idProject: json['id_project'],
      idTypeObject: json['id_type_object'],
      idSystemIntervention: json['id_system_intervention'],
    );
  }
}