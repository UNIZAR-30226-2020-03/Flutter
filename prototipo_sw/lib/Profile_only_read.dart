import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prototipo_sw/AudioControl.dart';
import 'package:prototipo_sw/albumScreen.dart';
import 'package:prototipo_sw/model/album.dart';
import 'package:prototipo_sw/model/artista.dart';
import 'package:prototipo_sw/model/playlist.dart';
import 'package:prototipo_sw/model/song.dart';
import 'package:prototipo_sw/searchScreen.dart';

import 'model/usuario.dart';


class ProfileOnlyRScreen extends StatefulWidget {
  final String me;
  final String email;
  final AudioControl audio;
  const ProfileOnlyRScreen(this.me, this.email, this.audio);

  @override
  _ProfileOnlyRScreenState createState() => _ProfileOnlyRScreenState();
}


class _ProfileOnlyRScreenState extends State<ProfileOnlyRScreen> {


  var user;

  bool esArtista = false;

  var jsonData;

  List<Album> _albums;
  List<Album> albumList;
  List<Playlist> _playlist;
  List<Song> songList;

  String descripcion = "";

  Future<Usuario> getUserData(String _email) async{
    Usuario user;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/get/$_email');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print("getUserData: " + response.statusCode.toString());
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
    // then parse the JSON
      setState(() {
        jsonData = json.decode(response.body);
        user = Usuario.fromJson(jsonData);
      });
    }
    return user;
  }


  Future<String> isArtist(String _email) async{
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
        esArtista = true;
        descripcion = jsonData['descripcion'];
        _futureAl = getAlbumList(widget.email);
      });
    }
    return descripcion;
  }

  @override
  void initState() {
    super.initState();
    _artist = isArtist(widget.email);
    _future = getUserData(widget.email);
    _futurePl = getPlaylistList(widget.email);
    _futureSl = getSongList(widget.email);
    _futureAlf = getAlbumFavList(widget.email);
  }

  Future<List<Song>> getSongList(String _email) async{
    List<Song> _list;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/songsFavPlaylist/$_email');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print('FavSong Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      print('All songs fav done');
      jsonData = json.decode(response.body);
      _list = (jsonData as List).map((p) => Song.fromJson(p)).toList();

    }
    return _list;
  }


  Future<List<Playlist>> getPlaylistList(String _email) async{
    List<Playlist> _list;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/listFavPlaylist/$_email');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print('FavPlaylist Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      print('All playlist fav done');
      jsonData = json.decode(response.body);
      _list = (jsonData as List).map((p) => Playlist.fromJson(p)).toList();

    }
    return _list;
  }

  Future<List<Album>> getAlbumFavList(String _email) async{
    List<Album> _list;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/songsFavAlbum/$_email');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print('FavAlbum Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      jsonData = json.decode(response.body);
      _list = (jsonData as List).map((p) => Album.fromJson(p)).toList();

    }
    return _list;
  }

  Future<List<Album>> getAlbumList(String _email) async{
    List<Album> _list;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/artista/myAlbums/$_email');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print('Albums Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      jsonData = json.decode(response.body);
      _list = (jsonData as List).map((p) => Album.fromJson(p)).toList();

    }
    return _list;
  }

  Future _futureAl;
  Future _futureAlf;
  Future _futureSl;
  Future _futurePl;
  Future _future;
  Future _artist;

 @override
  Widget build(BuildContext context) {
   print(esArtista);
    return FutureBuilder(
        future: _future,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          else user = snapshot.data;
          return Scaffold(
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
                                  image: NetworkImage(user.pathImg != null ? user.pathImg : 'https://www.pngitem.com/pimgs/m/78-786501_black-avatar-png-user-icon-png-transparent-png.png'),
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
                    Text(user.username,
                        style: TextStyle(
                            color: Colors.cyan,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Montserrat'
                        ),
                    ),
                    SizedBox(
                        height: 20
                    ),
                    FutureBuilder(
                        future: _artist,
                        builder: (context, snapshot) {if(snapshot.hasData)
                         descripcion = snapshot.data;
                          print(esArtista);
                            return (esArtista)
                                ? Column(
                                  children: <Widget>[
                                    Text(descripcion,
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Montserrat'
                                      ),
                                    ),
                                    SizedBox(height:12 ),
                                    FutureBuilder<List<Album>>(
                                      future: _futureAl,
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                                        else _albums = snapshot.data;
                                        return Container(
                                          child: Column(
                                              children: <Widget>[
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: <Widget>[
                                                      Text('  ÁLBUMS DEL ARTISTA',
                                                        style: TextStyle(
                                                          //color: Colors.cyan,
                                                            fontSize: 26.0,
                                                            fontWeight: FontWeight.w600
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Container(height: 10,),
                                                Row(
                                                  children: <Widget>[
                                                    Expanded(
                                                      child: (_albums.length == 0)
                                                          ? Container(
                                                          height:150.0,
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Text("",
                                                              style:TextStyle(
                                                                  fontSize: 20.0,
                                                                  fontStyle: FontStyle.italic,
                                                                  fontFamily: 'Montserrat'
                                                              ),
                                                            ),
                                                          )
                                                      ) : Container(
                                                        height: 150.0,
                                                        child: ListView(
                                                          padding: new EdgeInsets.symmetric(vertical:8.0),
                                                          children: _albums.map(
                                                            (contact) => new AlbumItem(
                                                              contact, widget.me,widget.audio)).toList()
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ]
                                          ),
                                        );
                                      }
                                    )
                                  ],
                                )
                                : Container();
                        }
                    ),
                    FutureBuilder<List<Playlist>>(
                        future: _futurePl,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                          else _playlist = snapshot.data;
                          return Container(
                            child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: <Widget>[
                                        Text('  SUS PLAYLIST FAVORITAS',
                                          style: TextStyle(
                                            //color: Colors.cyan,
                                              fontSize: 26.0,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(height: 10,),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: (_playlist.length == 0)
                                            ? Container(
                                            height:150.0,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text("",
                                                style:TextStyle(
                                                    fontSize: 20.0,
                                                    fontStyle: FontStyle.italic,
                                                    fontFamily: 'Montserrat'
                                                ),
                                              ),
                                            )
                                        ) : Container(
                                          height: 150.0,
                                          child: ListView(
                                              padding: new EdgeInsets.symmetric(vertical:8.0),
                                              children: _playlist.map(
                                                      (contact) => new PlaylistItem(
                                                      contact, widget.me, widget.audio)).toList()
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ]
                            ),
                          );
                        }
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:12.0),
                      child: Row(
                        children: <Widget>[
                          Text('    SUS CANCIONES FAVORITAS',
                            style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    FutureBuilder<List<Song>>(
                        future: _futureSl,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                          else songList = snapshot.data;
                          return Container(
                            child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 300,
                                    child: ListView(
                                        padding: new EdgeInsets.symmetric(vertical: 8.0),
                                        children: songList.map(
                                                (contact) => new SongItem(
                                                contact, widget.me,widget.audio)).toList()
                                    ),
                                  ),
                                ]
                            ),
                          );
                        }
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top:12.0),
                      child: Row(
                        children: <Widget>[
                          Text('    SUS ÁLBUMES FAVORITOS',
                            style: TextStyle(
                                fontSize: 26.0,
                                fontWeight: FontWeight.w600
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      height: 20,
                    ),
                    FutureBuilder<List<Album>>(
                        future: _futureAlf,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                          else albumList = snapshot.data;
                          return Container(
                            child: Stack(
                                children: <Widget>[
                                  Container(
                                    height: 300,
                                    child: ListView(
                                        padding: new EdgeInsets.symmetric(vertical: 8.0),
                                        children: albumList.map(
                                                (contact) => new AlbumItem(contact, widget.me, widget.audio)).toList()
                                    ),
                                  ),
                                ]
                            ),
                          );
                        }
                    ),

                  ]
              ),
            ),
          );
        }
    );
 }

}
