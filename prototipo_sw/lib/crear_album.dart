import 'package:flutter/material.dart';
import 'package:prototipo_sw/home.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

class CrearAlbum extends StatefulWidget {

  final String user;
  CrearAlbum(this.user);

  @override
  CrearAlbumState createState() {
    return CrearAlbumState();
  }
}

// Define una clase de estado correspondiente. Esta clase contendrá los datos
// relacionados con el formulario.
class CrearAlbumState extends State<CrearAlbum> {
  // Crea una clave global que identificará de manera única el widget Form
  // y nos permita validar el formulario
  //
  // Nota: Esto es un `GlobalKey<FormState>`, no un GlobalKey<MyCustomFormState>!
  final _formKey = GlobalKey<FormState>();

  var jsonData;
  String _description, _name;

  Future createNew() async{
    String correo = widget.user;
    Map data = {
      'nombre': _name,
      'descripcion' : _description
    };
    var response = await http.post("https://upbeatproyect.herokuapp.com/album/save",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data)
    );
    print('Response status album save: ${response.statusCode}');
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      int playlistId = jsonData['id'];
      // If the server did return a 200 OK response,
      // then parse the JSON
      var response2 = await http.put("https://upbeatproyect.herokuapp.com/artista/createAlbum/$correo/$playlistId",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          }, body: jsonEncode(data)
      );
      print('Response status create album artista: ${response2.statusCode}');
      if (response2.statusCode == 200) {
        Navigator.pop(context, () {
          setState(() {});
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    // Cree un widget Form usando el _formKey que creamos anteriormente

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
            child: AppBarImage()
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextFormField(
              decoration:  InputDecoration(
                labelText: 'Nombre del album',
                icon:  Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
              onChanged: (val) => _name = val,
            ),
            TextFormField(
              decoration:  InputDecoration(
                labelText: 'Descripción',
                icon:  Padding(
                  padding: const EdgeInsets.all(8.0),
                ),
              ),
              maxLines: 7,
              onChanged: (val) => _description = val,
            ),
            Container(height: 10,),
            Center(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  borderRadius: new BorderRadius.circular(15.0),
                  gradient: LinearGradient(
                    colors: <Color>[
                      Colors.lightBlue[300],
                      Colors.lightBlue[200],
                      Colors.lightBlueAccent[100],
                    ],
                  ),
                ),
                child: RaisedButton(
                  color: Colors.transparent,
                  shape: RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                      side: BorderSide(color: Colors.black)),
                  onPressed: ()  {
                    // devolverá true si el formulario es válido, o falso si
                    // el formulario no es válido.
                    if (_formKey.currentState.validate()) {
                      createNew();
                    }
                    else if (!_formKey.currentState.validate()) {
                      Scaffold.of(context).
                      showSnackBar(
                          SnackBar(content: Text('Incorrect credentials')));
                    }
                  },
                  child: Text('Crear Album', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}