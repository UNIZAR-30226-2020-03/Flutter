import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:prototipo_sw/register.dart';

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
    var response = await http.put("https://upbeatproyect.herokuapp.com/usuario/update/$_email",  
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(data)
    );
    print('Response status: ${response.statusCode}');
  }

  Future<String> getUserData() async{
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/get/$_password/$_email');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      if (this.mounted) {
        setState(() {
          jsonData = json.decode(response.body);
          _username = jsonData['username'];
          _name = jsonData['nombre'];
          _apellidos = jsonData['apellidos'];
        });
      }
    } 
    return ('Success');
  }

 @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUserData(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        else return Scaffold(
          body: Stack(
            children: <Widget>[
              ClipPath(
                child: Container(color: Colors.lightBlue[200].withOpacity(0.8),),
                clipper: getClipper(),
                  ),
                  Positioned(
                width: 350.0,
                left: 25.0,
                top: MediaQuery.of(context).size.height / 7,
                child: Column(
                  children: <Widget> [
                    Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                          image: NetworkImage('https://scontent-mad1-1.xx.fbcdn.net/v/t1.0-9/16196015_10154888128487744_6901111466535510271_n.png?_nc_cat=103&_nc_sid=85a577&_nc_ohc=Lzgz1RIuAd4AX9FoBP7&_nc_ht=scontent-mad1-1.xx&oh=892e609c9eb0df5f1ca268c9aafda4e9&oe=5EA5B597'),
                          fit: BoxFit.contain
                        ),
                        borderRadius: BorderRadius.all(
                          Radius.circular(75.0)
                        ),
                        boxShadow: [
                          BoxShadow(blurRadius: 13.0, color: Colors.black)
                        ]
                      ),
                    ),
                    SizedBox(
                      height:40.0
                    ),
                    TextField(
                      style: TextStyle(
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
                        _username = val;
                        update();
                      },
                      decoration:
                          InputDecoration(labelText: 'Nombre de Usuario')
                    ),
                    SizedBox(
                      height:20.0
                    ),
                    TextField(
                      style: TextStyle(
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
                        _name = val;
                        update();
                      },
                      decoration: InputDecoration(labelText: 'Nombre')
                    ),
                    TextField(
                      style: TextStyle(
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
                  ]
                )
              )
            ],
          ),
        );
      }
    );
  }
}


class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size){
    var path = new Path();
    path.lineTo(0.0, size.height/1.9);
    path.lineTo(size.width + 125, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}