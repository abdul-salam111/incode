// To parse this JSON data, do
//
//     final scannedQrCodeDataModel = scannedQrCodeDataModelFromJson(jsonString);

import 'dart:convert';

ScannedQrCodeDataModel scannedQrCodeDataModelFromJson(String str) =>
    ScannedQrCodeDataModel.fromJson(json.decode(str));

String scannedQrCodeDataModelToJson(ScannedQrCodeDataModel data) =>
    json.encode(data.toJson());

class ScannedQrCodeDataModel {
  int? idObject;
  int? idTypeObject;
  String? descriptionTypeObject;
  int? idPosition;
  dynamic idPoint;
  dynamic idProject;
  DetailsObject? detailsObject;

  ScannedQrCodeDataModel({
    this.idObject,
    this.idTypeObject,
    this.descriptionTypeObject,
    this.idPosition,
    this.idPoint,
    this.idProject,
    this.detailsObject,
  });

  factory ScannedQrCodeDataModel.fromJson(Map<String, dynamic> json) =>
      ScannedQrCodeDataModel(
        idObject: json["id_object"],
        idTypeObject: json["id_type_object"],
        descriptionTypeObject: json["description_type_object"],
        idPosition: json["id_position"],
        idPoint: json["id_point"],
        idProject: json["id_project"],
        detailsObject: json["details_object"] == null
            ? null
            : DetailsObject.fromJson(json["details_object"]),
      );

  Map<String, dynamic> toJson() => {
        "id_object": idObject,
        "id_type_object": idTypeObject,
        "description_type_object": descriptionTypeObject,
        "id_position": idPosition,
        "id_point": idPoint,
        "id_project": idProject,
        "details_object": detailsObject?.toJson(),
      };
}

class DetailsObject {
  String? dataInizioVita;
  String? dataFineVita;
  Map<String, dynamic> otherDetails = {};

  DetailsObject({
    this.dataInizioVita,
    this.dataFineVita,
    Map<String, dynamic>? otherDetails,
  }) {
    if (otherDetails != null) {
      this.otherDetails = otherDetails;
    }
  }

  factory DetailsObject.fromJson(Map<String, dynamic> json) {
    final otherDetails = Map<String, dynamic>.from(json);
    final dataInizioVita = json["Data Inizio Vita"];
    final dataFineVita = json["Data Fine Vita"];

    // Remove known fields from otherDetails
    otherDetails.remove("Data Inizio Vita");
    otherDetails.remove("Data Fine Vita");

    return DetailsObject(
      dataInizioVita: dataInizioVita,
      dataFineVita: dataFineVita,
      otherDetails: otherDetails,
    );
  }

  Map<String, dynamic> toJson() {
    final map = {
      "Data Inizio Vita": dataInizioVita,
      "Data Fine Vita": dataFineVita,
    };

    // Merge known fields with dynamic fields
    map.addAll(
  otherDetails.map((key, value) => MapEntry(key, value?.toString())),
);

    return map;
  }
}
