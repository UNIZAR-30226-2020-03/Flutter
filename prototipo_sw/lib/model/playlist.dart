class Playlist {
  final int id;
  final String nombre;
  final String descripcion;
  final int numCanciones;

  Playlist({this.id,this.nombre, this.descripcion, this.numCanciones});

  factory Playlist.fromJson(Map<String, dynamic> json) {
    return Playlist(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      numCanciones: json['numCanciones']
    );
  }
}