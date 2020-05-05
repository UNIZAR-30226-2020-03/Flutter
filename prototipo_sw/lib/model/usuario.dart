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

  Usuario({this.userId, this.id, this.email, this.username, this.apellidos,this.contrasenya, this.nombre, this.pais});

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      email: json['correo'],
      username: json['username'],
      apellidos: json['apellidos'],
      contrasenya: json['contrasenya'],
      nombre: json['nombre'],
      pais: json['pais']
    );
  }
}