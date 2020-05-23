import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:prototipo_sw/AudioControl.dart';
import 'package:prototipo_sw/crear_playlist.dart';
import 'package:prototipo_sw/model/album.dart';
import 'package:prototipo_sw/model/playlist.dart';
import 'package:prototipo_sw/model/song.dart';
import 'crear_album.dart';
import 'searchScreen.dart';

import 'sizeConfig.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:audiofileplayer/audiofileplayer.dart';

class HomeScreen extends StatelessWidget{
  final String user;
  final AudioControl audio;
  HomeScreen(this.user,  this.audio);

  @override
  Widget build(BuildContext context) {
    return Songs(user, audio);
  }
}

class Songs extends StatefulWidget{

  final String user;
  final AudioControl audio;
  Songs(this.user,  this.audio);

  @override
  State<StatefulWidget> createState() {
    return SongsState(audio);
  }
}

class SongsState extends State<Songs>{
  AudioPlayer audioPlayer;
  AudioCache audioCache;
  final AudioControl audio;
  SongsState( this.audio);
  final _songsName = ['TT', 'Fancy', 'cancion 3', 'cancion 4','TT', 'Fancy', 'cancion 3', 'cancion 4','TT', 'Fancy', 'cancion 3', 'cancion 4'];
  final _singers = ['Twice', 'Twice', 'grupo 3', 'grupo 4','Twice', 'Twice', 'grupo 3', 'grupo 4','Twice', 'Twice', 'grupo 3', 'grupo 4'];
  final _songs = ['twice-tt-mv.mp3','twice-fancy-mv.mp3','','','twice-tt-mv.mp3','twice-fancy-mv.mp3','','','twice-tt-mv.mp3','twice-fancy-mv.mp3','',''];
  final _saved = Set();

  List<Playlist> _playlists;
  List<Album> _albums;
  List<Song> _songlist;
  bool listFixPlaylist = true;

  bool reproduciendo = false;
  var currentSong = 0;

  double volume = 0.5;
  double volumeP = 0.0;
  double currentVolume;

  Duration duration = Duration();
  Duration position = Duration();

  var _currentScreenHome = 0;
  var _currentScreenHomeBool = [true,false,false,false];
  final _ScreensHome = [ 'Songs', 'Playlists', 'Albums', 'Podcasts'];

  var jsonData;

  var _nombre;
  var _nombre2;
  var cancion;
  Future _future;
  Future _futurePl;
  Future _futureP2;
  Future _futurels;
  Future _futurels2;
  ByteData _audioByteData;
  ByteData data;

  Playlist playlist;
  Album album;
  bool viewPlaylist;
  bool viewAlbum;
  String nomPlaylist = "";
  String nomAlbum = "";






