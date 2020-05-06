import 'dart:async';

import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'package:path/path.dart' as Path;

class uploadSong extends StatefulWidget {
  @override
  _uploadSongState createState() => new _uploadSongState();
}

class _uploadSongState extends State<uploadSong> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _fileName;
  String _path;
  Map<String, String> _paths;
  String _extension;
  bool _loadingPath = false;
  FileType _pickingType = FileType.any;
  TextEditingController _controller = new TextEditingController();


  String _name;
  var args;
  var audio;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }


  cancion(Map data) async{
    var jsonData = null;
    var response = await http.post("https://upbeatproyect.herokuapp.com/cancion/save",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data)
    );
    print('Response status: ${response.statusCode}');
    if(response.statusCode == 200){
      print("He entrado al decode");
      jsonData = json.decode(response.body);
      setState(() {
        Navigator.pop(context);
      });
    }
  }

  subirCancion() async{
    print('map');
    print(_uploadedFileURL);

    Map data = {
      'nombre': _name,

      'autor': args['correo'],

      'path': _uploadedFileURL,
      'song': ''
    };
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

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;

    print(args['correo']);

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
                        Center(
                          child: RaisedButton(
                            onPressed: () {
                              // devolverá true si el formulario es válido, o falso si
                              // el formulario no es válido.
                              if (_formKey.currentState.validate()) {
                                print('validado');
                                // Si el formulario es válido, queremos mostrar un Snackbar

                                //print(widget.audio.path);
                                uploadFile();

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
