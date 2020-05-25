import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_sw/home.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

import 'package:path/path.dart' as Path;

class CrearPlaylist extends StatefulWidget {

  final String user;
  CrearPlaylist(this.user);

  @override
  CrearPlaylistState createState() {
    return CrearPlaylistState();
  }
}

// Define una clase de estado correspondiente. Esta clase contendrá los datos
// relacionados con el formulario.
class CrearPlaylistState extends State<CrearPlaylist> {
  // Crea una clave global que identificará de manera única el widget Form
  // y nos permita validar el formulario
  //
  // Nota: Esto es un `GlobalKey<FormState>`, no un GlobalKey<MyCustomFormState>!
   final _formKey = GlobalKey<FormState>();

   File image;
   String _path_image;
   String _uploadedImgURL;

  var jsonData;
  String _description, _name;

  Future createNew() async{
    String correo = widget.user;
    Map data = {
        'nombre': _name,
        'descripcion' : _description,
        'pathImg' : _uploadedImgURL
    };
    var response = await http.post("https://upbeatproyect.herokuapp.com/playlist/save",  
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data)
    );
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      int playlistId = jsonData['id'];
      // If the server did return a 200 OK response,
      // then parse the JSON
      var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/createPlaylist/$correo/$playlistId",  
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
       }, body: jsonEncode(data)
      );
      print('Response status: ${response2.statusCode}');
      if (response2.statusCode == 200) {
        Navigator.pop(context, () {
          setState(() {});
        });
      }
    }
  }


   Future uploadImg() async {
     String _basenamePath = Path.basename(_path_image);

     StorageReference storageReference = FirebaseStorage.instance
         .ref()
         .child(_basenamePath);
     StorageUploadTask uploadTask = storageReference.putFile(image);
     await uploadTask.onComplete;
     print('Image Uploaded');
     storageReference.getDownloadURL().then((fileURL) {
       print('_______');
       print( "FIREBASE :" + fileURL);
       setState(() {
         _uploadedImgURL = fileURL;
         createNew();
       });
     });


   }

   void _openFileExplorer2() async {
     image = await FilePicker.getFile(
       type: FileType.image,
     );

     print('--------------------------------------');
     print(image.path);


     setState(() {
       _path_image=image.path;
       print(_path_image);
     });
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
                labelText: 'Nombre de la playlist',
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
            Padding(
              padding: const EdgeInsets.only(left: 33.0, top: 50.0, bottom: 20.0),
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    onPressed: () => _openFileExplorer2(),
                    child: Text("Escoger imagen"),
                  ),
                ],
              ),
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
                      uploadImg();
                    }
                    else if (!_formKey.currentState.validate()) {
                      Scaffold.of(context).
                      showSnackBar(
                          SnackBar(content: Text('Incorrect credentials')));
                    }
                  },
                  child: Text('Crear Playlist', style: TextStyle(color: Colors.white)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}