  Future<String> getSongs() async{
    print('getSongs');
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cancion/allSongs');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      setState(() {
        print(response.body);
        jsonData = json.decode(response.body);
        print(jsonData[0]);
        _nombre = jsonData[0];
        print(_nombre);
        _nombre2 = _nombre['nombre'];
        cancion = _nombre['path'];

        print(_nombre2);

      });

    }
    return ('Success');
  }

  void _loadAudioByteData() async {
    print('loadAudio');
    //print(cancion);
    _audioByteData = await rootBundle.load(cancion);
    //io.File file = io.File('assets/twice-fancy-mv.mp3');
    //var byte = await file.readAsBytes();
    Uint8List bytes = utf8.encode(cancion);
    print(bytes);
    data = bytes.buffer.asByteData();
    print(data);
    setState(() {});
  }

  AudioBar audio2;


  @override
  void initState(){
    super.initState();
    _futurePl = getUserPlaylists(widget.user);
    _futureP2 = getUserAlbums(widget.user);

    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    playlist = null;
    album = null;
    viewPlaylist = false;
    viewAlbum = false;
    var auxAudio = AuxAudioBar();
    auxAudio.printVol();
    audio2 = AudioBar(audio, auxAudio);
  }

  @override
  Widget build(BuildContext context){
    //_loadAudioByteData();

    SizeConfig().init(context);


    if (_currentScreenHomeBool[3]){
       if (viewPlaylist) setState(() {
        viewPlaylist = false;
      });
       if (viewAlbum) setState(() {
         viewAlbum = false;
       });
      return Scaffold(
        body: _buildPodcasts(),
      );
    }else if (_currentScreenHomeBool[2]){
      if (viewPlaylist) setState(() {
        viewPlaylist = false;
      });
      return Scaffold(
        body: _buildAlbums(),
      );
    }else if (_currentScreenHomeBool[1]){
      if (viewAlbum) setState(() {
        viewAlbum = false;
      });
      return Scaffold(
        body: _buildPlayLists(),
    );
    }else{
       if (viewPlaylist) setState(() {
        viewPlaylist = false;
      });
       if (viewAlbum) setState(() {
         viewAlbum = false;
       });
      return Scaffold(
        body: _buildAll(),
      );
    }
  }

  Widget _buildAll(){
    print(SizeConfig.screenWidth);
    double tam_pantalla_alt = SizeConfig.screenHeight;
    double tam_body = tam_pantalla_alt -10-15-34-40-200;

    print(tam_body);



    return Container(
      color: Colors.white,
      child: Column (
        children: <Widget>[
          /*FutureBuilder(
            future: _future,
            builder: (context, snapshot){
              return IconButton(
                icon: Icon(Icons.play_circle_outline),
                onPressed: (){
                  print('presionado');
                  //Audio audio = Audio.load('assets/twice-fancy-mv.mp3');
                  //List<int> bytes = utf8.encode(cancion);
                  //ByteData byte = bytes;
                  //ByteData _audioByteData = rootBundle.load(cancion);
                  //Audio audio = Audio.loadFromByteData(data);
                  //audio.play();
                  print(cancion);
                  Audio audio = Audio.loadFromRemoteUrl(cancion);
                  audio.play();
                  print('____');
                  //audio.dispose();
                },
              );
            },
          ),*/
          Container(
            height: 10,
          ),
          _buildFullTopMenu(),
          Container(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Text('   Tus últimas 10',
              style: TextStyle(
                  //color: Colors.cyan,
                  fontSize: 34.0,
                  fontWeight: FontWeight.w600
              ),
              )
            ],
          ),
          Container(
            height: 10,
          ),
          Container(
            height: tam_body,
            child: Stack(
              children: <Widget>[
                Container(
                  height: tam_body-40,
                  child:
                  ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: _songsName.length,
                      itemBuilder: (context, i){
                        return Column(
                          children: <Widget>[
                            _buildRow(_songsName[i], _singers[i], _songs [i], i),
                            Divider(
                                color: Colors.cyan,
                              indent: 20,
                              endIndent: 20,
                            ),
                          ],
                        );
                      }
                  ),
                ),

                //AudioBar(audio),
                audio2,
                //_buildSongBar(),
              ],
            ),
          ),
        ]
      ),
    );
  }

  Widget _buildSongs(){

    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
          ),
          _buildFullTopMenu(),
        ],
      ),
    );
  }

  Widget _buildPlayLists(){
    return FutureBuilder<Object>(
      future: _futurePl,
      builder: (context, snapshot) {
        if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
        else _playlists = snapshot.data;
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                height: 10,
              ),
              _buildFullTopMenu(),
              Container(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Text('     Playlists',
                    style: TextStyle(
                      //color: Colors.cyan,
                        fontSize: 34.0,
                        fontWeight: FontWeight.w600
                    ),
                  ),
                ],
              ),
              Container(height: 20,),
              Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(35.0, 0.0, 8.0, 8.0),
                    child: Container(
                      child: FloatingActionButton(
                        onPressed: () async{
                          Navigator.push(context,
                          MaterialPageRoute(
                            builder: (context) => CrearPlaylist(widget.user))).then((value) {
                            setState(() {
                              _futurePl = getUserPlaylists(widget.user);
                            });
                          });
                        },
                        child: Icon(
                          Icons.add, color: Colors.white
                        )
                      ),
                    ), 
                  ),
                  Expanded(
                    child: SizedBox(
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
            Expanded(
              child:Stack(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                       if (viewPlaylist) Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Row(
                          children: <Widget>[
                            Text(nomPlaylist, style: TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),)
                          ],
                      ),
                       ),
                      if (viewPlaylist) showPlaylist(playlist)
                      else Container(height: 190,),
                      IconButton(
                        icon: Icon(Icons.stop),
                        onPressed: (){audio.parar();}
                      ),

                    ],
                  ),
                  audio2
                ],
              )
            ),
            //_buildSongBar(),
            ]
          ),
        );
      }
    );
  }
    
  Widget _buildAlbums(){

    return FutureBuilder<Object>(
        future: _futureP2,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          else _albums = snapshot.data;
          return Container(
            color: Colors.white,
            child: Column(
                children: <Widget>[
                  Container(
                    height: 10,
                  ),
                  _buildFullTopMenu(),
                  Container(
                    height: 15,
                  ),
                  Row(
                    children: <Widget>[
                      Text('     Albums',
                        style: TextStyle(
                          //color: Colors.cyan,
                            fontSize: 34.0,
                            fontWeight: FontWeight.w600
                        ),
                      ),
                    ],
                  ),
                  Container(height: 20,),
                  Row(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(35.0, 0.0, 8.0, 8.0),
                        child: Container(
                          child: FloatingActionButton(
                              onPressed: () async{
                                Navigator.push(context,
                                    MaterialPageRoute(
                                        builder: (context) => CrearAlbum(widget.user))).then((value) {
                                  setState(() {
                                    _futureP2 = getUserAlbums(widget.user);
                                  });
                                });
                              },
                              child: Icon(
                                  Icons.add, color: Colors.white
                              )
                          ),
                        ),
                      ),
                      Expanded(
                        child: SizedBox(
                          height: 150.0,
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: _albums.length,
                              itemBuilder: (context, i) {
                                return _buildRowAlbum(_albums[i]);
                              }
                          ),
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                      child:Stack(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              if (viewAlbum) Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Text(nomAlbum, style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.w300),)
                                  ],
                                ),
                              ),
                              if (viewAlbum) showAlbum(album)
                              else Container(height: 190,),

                            ],
                          ),
                          //AudioBar(audio)
                          audio2
                        ],
                      )
                  ),
                  //
                  //_buildSongBar(),
                ]
            ),
          );
        }
    );
  }
    
      Widget _buildPodcasts(){
        return Container(
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Container(
                height: 10,
              ),
              _buildFullTopMenu(),
              Container(
                height: 15,
              ),
              Row(
                children: <Widget>[
                  Text('     Podcasts',
                    style: TextStyle(
                      //color: Colors.cyan,
                        fontSize: 34.0,
                        fontWeight: FontWeight.w600
    
                    ),
                  )
                ],
              ),
              Container(
                height: 10,
              ),
              Container(
    
                height: 770,
                child: Stack(
                  children: <Widget>[
                    Container(
    
                      height: 730,
                      child:
    
    
    
                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _playlists.length,
                          itemBuilder: (context, i) {
                            print(i);
                            return _buildRowPlaylist(_playlists[i]);
                          }
    
                      ),
    
                    ),



                    audio2,
                  ],
                ),
              ),
            ],
          ),
        );
      }
    
    Widget _buildFullTopMenu(){
    
    
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
    
            SizedBox(
              width: 74,
              child: _buildTopMenu(0),
            ),
    
            SizedBox(
              width: 88,
              child: _buildTopMenu(1),
            ),
    
            Container(
              width: 83,
              child: _buildTopMenu(2),
            ),
    
            Container(
              width: 94,
              child: _buildTopMenu(3),
            ),
    
    
    
    
          ],
        );
    }
    
     Widget _buildTopMenu(var screen){
        return ButtonTheme(
          minWidth: 40,
            child: FlatButton(
    
              color: Colors.white,
              disabledColor: Colors.white,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onPressed: (){
                setState(() {
                  if (screen == _currentScreenHome){
    
                  } else{
                    _currentScreenHome = screen;
                    for(int i = 0; i<4; i++){
                      _currentScreenHomeBool[i]=false;
                    }
                    _currentScreenHomeBool[screen]=true;
                  }
                });
    
              },
              child: Text(
                _ScreensHome[screen],
                style: TextStyle(
                  color: _currentScreenHomeBool[screen] ? Colors.cyan : Colors.black,
                ),
              ),
            )
        )
          ;
    }
    
    
      Widget _buildRow(var songName, var group, var song, var index){
        final savedSongs = _saved.contains(songName);
        return ListTile(
          title: Text(songName),
          subtitle: Text(group),
          leading: Container(
            width: 85,
            child: Row(
    
            children: <Widget>[
    
                Container(
                    height: 50,
                    width: 50,
                    decoration: _myBoxDecoration(),
                    child: Image.asset('images/appleMusic.png')),
                SizedBox(width: 10,),
                Icon(Icons.play_arrow),
             ],
              ),
          ),
          onTap: (){
            audioCache.play(song);
            currentSong = index;
            setState(() {
              reproduciendo = true;
            });
          },
          trailing: IconButton(
            icon : Icon(savedSongs ? Icons.favorite : Icons.favorite_border),
            color : savedSongs ? Colors.cyan : null,
            onPressed: (){
              setState((){
                if(savedSongs){
                  _saved.remove(songName);
                }else{
                  _saved.add(songName);
                }
              });
            },
          ),
    
        ) ;
      }
    
      //final<List> FavSongsList{
    
     // }
    
      BoxDecoration _myBoxDecoration(){
        return BoxDecoration(
          border: Border.all(
              color: Colors.cyan,
              width: 1.5,),
          borderRadius: BorderRadius.all(Radius.circular(5))
        );
      }
    
    Widget _buildRowPlaylist(Playlist _playlist){
      return new GestureDetector(
        onTap: () {
          setState(() {
            viewPlaylist = true;
            playlist = _playlist;
            _futurels = getPlaylistSongs(playlist);
            nomPlaylist = _playlist.nombre;
            print(playlist.id);
          });
        },
        child: Container(
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
    
    
          ),]
    
    
    
      );
    }
    
    
    
    
    
    
    
      Widget _buildRowAlbum(Album _album){

        return new GestureDetector(
          onTap: () {
            setState(() {
              viewAlbum = true;
              album = _album;
              _futurels2 = getAlbumSongs(album);
              nomAlbum = _album.nombre;
              print(album.id);
            });
          },
          child: Container(
            child: Row(
              children: <Widget>[
                Container(width: 30,),
                Column(
                  children: <Widget>[
                    Container(
                      width: 120,
                      height: 120,
                      decoration: _albumDecoration(),
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
    
      BoxDecoration _albumDecoration(){
        return BoxDecoration(
            color: Colors.white,
            border: Border(
              left: BorderSide(
                width: 2.0,
                color: Colors.cyan,
              ),
    
              right: BorderSide(
                width: 8,
                color: Colors.cyan,
              ),
              top: BorderSide(
                width: 8,
                color: Colors.cyan,
              ),
              bottom: BorderSide(
                width: 2.0,
                color: Colors.cyan,
    
              ),
    
            ),
        );
      }
    
    
      Widget _buildSongBar(){


    return Positioned.fill(

      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: (){
            Navigator.of(context).pushNamed('song', arguments: reproduciendo);
          },
          child: Container(

            height: 30,
            child: Row (
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(reproduciendo ? Icons.pause : Icons.play_arrow),
                  onPressed: (){
                    if (reproduciendo){
                      audioPlayer.stop();
                    }else {
                      audioCache.play(_songs[currentSong]);
                    }

                    setState(() {
                      reproduciendo = !reproduciendo;
                    });

                  },
                ),
                Expanded(
                  child: Container(
                    child: Text(_songsName[currentSong],
                      overflow: TextOverflow.clip,),
                  ),
                ),
                IconButton(
                  icon : Icon((volume > 0.0) ? Icons.volume_up : Icons.volume_mute),
                  onPressed: (){
                    setState((){
                      if(volume > 0.0){
                        volumeP = volume;
                        volume = 0.0;
                      }else{
                        volume = volumeP;
                      }
                    });
                  },
                ),
                Slider(
                  value: volume,
                  max: 1.0,
                  onChanged: (double vol){

                    setState(() {
                      volume = vol;
                      audioPlayer.setVolume(volume);
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
  Future<List<Playlist>> getUserPlaylists(String correo) async{
    List<Playlist> _list;
    print('getSongs');
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

  Future<List<Album>> getUserAlbums(String correo) async{
    List<Album> _list;
    print('getAlbums');
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
        _list = (jsonData as List).map((p) => Album.fromJson(p)).toList();
      });
    }
    return _list;
  }

   Future<List<Song>> getPlaylistSongs(Playlist playlist) async{
    List<Song> _list;
    int playlistId = playlist.id;
    print('getSongsPlaylist');
    var uri = Uri.https('upbeatproyect.herokuapp.com','/playlist/songList/$playlistId');
    final response2 = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('SongsPlaylist Response status: ${response2.statusCode}');
    if (response2.statusCode == 200) {
      //if(!mounted)
      setState(() {
        jsonData = json.decode(response2.body);
        print(jsonData);
        _list = (jsonData as List).map((p) => Song.fromJson(p)).toList();
      });
      print (_list);
      print('canciones de playlist ok');
    }
    return _list;
  }

  Future<List<Song>> getAlbumSongs(Album album) async{
    List<Song> _list;
    int albumId = album.id;
    print('getSongsPlaylist');
    var uri = Uri.https('upbeatproyect.herokuapp.com','/album/songList/$albumId');
    final response2 = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('SongsAlbum Response status: ${response2.statusCode}');
    if (response2.statusCode == 200) {
      //if(!mounted)
      setState(() {
        jsonData = json.decode(response2.body);
        print(jsonData);
        _list = (jsonData as List).map((p) => Song.fromJson(p)).toList();
      });
      print (_list);
      print('canciones de playlist ok');
    }
    return _list;
  }



  Widget showPlaylist(Playlist playlist) {
 
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 179,
        child: FutureBuilder<List<Song>>(
          future: _futurels,
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            else _songlist = snapshot.data;
            return new Scaffold(
              body: new ListView.builder(
                itemCount: _songlist.length,
                itemBuilder: (context, index) {
                 var item = _songlist[index];
                  return Card(
                    child: ListTile(
                      leading:Container(
                        height: 50,
                        width: 50,
                        decoration: _myBoxDecoration(),
                        child: Image.network(item.pathImg),
                      ),
                      title: Text(item.nombre),
                      onTap: () { //

                          audio.reproducir(item.pathMp3, item.nombre, item.pathImg, item.id);
                        // <-- onTap
                      }
                    )
                  );
                }
              ),
            );
          }
        ),
      ),
    );
  }

  Widget showAlbum(Album album) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 179,
        child: FutureBuilder<List<Song>>(
            future: _futurels2,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              else _songlist = snapshot.data;
              return new Scaffold(
                body: new ListView.builder(
                    itemCount: _songlist.length,
                    itemBuilder: (context, index) {
                      var item = _songlist[index];
                      return Card(
                          child: ListTile(
                              leading:Container(
                                height: 50,
                                width: 50,
                                decoration: _myBoxDecoration(),
                                child: Image.network(item.pathImg),
                              ),
                              title: Text(item.nombre),
                              onTap: () { //

                                audio.reproducir(item.pathMp3, item.nombre, item.pathImg, item.id);
                                // <-- onTap
                              }
                          )
                      );
                    }
                ),
              );
            }
        ),
      ),
    );
  }
}