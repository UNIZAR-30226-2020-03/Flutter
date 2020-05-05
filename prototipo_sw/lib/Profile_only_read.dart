import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class ProfileOnlyRScreen extends StatefulWidget {
  ProfileOnlyRScreen();

  @override
  _ProfileOnlyRScreenState createState() => _ProfileOnlyRScreenState();
}


class _ProfileOnlyRScreenState extends State<ProfileOnlyRScreen> {


  String _username, _name, _apellidos;

  var jsonData;

  Future<String> getUserData(String _email) async{
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/get/$_email');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
    // then parse the JSON
    if (!mounted) return "";
      setState(() {
        jsonData = json.decode(response.body);
        _username = jsonData['username'];
        _name = jsonData['nombre'];
        _apellidos = jsonData['apellidos'];
      });
    } 
    return ('Success');
  }

  Future _future;
 @override
  Widget build(BuildContext context) {
    final String email = ModalRoute.of(context).settings.arguments;
    _future = getUserData(email);
    return FutureBuilder(
      future: _future,
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
                width: 320.0,
                left: 25.0,
                top: MediaQuery.of(context).size.height / 8,
                child: Column(
                  children: <Widget> [
                    Container(
                      width: 150.0,
                      height: 150.0,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        image: DecorationImage(
                          image: NetworkImage('https://www.pngitem.com/pimgs/m/78-786501_black-avatar-png-user-icon-png-transparent-png.png'),
                          fit: BoxFit.fill
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
                    Text( _username,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'
                      ),
                    ),
                    Text(_name,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'
                      ),
                    ),
                    Text(_apellidos,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'
                      ),
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
    path.lineTo(0.0, size.height/2.25);
    path.lineTo(size.width + 125, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}