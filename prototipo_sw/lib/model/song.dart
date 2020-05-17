
class Song {
  final int id;
  final String nombre;
  final String autor;

  Song({this.id,this.nombre, this.autor});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      nombre: json['nombre'],
      autor: json['autor']
    );
  }
}