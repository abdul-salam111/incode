class RelabelModel {
  final String version;
  final String idUser;
  final String oldLabel;
  final String newLabel;

  RelabelModel({
    required this.version,
    required this.idUser,
    required this.oldLabel,
    required this.newLabel,
  });

  /// Convert Dart object to JSON
  Map<String, String> toJson() {
    return {
      'version': version,
      'id_user': idUser,
      'old_label': oldLabel,
      'new_label': newLabel,
    };
  }

  /// Create Dart object from JSON
  factory RelabelModel.fromJson(Map<String, dynamic> json) {
    return RelabelModel(
      version: json['version'].toString(),
      idUser: json['id_user'].toString(),
      oldLabel: json['old_label'].toString(),
      newLabel: json['new_label'].toString(),
    );
  }
}
