import 'dart:convert';

class Usuario {
  final int userId;
  final int id;
  final String email;
  final String username;
  final String apellidos;
  final String nombre;
  final String pais;
  final String contrasenya;
  final String pathImg;

  Usuario({this.userId, this.id, this.email, this.username, this.apellidos,this.contrasenya, this.nombre, this.pais, this.pathImg});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      email: json['correo'],
      username: json['username'],
      apellidos: json['apellidos'],
      contrasenya: json['contrasenya'],
      nombre: json['nombre'],
      pais: json['pais'],
      pathImg: json['pathImg']
    );
  }
}