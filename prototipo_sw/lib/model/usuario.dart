class Usuario {
  final int userId;
  final int id;
  final String email;
  final String username;

  Usuario({this.userId, this.id, this.email, this.username});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      email: json['correo'],
      id: json['cod_cliente'],
      username: json['title'],
    );
  }
}