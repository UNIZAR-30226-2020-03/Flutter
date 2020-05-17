import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prototipo_sw/model/usuario.dart';

class FavScreen extends StatefulWidget{

  final String email;
  const FavScreen(this.email);
  @override
  _FavScreenState createState() => _FavScreenState();
}

class _FavScreenState extends State<FavScreen> {
  var jsonData;
  List<Usuario> followingList;

  Future<List<Usuario>> getFollowingList(String _email) async{
    List<Usuario> _list;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/followingList/$_email');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print(response.statusCode);
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
    // then parse the JSON
      print('All following done');
       jsonData = json.decode(response.body);
       _list = (jsonData as List).map((p) => Usuario.fromJson(p)).toList();
     
    } 
    return _list;
  }

  Future _future;
 
  @override
  void initState() { 
    super.initState();
    _future = getFollowingList(widget.email);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Object>(
      future: _future,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        else followingList = snapshot.data;  
        return Scaffold(
          body: Column(
            children: <Widget>[
              Container(
                height: 10
              ),
              Row(
                children: <Widget>[
                  Text('     USUARIOS SEGUIDOS',
                    style: TextStyle(
                      fontSize: 26.0,
                      fontWeight: FontWeight.w600
                    ),
                  )
                ],
              ),
              Container(
                height: 20,
              ),
              Container(
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: 482,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: followingList.length,
                        itemBuilder: (context, i) {
                          return _buildRowList(followingList[i], i);
                        }
                      ),
                    )
                  ]
                ),
              ),
            ],
          ),
        );
      }
    );
  } 

  Widget _buildRowList(Usuario user, var index){

    return Container(
      child: Row(
        children: <Widget>[
          Container(width: 30,),
          Column(
            children: <Widget>[
              Container(
                width: 55,
                height: 55,
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
              Container(
                height: 10,
              ),
              Text(user.username),
            ],
          ),
        ],
      ),
    );
  }
}