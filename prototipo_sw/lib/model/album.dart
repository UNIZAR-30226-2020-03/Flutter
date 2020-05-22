class Album {
  final int id;
  final String nombre;
  final String descripcion;
  final int numCanciones;
  final String pathImg;

  Album({this.id,this.nombre, this.descripcion, this.numCanciones, this.pathImg});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
        id: json['id'],
        nombre: json['nombre'],
        descripcion: json['descripcion'],
        numCanciones: json['numCanciones'],
        pathImg: json['pathImg']
    );
  }
}