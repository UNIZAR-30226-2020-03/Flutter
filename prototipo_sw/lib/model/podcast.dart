import 'dart:ffi';

class Podcast {
  final int id;
  final String nombre;

  //final String autor;
  final String pathMp3;
  final String pathImg;
  final double duracion;
  final int temporada;
  final int episodio;
  final String fecha;
  final int reproducciones;
  final String descripcion;

  Podcast(
      {this.id, this.nombre, this.pathMp3, this.pathImg, this.duracion, this.fecha, this.reproducciones, this.temporada, this.episodio, this.descripcion});

  factory Podcast.fromJson(Map<String, dynamic> json) {
    print(json);

  Podcast pod = Podcast(
      id: json['id'],
      nombre: json['nombre'],
      pathMp3: json['pathMp3'],
      pathImg: json['pathImg'],
      duracion: json['duracion'],
      fecha: json['fecha'],
      reproducciones: json['reproducciones'],
      temporada: json['temporada'],
      episodio: json['episodio'],
      descripcion: json['descripcion']
  );
  print('¿¿¿');
  print(pod);
    return pod;
  }
}