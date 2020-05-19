
import 'dart:ffi';

import 'package:prototipo_sw/model/artista.dart';
import 'package:prototipo_sw/model/usuario.dart';

class Song {
  final int id;
  final String nombre;
  final Artista creador;
  final String pathMp3;
  final String pathImg;
  final Float duracion;
  final int reproducciones;

  Song({this.id,this.nombre, this.creador, this.pathMp3, this.pathImg, this.duracion, this.reproducciones});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      nombre: json['nombre'],
      creador: Artista.fromJson(json['creador']),
      pathMp3: json['pathMp3'],
      pathImg: json['pathImg'],
      duracion: json['duracion'],
      reproducciones: json['reproducciones']
    );
  }
}