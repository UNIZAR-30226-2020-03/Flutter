import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prototipo_sw/Profile_only_read.dart';
import 'package:prototipo_sw/albumScreen.dart';
import 'package:prototipo_sw/model/album.dart';
import 'package:prototipo_sw/model/playlist.dart';
import 'package:prototipo_sw/model/song.dart';
import 'package:prototipo_sw/playlistScreen.dart';
import 'package:prototipo_sw/searchScreen.dart';
import 'AudioControl.dart';
import 'package:prototipo_sw/model/usuario.dart';

class FavScreen extends StatefulWidget{

  final String email;
  final AudioControl audio;
  const FavScreen(this.email, this.audio);
  @override
  _FavScreenState createState() => _FavScreenState(audio);
}

class _FavScreenState extends State<FavScreen> {
  var jsonData;
  List<Usuario> followingList;
  List<Song> songList;
  List<Playlist> _playlists;
  List<Album> _albums;
  final AudioControl audio;
  _FavScreenState(this.audio);

  Future<List<Usuario>> getFollowingList(String _email) async{
    List<Usuario> _list;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/followingList/$_email');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print('UsersFollow Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
    // then parse the JSON
      print('All following done');
       jsonData = json.decode(response.body);
       _list = (jsonData as List).map((p) => Usuario.fromJson(p)).toList();
     
    } 
    return _list;
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

