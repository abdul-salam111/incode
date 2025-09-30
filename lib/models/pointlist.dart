class PointsList {
  int? idPoint;
  String? descriptionPoint;
  String? descriptionTypePoint;
  int? idTypePoint;
  int? idPosition;
  Map<String, dynamic>? detailsPoint;

  PointsList({
    this.idPoint,
    this.descriptionPoint,
    this.descriptionTypePoint,
    this.idTypePoint,
    this.idPosition,
    this.detailsPoint,
  });

  factory PointsList.fromJson(Map<String, dynamic> json) => PointsList(
        idPoint: json["id_point"],
        descriptionPoint: json["description_point"],
        descriptionTypePoint: json["description_type_point"],
        idTypePoint: json["id_type_point"],
        idPosition: json["id_position"],
        detailsPoint: json["details_point"] ?? {},
      );
}