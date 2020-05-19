import 'dart:convert';

class Artista {
  final int cod_cliente; 
  final String nombre; 
  final String apellidos; 
  final String contrasenya; 
  final String correo; 
  final String pathImg;
	final String username; 
  final String pais; 
  final int  cod_artista; 
  final String nombre_artista; 
  final String descripcion;

  Artista({this.cod_cliente, this.correo, this.pathImg, this.nombre_artista, this.cod_artista, 
    this.descripcion, this.username, this.apellidos,this.contrasenya, this.nombre, this.pais});

  factory Artista.fromJson(Map<String, dynamic> json) {
    return Artista(
      cod_cliente: json['cod_cliente'],
      pathImg: json['pathImg'],
      cod_artista: json['cod_artista'],
      nombre_artista: json['nombre_artista'],
      correo: json['correo'],
      username: json['username'],
      apellidos: json['apellidos'],
      contrasenya: json['contrasenya'],
      nombre: json['nombre'],
      pais: json['pais'],
      descripcion: json['descripcion']
    );
  }
}