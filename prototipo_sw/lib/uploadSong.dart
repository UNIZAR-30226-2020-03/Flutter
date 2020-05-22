import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'package:prototipo_sw/model/album.dart';
import 'dart:io' as io;
import 'package:path/path.dart' as Path;

class UploadSong extends StatefulWidget {
  final String correo;
  const UploadSong(this.correo);
  @override
  _UploadSongState createState() => new _UploadSongState();
}

class _UploadSongState extends State<UploadSong> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName;
  String _path;
  String _path_image;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = new TextEditingController();
  String _correo;
  Album dropdownValue;
  Future _future;
  var jsonData;


  List<Album> _listAlbums;

  String _name;
  var args;
  var audio;
  var image;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
    print("EL email es: " + widget.correo);
    _correo = widget.correo;
    _future = getAlbumList(_correo);
  }


  Future<List<Album>> getAlbumList(String correo) async{
    List<Album> _albums;
    print('getSongs');
    var uri = Uri.https('upbeatproyect.herokuapp.com','/artista/myAlbums/$correo');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Album Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
        jsonData = json.decode(response.body);
        _albums = (jsonData as List).map((p) => Album.fromJson(p)).toList();
        _albums.insert(0, Album(nombre: "Album"));
        dropdownValue = _albums[0];
      });
    }
    print(_albums);
    return _albums;
  }

  cancion(Map data) async{
    var jsonData;
    var response = await http.post("https://upbeatproyect.herokuapp.com/cancion/save",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data)
    );
    print('Response status subir cancion: ${response.statusCode}');
    if(response.statusCode == 200){
      jsonData = json.decode(response.body);
      int songId = jsonData['id'];
      // If the server did return a 200 OK response,
      // then parse the JSON

      var response2 = await http.put("https://upbeatproyect.herokuapp.com/artista/createSong/$_correo/$songId",
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
      );
      print('Response2 status vinculo a artista: ${response2.statusCode}');

      if(response2.statusCode == 200){
        if (dropdownValue.id != null){
          var idAlbum = dropdownValue.id;
          var response3 = await http.put("https://upbeatproyect.herokuapp.com/album/addSong/$idAlbum/$songId",
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          );
          print('Response 3 status canción añadida Album: ${response3.statusCode}');
          if (response3.statusCode == 200) {
            jsonData = json.decode(response.body);
            print(jsonData);
          }
        }
        Navigator.pop(context, () {
          setState(() {});
        });
      }
    }
  }

  subirCancion() async{
    print('map');
    print(_uploadedFileURL);

    Map data = {
      'nombre': _name,
      'duracion': '0',
      'pathMp3': _uploadedFileURL,
      'pathImg': _uploadedImgURL,
    };
    print(_uploadedFileURL);
    print(data);
    cancion(data);
  }

  String _uploadedFileURL;
  Future uploadFile() async {
    String _basenamePath = Path.basename(_path);

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(_basenamePath);
    StorageUploadTask uploadTask = storageReference.putFile(audio);
    await uploadTask.onComplete;
    print('File Uploaded');
    bool finish = false;
    storageReference.getDownloadURL().then((fileURL) {
      print('_______');
      print(fileURL);
      setState(() {
        _uploadedFileURL = fileURL;
        finish = true;
        subirCancion();
      });
    });


  }

  void _openFileExplorer() async {
    audio = await FilePicker.getFile(
        type: _pickingType,
    );

    print('--------------------------------------');
    print(audio.path);


    setState(() {
      _path=audio.path;
      print(_path);
    });
  }


  String _uploadedImgURL;
  Future uploadImg() async {
    String _basenamePath = Path.basename(_path_image);

    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(_basenamePath);
    StorageUploadTask uploadTask = storageReference.putFile(image);
    await uploadTask.onComplete;
    print('Image Uploaded');
    bool finish = false;
    storageReference.getDownloadURL().then((fileURL) {
      print('_______');
      print(fileURL);
      setState(() {
        _uploadedImgURL = fileURL;
        finish = true;
        uploadFile();
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


    _pickingType = FileType.audio;

    return new MaterialApp(

      home: new Scaffold(
        key: _scaffoldKey,
          appBar: AppBar(
              elevation: 0.0,
              brightness: Brightness.light,
              centerTitle: true,
              backgroundColor: Colors.cyan,
              title: Center(
                  child: Container(
                      width: 150,
                      height: 150,
                      child: Image.asset('images/logoDefinitivo3.png'))
              )
          ),
        body: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(width: 10,),
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 30,),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),

                  Form(
                    key: _formKey,
                    child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  '   Sube una canción',
                                  style: TextStyle(
                                    //color: Colors.cyan,
                                      fontSize: 34.0,
                                      fontWeight: FontWeight.w600
                                  ),
                                ),


                                TextFormField(
                                  decoration: const InputDecoration(
                                    icon: Icon(Icons.music_video, color: Colors.cyan),

                                    labelText: 'Nombre',
                                    //font:
                                  ),
                                  onChanged: (val) => _name = val,
                                  validator: (String value) {
                                    print(_name);
                                    if (value.isEmpty) {
                                      return 'Por favor introduce un nombre correcto';
                                    }
                                    else return null;
                                  },
                                ),
                                FutureBuilder<List<Album>>(
                                  future: _future,
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                                    else _listAlbums = snapshot.data;
                                    return Padding(
                                      padding: const EdgeInsets.fromLTRB(5,18,8,8),
                                      child: DropdownButton<Album>(
                                        isExpanded: true,
                                        value: dropdownValue,
                                        icon: Icon(Icons.arrow_downward, color: Colors.cyan,),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(color: Colors.black),
                                        onChanged: (Album newValue) {
                                          setState(() {
                                            dropdownValue = newValue;
                                          });
                                        },
                                        items: _listAlbums
                                            .map<DropdownMenuItem<Album>>((Album value) {
                                              if(value.pathImg != null){
                                                print("URL IMAGEN:"  + value.pathImg);
                                              }
                                          return DropdownMenuItem<Album>(

                                            value: value,
                                            child: Row(
                                              children: <Widget>[
                                                Container(
                                                    height: 32,
                                                    width: 50,
                                                    decoration: _myBoxDecoration(),
                                                    child: FittedBox(
                                                        fit: BoxFit.fill,
                                                        child: (value.pathImg != null) ? Image.network(value.pathImg)
                                                       : Image.asset('images/appleMusic.png')
                                                    )
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Text(value.nombre),
                                                )
                                              ],
                                            ),
                                          );
                                        }).toList(),
                                      ),
                                    );
                                  }
                                ),
                                 Padding(
                                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                                  child: Column(
                                    children: <Widget>[
                                       RaisedButton(
                                        onPressed: () => _openFileExplorer(),
                                        child: Text("Escoger canción"),
                                      ),
                                    ],
                                  ),
                                ),
                                 Builder(
                                  builder: (BuildContext context) => _loadingPath
                                      ? Padding(
                                        padding: const EdgeInsets.only(bottom: 10.0),
                                        child: const CircularProgressIndicator())
                                      : _path != null || _paths != null
                                      ? new Container(
                                        padding: const EdgeInsets.only(bottom: 30.0),
                                        height: 200,
                                        child:  Container(
                                              height: 30,
                                              child: new ListTile(
                                                title: new Text(
                                                  _path,
                                                ),
                                                //subtitle: new Text(path),
                                              ),
                                            )

                                  )
                                      : new Container(),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 50.0, bottom: 20.0),
                                  child: Column(
                                    children: <Widget>[
                                      RaisedButton(
                                        onPressed: () => _openFileExplorer2(),
                                        child: Text("Escoger imagen"),
                                      ),
                                    ],
                                  ),
                                ),
                            Center(
                              child: RaisedButton(
                                onPressed: () {
                                  // devolverá true si el formulario es válido, o falso si
                                  // el formulario no es válido.
                                  if (_formKey.currentState.validate()) {
                                    print('validado');
                                    // Si el formulario es válido, queremos mostrar un Snackbar

                                    //print(widget.audio.path);
                                    uploadImg();

                                    //Timer(Duration(seconds: 1));


                                  }
                                  else if (!_formKey.currentState.validate()) {
                                    print('no validado');
                                  }
                                },

                                child: Text('Subir'),
                                  )
                                )
                              ],
                            ),
                          ),
                        )),

                  ),
                ],
              ),
            ),
      ),
    );
  }
}

BoxDecoration _myBoxDecoration(){
  return BoxDecoration(
      border: Border.all(
        color: Colors.cyan,
        width: 1.5,),
      borderRadius: BorderRadius.all(Radius.circular(5))
  );
}
class SendAudio extends StatefulWidget {
  @override
  _SendAudioState createState() => _SendAudioState();
}

class _SendAudioState extends State<SendAudio> {

  String _uploadedFileURL;

  Future submit(){

  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
