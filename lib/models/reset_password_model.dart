class ResetPasswordModel {
  final String version;
  final String idUser;
  final String email;
  final String password;

  ResetPasswordModel({
    required this.version,
    required this.idUser,
    required this.email,
    required this.password,
  });

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      version: json['version'] as String,
      idUser: json['id_user'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  Map<String, String> toJson() {
    return {
      'version': version,
      'id_user': idUser,
      'email': email,
      'password': password,
    };
  }
}
