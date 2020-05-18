import 'package:flutter/material.dart';
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
            elevation: 0.0,
            brightness: Brightness.light,
          centerTitle: true,
          title: Center(
            child: Image.asset('images/logoDefinitivo3.png', )
          )
        ),
        body: FutureBuilder<List<Playlist>>(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          else _list = snapshot.data;
          return new Scaffold(
            body: new ListView.builder(
              itemCount: _list.length,
              itemBuilder: (context, index) {
                final item = _list[index];
                return Card(
                  child: ListTile(
                    leading:Container(
                      height: 50,
                      width: 50,
                      decoration: _myBoxDecoration(),
                      child: Image.asset('images/appleMusic.png')
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

