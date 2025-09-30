import 'dart:convert';

List<InterventionModel> interventionModelFromJson(String str) =>
    List<InterventionModel>.from(
        json.decode(str).map((x) => InterventionModel.fromJson(x)));

String interventionModelToJson(List<InterventionModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class InterventionModel {
  int? idIntervention;
  DateTime? datetimeIntervention;
  int? idUser;
  String? userFullName;
  int? idCompanyUser;
  int? idCompany;
  String? descriptionCompany;
  int? idTypeIntervention;
  String? descriptionTypeIntervention;
  int? idSystemIntervention;
  String? descriptionIntervention;
  int? idProject;
  String? titleProject;
  String? subtitleProject;
  String? descriptionTypeProject;
  int? idPoint;
  String? descriptionPoint;
  String? descriptionTypePoint;
  DetailsPoint? detailsPoint;
  int? idObject;
  String? descriptionTypeObject;
  DetailsObject? detailsObject;
  String? interventionColor;
  InterventionIcon? interventionIcon;

  InterventionModel({
    this.idIntervention,
    this.datetimeIntervention,
    this.idUser,
    this.userFullName,
    this.idCompanyUser,
    this.idCompany,
    this.descriptionCompany,
    this.idTypeIntervention,
    this.descriptionTypeIntervention,
    this.idSystemIntervention,
    this.descriptionIntervention,
    this.idProject,
    this.titleProject,
    this.subtitleProject,
    this.descriptionTypeProject,
    this.idPoint,
    this.descriptionPoint,
    this.descriptionTypePoint,
    this.detailsPoint,
    this.idObject,
    this.descriptionTypeObject,
    this.detailsObject,
    this.interventionColor,
    this.interventionIcon,
  });

  factory InterventionModel.fromJson(Map<String, dynamic> json) =>
      InterventionModel(
        idIntervention: json["id_intervention"],
        datetimeIntervention: json["datetime_intervention"] == null
            ? null
            : DateTime.tryParse(json["datetime_intervention"]),
        idUser: json["id_user"],
        userFullName: json["user_full_name"]?.toString(),
        idCompanyUser: json["id_company_user"],
        idCompany: json["id_company"],
        descriptionCompany: json["description_company"]?.toString(),
        idTypeIntervention: json["id_type_intervention"],
        descriptionTypeIntervention: json["description_type_intervention"]?.toString(),
        idSystemIntervention: json["id_system_intervention"],
        descriptionIntervention: json["description_intervention"]?.toString(),
        idProject: json["id_project"],
        titleProject: json["title_project"]?.toString(),
        subtitleProject: json["subtitle_project"]?.toString(),
        descriptionTypeProject: json["description_type_project"]?.toString(),
        idPoint: json["id_point"],
        descriptionPoint: json["description_point"]?.toString(),
        descriptionTypePoint: json["description_type_point"]?.toString(),
        detailsPoint: json["details_point"] == null
            ? null
            : DetailsPoint.fromJson(json["details_point"]),
        idObject: json["id_object"],
        descriptionTypeObject: json["description_type_object"]?.toString(),
        detailsObject: json["details_object"] == null
            ? null
            : DetailsObject.fromJson(json["details_object"]),
        interventionColor: json["intervention_color"]?.toString(),
        interventionIcon: json["intervention_icon"] == null
            ? null
            : interventionIconValues.map[json["intervention_icon"]],
      );

  Map<String, dynamic> toJson() => {
        "id_intervention": idIntervention,
        "datetime_intervention": datetimeIntervention?.toIso8601String(),
        "id_user": idUser,
        "user_full_name": userFullName,
        "id_company_user": idCompanyUser,
        "id_company": idCompany,
        "description_company": descriptionCompany,
        "id_type_intervention": idTypeIntervention,
        "description_type_intervention": descriptionTypeIntervention,
        "id_system_intervention": idSystemIntervention,
        "description_intervention": descriptionIntervention,
        "id_project": idProject,
        "title_project": titleProject,
        "subtitle_project": subtitleProject,
        "description_type_project": descriptionTypeProject,
        "id_point": idPoint,
        "description_point": descriptionPoint,
        "description_type_point": descriptionTypePoint,
        "details_point": detailsPoint?.toJson(),
        "id_object": idObject,
        "description_type_object": descriptionTypeObject,
        "details_object": detailsObject?.toJson(),
        "intervention_color": interventionColor,
        "intervention_icon": interventionIcon == null
            ? null
            : interventionIconValues.reverse[interventionIcon],
      };
}

class DetailsObject {
  String? marca;
  String? modello;
  String? seriale;
  String? canale;
  String? dataInizioVita;
  String? dataFineVita;
  DateTime? dataFabbricazione;
  String? soccorritore;
  String? circuito;
  String? numeroLampada;
  String? tipologia;
  String? capitolo;

  DetailsObject({
    this.marca,
    this.modello,
    this.seriale,
    this.canale,
    this.dataInizioVita,
    this.dataFineVita,
    this.dataFabbricazione,
    this.soccorritore,
    this.circuito,
    this.numeroLampada,
    this.tipologia,
    this.capitolo,
  });

  factory DetailsObject.fromJson(Map<String, dynamic> json) => DetailsObject(
        marca: json["Marca"]?.toString(),
        modello: json["Modello"]?.toString(),
        seriale: json["Seriale"]?.toString(),
        canale: json["Canale"]?.toString(),
        dataInizioVita: json["Data Inizio Vita"]?.toString(),
        dataFineVita: json["Data Fine Vita"]?.toString(),
        dataFabbricazione: json["Data fabbricazione"] == null
            ? null
            : DateTime.tryParse(json["Data fabbricazione"]),
        soccorritore: json["Soccorritore"]?.toString(),
        circuito: json["Circuito"]?.toString(),
        numeroLampada: json["Numero lampada"]?.toString(),
        tipologia: json["Tipologia"]?.toString(),
        capitolo: json["Capitolo"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "Marca": marca,
        "Modello": modello,
        "Seriale": seriale,
        "Canale": canale,
        "Data Inizio Vita": dataInizioVita,
        "Data Fine Vita": dataFineVita,
        "Data fabbricazione": dataFabbricazione == null
            ? null
            : "${dataFabbricazione!.year.toString().padLeft(4, '0')}-${dataFabbricazione!.month.toString().padLeft(2, '0')}-${dataFabbricazione!.day.toString().padLeft(2, '0')}",
        "Soccorritore": soccorritore,
        "Circuito": circuito,
        "Numero lampada": numeroLampada,
        "Tipologia": tipologia,
        "Capitolo": capitolo,
      };
}

class DetailsPoint {
  String? indirizzo;

  DetailsPoint({this.indirizzo});

  factory DetailsPoint.fromJson(Map<String, dynamic> json) => DetailsPoint(
        indirizzo: json["Indirizzo"]?.toString(),
      );

  Map<String, dynamic> toJson() => {
        "Indirizzo": indirizzo,
      };
}

enum InterventionIcon { BACON, CAMERA, DOWNLOAD, LIST_ALT, UPLOAD }

final interventionIconValues = EnumValues({
  "bacon": InterventionIcon.BACON,
  "camera": InterventionIcon.CAMERA,
  "download": InterventionIcon.DOWNLOAD,
  "list-alt": InterventionIcon.LIST_ALT,
  "upload": InterventionIcon.UPLOAD,
});

class EnumValues<T> {
  Map<String, T> map;
  late Map<T, String> reverseMap;

  EnumValues(this.map);

  Map<T, String> get reverse {
    reverseMap = map.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
