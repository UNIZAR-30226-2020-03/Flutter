import 'package:flutter/material.dart';
import 'package:prototipo_sw/crear_playlist.dart';
import 'package:prototipo_sw/home.dart';
import 'package:prototipo_sw/model/playlist.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class UserPlaylists extends StatefulWidget {
  final String user;
  final int idSong;
  const UserPlaylists(this.user, this.idSong);

  @override
  _UserPlaylistsState createState() => _UserPlaylistsState();
}

class _UserPlaylistsState extends State<UserPlaylists> {
   Future _future;
   List<Playlist> _list;
   var jsonData;

   @override
   void initState() { 
     super.initState();
     _future = getPlaylistsFromUser();
   }

   BoxDecoration _myBoxDecoration(){
      return BoxDecoration(
        border: Border.all(
            color: Colors.cyan,
            width: 1.5,),
        borderRadius: BorderRadius.all(Radius.circular(5))
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Center(
              child: AppBarImage()
          ),
        ),
        body: FutureBuilder<List<Playlist>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          else _list = snapshot.data;
          return new Scaffold(
            body: (_list.length == 0)
            ? Column(
              children: <Widget>[
                Container(height:30),
                Container(height:150.0,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text("No has creado todavía ninguna playlist",
                        style:TextStyle(
                            fontSize: 20.0,
                            fontStyle: FontStyle.italic,
                            fontFamily: 'Montserrat'
                        ),
                      ),
                    )
                ),
                Container(height:450,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          child: Text("Crea una nueva aquí",
                              style:TextStyle(
                                  fontSize: 20.0,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Montserrat'
                              ),
                            ),
                        ),
                      ),

                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    FloatingActionButton(
                        onPressed: () async{
                          Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (context) => CrearPlaylist(widget.user))).then((value) {
                            setState(() {
                              _future = getPlaylistsFromUser();
                            });
                          });
                        },
                        child: Icon(
                            Icons.add, color: Colors.white
                        )
                    ),
                  ],
                )
              ],
              )
            : new ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                final item = _list[index];
                return Card(
                  child: ListTile(
                    leading:Container(
                      height: 50,
                      width: 50,
                      decoration: _myBoxDecoration(),
                      child: (item.pathImg != null)
                          ? Image.network(item.pathImg)
                          : Image.asset('images/appleMusic.png'),
                    ),
                    title: Text(item.nombre),
                    onTap: () { //  <-- onTap
                      addSongToPlaylist(item.id);
                    }
                  )
                );
              }
            ),
          );
        }
      ),  
    );
  }

  creteAlertDialog(BuildContext context){
    return showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Text("Canción añadida con éxito"),
        actions: <Widget>[
          Icon(
            Icons.check_circle,
            color: Colors.green,
          )
        ],
      );
    });
  }

  Future<List<Playlist>> addSongToPlaylist(int playlistId) async{
    int songId= widget.idSong;
    List<Playlist> _list;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/playlist/addSong/$playlistId/$songId');
    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Added Song Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      creteAlertDialog(context);
    }
    return _list;
  }

  Future<List<Playlist>> getPlaylistsFromUser() async{
    String correo = widget.user;
    List<Playlist> _list;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/myPlaylists/$correo');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Playlist Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
        jsonData = json.decode(response.body);
        _list = (jsonData as List).map((p) => Playlist.fromJson(p)).toList();
      });
    }
    return _list;
  }
}

