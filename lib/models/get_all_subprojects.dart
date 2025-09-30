// To parse this JSON data, do
//
//     final getAllSubProjects = getAllSubProjectsFromJson(jsonString);

import 'dart:convert';

GetAllSubProjects getAllSubProjectsFromJson(String str) =>
    GetAllSubProjects.fromJson(json.decode(str));

String getAllSubProjectsToJson(GetAllSubProjects data) =>
    json.encode(data.toJson());

class GetAllSubProjects {
  List<PointsList>? pointsList;
  List<dynamic>? objectsList;
  List<TypeInterventionList>? typeInterventionList;
  List<dynamic>? associationList;

  GetAllSubProjects({
    this.pointsList,
    this.objectsList,
    this.typeInterventionList,
    this.associationList,
  });

  GetAllSubProjects copyWith({
    List<PointsList>? pointsList,
    List<dynamic>? objectsList,
    List<TypeInterventionList>? typeInterventionList,
    List<dynamic>? associationList,
  }) =>
      GetAllSubProjects(
        pointsList: pointsList ?? this.pointsList,
        objectsList: objectsList ?? this.objectsList,
        typeInterventionList: typeInterventionList ?? this.typeInterventionList,
        associationList: associationList ?? this.associationList,
      );

  factory GetAllSubProjects.fromJson(Map<String, dynamic> json) =>
      GetAllSubProjects(
        pointsList: json["points_list"] == null
            ? []
            : List<PointsList>.from(
                json["points_list"]!.map((x) => PointsList.fromJson(x))),
        objectsList: json["objects_list"] == null
            ? []
            : List<dynamic>.from(json["objects_list"]!.map((x) => x)),
        typeInterventionList: json["type_intervention_list"] == null
            ? []
            : List<TypeInterventionList>.from(json["type_intervention_list"]!
                .map((x) => TypeInterventionList.fromJson(x))),
        associationList: json["association_list"] == null
            ? []
            : List<dynamic>.from(json["association_list"]!.map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "points_list": pointsList == null
            ? []
            : List<dynamic>.from(pointsList!.map((x) => x.toJson())),
        "objects_list": objectsList == null
            ? []
            : List<dynamic>.from(objectsList!.map((x) => x)),
        "type_intervention_list": typeInterventionList == null
            ? []
            : List<dynamic>.from(typeInterventionList!.map((x) => x.toJson())),
        "association_list": associationList == null
            ? []
            : List<dynamic>.from(associationList!.map((x) => x)),
      };
}

class PointsList {
  int? idPoint;
  String? descriptionPoint;
  int? idTypePoint;
  String? descriptionTypePoint;
  dynamic idPosition;
  DetailsPoint? detailsPoint;

  PointsList({
    this.idPoint,
    this.descriptionPoint,
    this.idTypePoint,
    this.descriptionTypePoint,
    this.idPosition,
    this.detailsPoint,
  });

  PointsList copyWith({
    int? idPoint,
    String? descriptionPoint,
    int? idTypePoint,
    String? descriptionTypePoint,
    dynamic idPosition,
    DetailsPoint? detailsPoint,
  }) =>
      PointsList(
        idPoint: idPoint ?? this.idPoint,
        descriptionPoint: descriptionPoint ?? this.descriptionPoint,
        idTypePoint: idTypePoint ?? this.idTypePoint,
        descriptionTypePoint: descriptionTypePoint ?? this.descriptionTypePoint,
        idPosition: idPosition ?? this.idPosition,
        detailsPoint: detailsPoint ?? this.detailsPoint,
      );

  factory PointsList.fromJson(Map<String, dynamic> json) => PointsList(
        idPoint: json["id_point"],
        descriptionPoint: json["description_point"],
        idTypePoint: json["id_type_point"],
        descriptionTypePoint: json["description_type_point"],
        idPosition: json["id_position"],
        detailsPoint: json["details_point"] == null
            ? null
            : DetailsPoint.fromJson(json["details_point"]),
      );

  Map<String, dynamic> toJson() => {
        "id_point": idPoint,
        "description_point": descriptionPoint,
        "id_type_point": idTypePoint,
        "description_type_point": descriptionTypePoint,
        "id_position": idPosition,
        "details_point": detailsPoint?.toJson(),
      };
}

class DetailsPoint {
  Map<String, dynamic>? data;

  DetailsPoint({this.data});

  DetailsPoint copyWith({Map<String, dynamic>? data}) =>
      DetailsPoint(data: data ?? this.data);

  factory DetailsPoint.fromJson(Map<String, dynamic> json) =>
      DetailsPoint(data: json);

  Map<String, dynamic> toJson() => data ?? {};
}

class TypeInterventionList {
  int? idTypeIntervention;
  String? descriptionTypeIntervention;
  dynamic idProject;
  dynamic idTypeObject;
  int? idSystemIntervention;

  TypeInterventionList({
    this.idTypeIntervention,
    this.descriptionTypeIntervention,
    this.idProject,
    this.idTypeObject,
    this.idSystemIntervention,
  });

  TypeInterventionList copyWith({
    int? idTypeIntervention,
    String? descriptionTypeIntervention,
    dynamic idProject,
    dynamic idTypeObject,
    int? idSystemIntervention,
  }) =>
      TypeInterventionList(
        idTypeIntervention: idTypeIntervention ?? this.idTypeIntervention,
        descriptionTypeIntervention:
            descriptionTypeIntervention ?? this.descriptionTypeIntervention,
        idProject: idProject ?? this.idProject,
        idTypeObject: idTypeObject ?? this.idTypeObject,
        idSystemIntervention: idSystemIntervention ?? this.idSystemIntervention,
      );

  factory TypeInterventionList.fromJson(Map<String, dynamic> json) =>
      TypeInterventionList(
        idTypeIntervention: json["id_type_intervention"],
        descriptionTypeIntervention: json["description_type_intervention"],
        idProject: json["id_project"],
        idTypeObject: json["id_type_object"],
        idSystemIntervention: json["id_system_intervention"],
      );

  Map<String, dynamic> toJson() => {
        "id_type_intervention": idTypeIntervention,
        "description_type_intervention": descriptionTypeIntervention,
        "id_project": idProject,
        "id_type_object": idTypeObject,
        "id_system_intervention": idSystemIntervention,
      };
}
