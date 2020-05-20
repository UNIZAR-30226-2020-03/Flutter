import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ProfileScreen extends StatefulWidget {
  final String _password;
  final String _email;

  ProfileScreen(this._email, this._password);

  @override
  _ProfileScreenState createState() => _ProfileScreenState(_email, _password);
}


class _ProfileScreenState extends State<ProfileScreen> {


  final String _password;
  final String _email;
  String _username, _name, _apellidos;
  var _image;
  String _usernameArtist = '';

   _ProfileScreenState( this._email, this._password);

  var jsonData;
  
  Future update() async{
    Map data = {
        'correo': _email,
        'nombre': _name,
        'apellidos': _apellidos,
        'pais': jsonData['pais'],
        'username': _username,
        'contrasenya': _password
    };
    var response = await http.put("https://upbeatproyect.herokuapp.com/usuario/updateUser/$_email",  
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data)
    );
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      if (!this.mounted) {
        setState(() {
          jsonData = json.decode(response.body);
          _username = jsonData['username'];
          _name = jsonData['nombre'];
          _apellidos = jsonData['apellidos'];
        });
      }
    }
  }

  Future<String> getUserData() async{
    print(_password);
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/get/$_password/$_email');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response user data status: ${response.statusCode}');
    if (response.statusCode == 200) {

      // If the server did return a 200 OK response,
    // then parse the JSON
      setState(() {
        jsonData = json.decode(response.body);
        _username = jsonData['username'];
        _name = jsonData['nombre'];
        _apellidos = jsonData['apellidos'];
        _image=jsonData['pathImg'];
        print(jsonData);

      });
    } 
    return ('Success');
  }

  Future<String> isArtist() async{
    var uri = Uri.https('upbeatproyect.herokuapp.com','/artista/get/$_email');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      setState(() {
        jsonData = json.decode(response.body);
        _usernameArtist = jsonData['username'];
        //print(_usernameArtist);
      });
    }
    return ('Success');
  }

  Future _future;
  Future _artist;

  @override
  void initState(){

    _future = getUserData();
    _artist = isArtist();

    super.initState();
  }

 @override
  Widget build(BuildContext context) {

    return FutureBuilder(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        else return Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: <Widget> [

                Container(
                  alignment: Alignment.center,
                  height: 300,
                  decoration: BoxDecoration(
                      color: Colors.cyan[100],
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      )
                  ),
                  child: Container(
                    width: 180,
                    height: 180,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(

                        borderRadius: BorderRadius.all(

                            Radius.circular(75.0)
                        ),
                        boxShadow: [
                          BoxShadow(blurRadius: 13.0, color: Colors.cyan[700])
                        ]
                    ),
                    child: Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                          image: NetworkImage(_image != null ? _image : 'https://www.pngitem.com/pimgs/m/78-786501_black-avatar-png-user-icon-png-transparent-png.png'),
                          fit: BoxFit.fill
                        ),

                        borderRadius: BorderRadius.all(

                          Radius.circular(75.0)
                        ),
                        boxShadow: [
                          BoxShadow(blurRadius: 13.0, color: Colors.cyan)
                        ]
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height:40.0
                ),
                TextField(
                  style: TextStyle(
                    color: Colors.cyan,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Montserrat'
                  ),
                  controller: TextEditingController.fromValue(
                    new TextEditingValue(
                      text: _username,
                      selection:
                      new TextSelection.collapsed(
                        offset: _username.length
                      )
                    )
                  ),
                  onChanged: (val) {
                    setState(() {
                      _username = val;
                      update();
                    });
                  },
                  decoration:
                      InputDecoration(labelText: 'Nombre de Usuario')
                ),
                TextField(
                  style: TextStyle(
                      color: Colors.cyan,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Montserrat'
                  ),
                  controller: TextEditingController.fromValue(
                    new TextEditingValue(
                      text: _name,
                      selection:
                      new TextSelection.collapsed(
                        offset: _name.length
                      )
                    )
                  ),
                  onChanged: (val) {
                    setState(() {
                      _name = val;
                      update();
                    });
                  },
                  decoration: InputDecoration(labelText: 'Nombre')
                ),
                TextField(
                  style: TextStyle(
                      color: Colors.cyan,
                    fontSize: 20.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Montserrat'
                  ),
                  controller: TextEditingController.fromValue(
                    new TextEditingValue(
                      text: _apellidos,
                      selection:
                      new TextSelection.collapsed(
                        offset: _apellidos.length
                      )
                    )
                  ),
                  onChanged: (val) {
                    _apellidos = val;
                    update();
                  },
                  decoration: InputDecoration(labelText: 'Apellidos')
                ),
                SizedBox(
                  height: 20
                ),
                Container(
                  width: 220,
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
                    onPressed: () {
                      Navigator.of(context).pushNamed('change_pass', arguments: jsonData);
                    },
                    textColor: Colors.white,
                    child: const Text('Modificar contraseña', style: TextStyle(fontSize: 15)),
                  ),
                ),
                SizedBox(
                    height: 20
                ),
                 FutureBuilder(
                   future: _artist,
                   builder: (context, snapshot) {


                     if (_usernameArtist != null){

                       return FloatingActionButton(
                           child: Icon(Icons.file_upload),
                           onPressed: () {
                             Navigator.of(context).pushNamed('upload_song',
                                 arguments: jsonData);
                           }
                       );
                     } else {
                       return Text('');
                     }

                   }
                 ),
                SizedBox(
                    height: 20
                ),
              ]
            ),
          ),
        );
      }
    );
  }
}


class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size){
    /*var path = new Path();
    path.lineTo(0.0, size.height/2.25);
    path.lineTo(size.width + 125, 0.0);
    return path;*/
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}