  Future<List<Album>> getAlbumList(String _email) async{
    List<Album> _list;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cliente/songsFavAlbum/$_email');
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
      _list = (jsonData as List).map((p) => Album.fromJson(p)).toList();

    }
    return _list;
  }

  Future _future;
  Future _futurels;
  Future _futurePl;
  Future _futureAl;
 
  @override
  void initState() { 
    super.initState();
    _future = getFollowingList(widget.email);
    _futurels = getSongList(widget.email);
    _futurePl = getPlaylistList(widget.email);
    _futureAl = getAlbumList(widget.email);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
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
            FutureBuilder<List<Usuario>>(
              future: _future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                else followingList = snapshot.data;    return Container(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: followingList.length,
                          itemBuilder: (context, i) {
                            return _buildRowFollowList(followingList[i]);
                          }
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
                  Text('     CANCIONES FAVORITAS',
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
                future: _futurels,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  else songList = snapshot.data;
                  return Container(
                    child: (songList.length == 0)
                        ? Container(
                        height:150.0,
                        child: Wrap(
                          children: <Widget>[
                            Text("No tienes canciones favoritas...",
                              style:TextStyle(
                                  fontSize: 20.0,
                                  fontStyle: FontStyle.italic,
                                  fontFamily: 'Montserrat'
                              ),
                            ),
                            Text("Explora y añádelas a tu colección",
                              style:TextStyle(
                                  fontSize: 20.0,
                                  fontStyle: FontStyle.normal,
                                  fontFamily: 'Montserrat'
                              ),
                            ),
                          ],
                        )
                    ) : Stack(
                        children: <Widget>[
                          Container(
                            height: 300,
                            child: ListView(
                                padding: new EdgeInsets.symmetric(vertical: 8.0),
                                children: songList.map(
                                        (contact) => new SongItem(
                                        contact, widget.email)).toList()
                            ),
                          ),
                        ]
                    ),
                  );
                }
            ),
            Container(
              height: 20,
            ),
            FutureBuilder<Object>(
              future: _futurePl,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                else _playlists = snapshot.data;
                return Container(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Text('     PLAYLISTS FAVORITAS',
                            style: TextStyle(
                              //color: Colors.cyan,
                                fontSize: 26.0,
                                fontWeight: FontWeight.w600
                            ),
                          ),
                        ],
                      ),
                      Container(height: 20,),
                      Row(
                        children: <Widget>[
                          Expanded(child: (_playlists.length == 0)
                              ? Container(
                              height:150.0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Wrap(
                                  children: <Widget>[
                                    Text("¿Todavía no tienes playlists favoritas?",
                                      style:TextStyle(
                                          fontSize: 20.0,
                                          fontStyle: FontStyle.italic,
                                          fontFamily: 'Montserrat'
                                      ),
                                    ),
                                    Text("Explora y añádelos a tu colección",
                                      style:TextStyle(
                                        fontSize: 20.0,
                                        fontStyle: FontStyle.italic,
                                        fontFamily: 'Montserrat'
                                      ),
                                    ),
                                  ],
                                ),
                              )
                          ) : Container(
                              height: 150.0,
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _playlists.length,
                                  itemBuilder: (context, i) {
                                    return _buildRowPlaylist(_playlists[i]);
                                  }
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                ),
              );}
            ),
            Container(
              height: 20,
            ),
            FutureBuilder<List<Album>>(
                future: _futureAl,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
                  else _albums = snapshot.data;
                  return Container(
                    child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Text('     ÁLBUMS FAVORITOS',
                                style: TextStyle(
                                  //color: Colors.cyan,
                                    fontSize: 26.0,
                                    fontWeight: FontWeight.w600
                                ),
                              ),
                            ],
                          ),
                          Container(height: 20,),
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: (_albums.length == 0)
                                ? Container(
                                    height:150.0,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Wrap(
                                        children: <Widget>[
                                          Text("¿Todavía no tienes álbumes favoritos?",
                                            style:TextStyle(
                                              fontSize: 20.0,
                                              fontStyle: FontStyle.italic,
                                              fontFamily: 'Montserrat'
                                            ),
                                          ),
                                          Text("Explora y añádelos a tu colección",
                                            style:TextStyle(
                                              fontSize: 20.0,
                                              fontStyle: FontStyle.italic,
                                              fontFamily: 'Montserrat'
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ) : Container(
                                    height: 150.0,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: _albums.length,
                                      itemBuilder: (context, i) {
                                        return _buildRowAlbums(_albums[i]);
                                      }
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
        ),
      ),
    );
  }

  Widget _buildRowPlaylist(Playlist _playlist){
    return Container(
      child: GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => PlaylistScreen(_playlist, widget.email))),
        child: Row(
          children: <Widget>[
            Container(width: 30,),
            Column(
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  decoration: _playlistDecoration(),
                  child: (_playlist.pathImg != null)
                      ? Image.network(_playlist.pathImg)
                      : Image.asset('images/appleMusic.png'),
                ),
                Container(height: 10,),
                Text(_playlist.nombre),
              ],
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildRowAlbums(Album _album){
    return Container(
      child: GestureDetector(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => AlbumScreen(_album, widget.email))),
        child: Row(
          children: <Widget>[
            Container(width: 30,),
            Column(
              children: <Widget>[
                Container(
                  width: 120,
                  height: 120,
                  decoration: _playlistDecoration(),
                  child: (_album.pathImg != null)
                      ? Image.network(_album.pathImg)
                      : Image.asset('images/appleMusic.png'),
                ),
                Container(height: 10,),
                Text(_album.nombre),
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _playlistDecoration(){
    return BoxDecoration(
        color: Colors.white,
        border: Border(
          left: BorderSide(
            width: 2.0,
            color: Colors.cyan,
          ),

          right: BorderSide(
            width: 6.5,
            color: Colors.cyan,
          ),
          top: BorderSide(
            width: 6.5,
            color: Colors.cyan,
          ),
          bottom: BorderSide(
            width: 2.0,
            color: Colors.cyan,

          ),

        ),
        boxShadow: [
          BoxShadow(
            color:Colors.cyan,
            offset: Offset(14,0),
          ),
          BoxShadow(
            color:Colors.white,
            offset: Offset(10,0),
          ),
          BoxShadow(
            color:Colors.cyan,
            offset: Offset(7,0),
          ),
          BoxShadow(
            color:Colors.white,
            offset: Offset(3,0),
          ),
        ]
    );
  }

  Widget _buildRowFollowList(Usuario user){

    return Container(
      child: Row(
        children: <Widget>[
          Container(width: 30,),
          Column(
            children: <Widget>[
              Container(
                child: GestureDetector(
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileOnlyRScreen(widget.email,user.email))).then((value) {
                    setState(() {
                      _future = getFollowingList(widget.email);
                      _futurels = getSongList(widget.email);
                      _futurePl = getPlaylistList(widget.email);
                      _futureAl = getAlbumList(widget.email);
                    });
                  })
                ),
                width: 55,
                height: 55,
                decoration: BoxDecoration(
                  color: Colors.red,
                  image: DecorationImage(
                    image: NetworkImage(
                        (user.pathImg != null)
                        ? user.pathImg
                        :'https://www.pngitem.com/pimgs/m/78-786501_black-avatar-png-user-icon-png-transparent-png.png'),
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