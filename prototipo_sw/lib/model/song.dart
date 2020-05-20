
import 'dart:ffi';

class Song {
  final int id;
  final String nombre;
  //final String autor;
  final String pathMp3;
  final String pathImg;
  final double duracion;
  final String fecha;
  final int reproducciones;

  Song({this.id,this.nombre,  this.pathMp3, this.pathImg, this.duracion, this.fecha, this.reproducciones});

  factory Song.fromJson(Map<String, dynamic> json) {
    print('______');
    print(json);
    print(json['id']);
    print(json['nombre']);
    print(json['pathMp3']);
    print(json['pathImg']);
    print(json['duracion']);
    print(json['fecha']);
    print(json['reproducciones']);
    Song song = Song(
        id: json['id'],
        nombre: json['nombre'],
        pathMp3: json['pathMp3'],
        pathImg: json['pathImg'],
        duracion: json['duracion'],
        fecha: json['fecha'],
        reproducciones: json['reproducciones']
    );
    print('______');
    print(song);
    print('______');
    return song;
  }
}