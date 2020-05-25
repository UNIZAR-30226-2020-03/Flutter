import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:prototipo_sw/AudioControl.dart';
import 'package:prototipo_sw/crear_playlist.dart';
import 'package:prototipo_sw/model/album.dart';
import 'package:prototipo_sw/model/playlist.dart';
import 'package:prototipo_sw/model/podcast.dart';
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

  var _playlists;
  var _albums;
  List<Song> _popSongs;
  var _popSongs2;
  List<Song> _songlist;
  List<Song> _songlistAlbum;
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
  var jsonData3;

  var _nombre;
  var _nombre2;
  var cancion;
  Future _future;
  Future _futurePl;
  Future _futureP2;
  Future _futureP3;
  Future _futureP4;
  Future _futurels;
  Future _futurels2;
  Future _futurels3;
  ByteData _audioByteData;
  ByteData data;

  var playlist;
  var album;
  bool viewPlaylist;
  bool viewAlbum;
  String nomPlaylist = "";
  String nomAlbum = "";

  Future deletePlaylist(Playlist _playlist) async {
    int _playlistId = _playlist.id;
    var response = await http.delete("https://upbeatproyect.herokuapp.com/playlist/delete/$_playlistId",
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
    );
    print("DELETE PL:" + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        Navigator.pop(context);
      });
    }
  }

  Future deleteAlbum(Album _album) async {
    int _albumId = _album.id;
    var response = await http.delete("https://upbeatproyect.herokuapp.com/album/delete/$_albumId",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print("DELETE AL:" + response.statusCode.toString());
    if (response.statusCode == 200) {
      setState(() {
        Navigator.pop(context);
      });
    }
  }


  reproducirCancion( var idSong) async{
    var usuario = widget.user;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/reproducirCancion/$usuario/$idSong",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status añadir a cola primera: ${response2.statusCode}');

    audio.reproducir(widget.user);

  }

  colaCancion( var idSong) async{
    var usuario = widget.user;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/addCancionCola/$usuario/$idSong",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status añadir a cola primera: ${response2.statusCode}');

  }
  reproducirPlaylist( var idSong) async{
    var usuario = widget.user;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/reproducirPlaylist/$usuario/$idSong",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status añadir a cola primera: ${response2.statusCode}');

    audio.reproducir(widget.user);

  }
  colaPlaylist( var idSong) async{
    var usuario = widget.user;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/addPlaylistCola/$usuario/$idSong",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status añadir a cola primera: ${response2.statusCode}');

    //audio.reproducir(widget.user);

  }
  reproducirAlbum( var idSong) async{
    var usuario = widget.user;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/reproducirAlbum/$usuario/$idSong",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status añadir a cola primera: ${response2.statusCode}');

    audio.reproducir(widget.user);

  }
  colaAlbum( var idSong) async{
    var usuario = widget.user;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/addAlbumCola/$usuario/$idSong",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status añadir a cola album: ${response2.statusCode}');

    //audio.reproducir(widget.user);

  }

  Future<List<Song>> getSongs() async{
    List<Song> _list;
    print('getSongs');
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cancion/allSongsOrderByPopularity');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response status all songs by popularity: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      setState(() {
        jsonData = json.decode(response.body);
        _list = (jsonData as List).map((p) => Song.fromJson(p)).toList();
      });
    }
    return _list;
  }

  Future<List<Podcast>> getPodcasts() async{
    var _list;
    print('getSongs');
    var uri = Uri.https('upbeatproyect.herokuapp.com','/podcast/allPodcastOrderByPopularity');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response status all podcast by popularity: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      setState(() {
        jsonData = json.decode(response.body);
        print(jsonData);
        print('ssssssssssssssssssssssss');
        _list = (jsonData as List).map((p) => Podcast.fromJson(p)).toList();
      });
      print('ssssssssssssssssssssssss');

      print('podcast ok');

    }
    return _list;
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
    _futureP3 = getSongs();
    _futureP4= getPodcasts();
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    playlist = null;
    album = null;
    viewPlaylist = false;
    viewAlbum = false;
    var auxAudio = AuxAudioBar();
    auxAudio.printVol();
    audio.getUser(widget.user);
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
    //print(SizeConfig.screenWidth);
    double tam_pantalla_alt = SizeConfig.screenHeight;
    double tam_body = tam_pantalla_alt -10-15-34-40-200;

    //print(tam_body);
        return Container(
          color: Colors.white,
          child: Column (
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
                  Text('   Canciones populares',
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
                child: FutureBuilder<Object>(
                future: _futureP3,
                  builder: (context, snapshot2) {
                    print(snapshot2.data);
                    print('fvgbhdnsmkdjbvsgbhnj');
                    if (!snapshot2.hasData)
                      return Center(child: CircularProgressIndicator());
                    else
                      _popSongs = snapshot2.data;
                    print('fvgbhdnsmkdjbvsgbhnj');
                    print(_popSongs);
                    return Column(
                      children: <Widget>[
                        Stack(
                            children: <Widget>[
                              Container(
                                height: tam_body-30,
                                child: ListView(
                                    padding: new EdgeInsets.symmetric(vertical: 8.0),
                                    children: _popSongs.map(
                                            (contact) => new SongItem(
                                            contact, widget.user, widget.audio)).toList()
                                ),
                              ),
                            ]
                        ),
                        //AudioBar(audio),
                        audio2,
                        //_buildSongBar(),
                      ],
                    );
                  }),
            )
           ]
          ),
        );
      }
    //aqui


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
                      if (viewPlaylist) Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          RaisedButton(
                            color: Colors.cyan,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                                side: BorderSide(color: Colors.black)),
                            onPressed: ()  {
                              // devolverá true si el formulario es válido, o falso si
                              // el formulario no es válido.
                              reproducirPlaylist(playlist.id);
                            },
                            child: Text('Reproducir', style: TextStyle(color: Colors.white)),
                          ),
                          Container(
                            width: 40,
                          ),
                          RaisedButton(
                            color: Colors.cyan,
                            shape: RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(15.0),
                                side: BorderSide(color: Colors.black)),
                            onPressed: ()  {
                              // devolverá true si el formulario es válido, o falso si
                              // el formulario no es válido.
                              colaPlaylist(playlist.id);
                            },
                            child: Text('Añadir a la cola', style: TextStyle(color: Colors.white)),
                          ),
                        ],
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
        builder: (context, snapshot2) {
          print(snapshot2.data);
          if (!snapshot2.hasData) return Center(child: CircularProgressIndicator());
          else _albums = snapshot2.data;
          return Container(
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
                              if (viewAlbum) Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  RaisedButton(
                                    color: Colors.cyan,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(15.0),
                                        side: BorderSide(color: Colors.black)),
                                    onPressed: ()  {
                                      // devolverá true si el formulario es válido, o falso si
                                      // el formulario no es válido.
                                      reproducirAlbum(album.id);
                                    },
                                    child: Text('Reproducir', style: TextStyle(color: Colors.white)),
                                  ),
                                  Container(
                                    width: 40,
                                  ),
                                  RaisedButton(
                                    color: Colors.cyan,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: new BorderRadius.circular(15.0),
                                        side: BorderSide(color: Colors.black)),
                                    onPressed: ()  {
                                      // devolverá true si el formulario es válido, o falso si
                                      // el formulario no es válido.
                                      colaAlbum(album.id);
                                    },
                                    child: Text('Añadir a la cola', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),

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
        double tam_pantalla_alt = SizeConfig.screenHeight;
        double tam_body = tam_pantalla_alt -10-15-34-40-200;
        return Container(
          color: Colors.white,
          child: Column (
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
                    Text('   Podcast populares',
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
                  child: FutureBuilder<List<Podcast>>(
                      future: _futureP4,
                      builder: (context, snapshot2) {
                        print(snapshot2.data);
                        print('fvgbhdnsmkdjbvsgbhnj');
                        if (!snapshot2.hasData)
                          return Center(child: CircularProgressIndicator());
                        else
                          _popSongs2 = snapshot2.data;

                        print(_popSongs2);
                        return Stack(
                          children: <Widget>[
                            Container(
                                height: tam_body - 40,
                                child:
                                Column(
                                  children: <Widget>[
                                    //_buildRow(_popSongs[i]),
                                    ListView(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        padding: new EdgeInsets.symmetric(
                                            vertical: 8.0),
                                        children: _popSongs2.map<Widget>(
                                                (contact) =>
                                            new PodcastItem(
                                                contact, widget.user, audio)).toList()
                                    ),

                                  ],
                                )
                            ),

                            //AudioBar(audio),
                            audio2,
                            //_buildSongBar(),
                          ],
                        );
                      }),
                )
              ]
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


      Widget _buildRow(var song){
        print('______________________________________________________________________');
        print(song);
        final savedSongs = [] ;//= _saved.contains(songName);
        return ListTile(
          title: Text(song.nombre),
          //subtitle: Text(song.),
          leading: Container(
            width: 85,
            child: Row(

            children: <Widget>[

                Container(
                    height: 50,
                    width: 50,
                    decoration: _myBoxDecoration(),
                    child: (song.pathImg != null)
                        ? Image.network(song.pathImg)
                        : Image.asset('images/appleMusic.png'),),
                SizedBox(width: 10,),
                Icon(Icons.play_arrow),
             ],
              ),
          ),
          onTap: (){
            //audioCache.play(song);

            setState(() {
              reproduciendo = true;
            });
          },
          trailing: IconButton(
            icon : Icon( Icons.favorite_border),
            color : Colors.cyan ,
            onPressed: (){
              setState((){

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
      createMenu(BuildContext context){
        return showDialog(context: context, builder: (context){
          return AlertDialog(
            title: Text("UpBeat"),
            content: SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text("¿Desea eliminar esta playlist?"),
                  ],
                )
            ),
            actions: <Widget>[
              ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  new RaisedButton(child: Text("NO"),
                      onPressed:() {
                        setState(() {
                          Navigator.of(context).pop();
                        });
                      }
                  ),
                  new RaisedButton(child: Text("Yes"),
                      onPressed: () {
                        print(_playlist.id);
                        setState(() {
                          deletePlaylist(_playlist);
                        });
                      }
                  )
                ],
              )
            ],
          );
        });
      }


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
        onLongPress: () => createMenu(context),
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
                      ? FittedBox(
                          fit: BoxFit.fill,
                          child: Image.network(_playlist.pathImg)
                      )
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
        createMenu(BuildContext context){
          return showDialog(context: context, builder: (context){
            return AlertDialog(
              title: Text("UpBeat"),
              content: SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Text("¿Desea eliminar esta playlist?"),
                    ],
                  )
              ),
              actions: <Widget>[
                ButtonBar(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    new RaisedButton(child: Text("NO"),
                        onPressed:() {
                          setState(() {
                            Navigator.of(context).pop();
                          });
                        }
                    ),
                    new RaisedButton(child: Text("Yes"),
                        onPressed: () {
                          print(_album.id);
                          setState(() {
                            deleteAlbum(_album);
                          });
                        }
                    )
                  ],
                )
              ],
            );
          });
        }

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
          onLongPress: () => createMenu(context),
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
                        ? FittedBox(fit: BoxFit.fill, child: Image.network(_album.pathImg))
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
    List<Album> _list2;
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
        jsonData3 = json.decode(response.body);
        _list2 = (jsonData3 as List).map((p) => Album.fromJson(p)).toList();
      });
    }
    return _list2;
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
      print('canciones de album ok');
    }
    return _list;
  }

  var _id;
  void choiceAction(String choice) {

    if (choice == Options.p3){

      widget.audio.addEnd(_id);
      // Push a la vista de playlists del usuario
    }
  }



  Widget showPlaylist(Playlist _playlist) {
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
              body: (_songlist.length == 0)
                  ? Text("La playlist no tiene canciones",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Montserrat'
                    ),
                  )
                  : new ListView(
                  padding: new EdgeInsets.symmetric(vertical: 8.0),
                  children: _songlist.map(
                          (contact) => new SongItemPlaylist(widget.audio, _playlist,
                          contact, widget.user)).toList()
              ),
            );
          }
        ),
      ),
    );
  }

  Widget showAlbum(Album _album) {

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 179,
        child: FutureBuilder<List<Song>>(
            future: _futurels2,
            builder: (context, snapshot) {
              if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
              else _songlistAlbum = snapshot.data;
              return new Scaffold(
                body: new ListView(
                    padding: new EdgeInsets.symmetric(vertical: 8.0),
                    children: _songlistAlbum.map(
                            (contact) => new SongItemAlbum(widget.audio, _album,
                            contact, widget.user)).toList()
                ),
              );
            }
        ),
      ),
    );
  }
}
class SongItemPlaylist extends StatefulWidget {
  final AudioControl audio;
  final Playlist playlist;
  final Song song;
  final String me;
  SongItemPlaylist( this.audio, this.playlist, this.song, this.me);

  @override
  SongItemPlaylistState createState() => SongItemPlaylistState();
}

class SongItemPlaylistState extends State<SongItemPlaylist> {

  Icon fav = Icon(Icons.favorite_border) ;
  Future _future2;
  var jsonData;
  String _autor;
  var _creador;
  int id;
  bool hayAutor = false;

  isFav(String me, int songId) async {
    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/markFavSong/$me/$songId');
    final response2 = await http.get(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    print ("isFAV:" + response2.statusCode.toString());
    if (response2.statusCode == 200) {
      var ret = json.decode(response2.body);
      if(ret == 0){
        setState(() {
          fav = Icon(Icons.favorite);
        });
      }
    }
  }

  favSong(String me, int songId) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/favSong/$me/$songId');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        fav = Icon(Icons.favorite);
      });
    }
  }

  unFavSong(String me, int songId) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/eliminateFavSong/$me/$songId');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        fav = Icon(Icons.favorite_border);
      });
    }
  }

  Future takeOutSong(int playlistId) async{
    int songId= widget.song.id;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/playlist/takeOut/$playlistId/$songId');
    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Added Song Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
      });
    }
  }

  reproducirCancion( var idSong) async{
    var usuario = widget.me;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/reproducirCancion/$usuario/$idSong",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status añadir a cola primera: ${response2.statusCode}');

    widget.audio.reproducir(widget.me);

  }

  colaCancion( var idSong) async{
    var usuario = widget.me;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/addCancionCola/$usuario/$idSong",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status añadir a cola primera: ${response2.statusCode}');

  }



  Future<String> getSongAutor() async{
    List<Song> _list;
    id = widget.song.id;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cancion/getbyId/$id');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print('Response status get songs autor: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      print('get song done');
      setState(() {
        jsonData = json.decode(response.body);

        _creador = jsonData['creador'];
        print(_creador);
        print('_____23432____');
        _autor = _creador['username'];
        print(_autor);
        print('_____23432____');
        hayAutor = true;

      });

    }
    return _autor;
  }

  @override
  void initState() {
    super.initState();
    isFav(widget.me, widget.song.id);

  }
  @override
  Widget build(BuildContext context) {
    _future2 = getSongAutor();
    return FutureBuilder<dynamic>(
        future: _future2,
        builder: (context, snapshot) {
          return new ListTile(
            leading: Container(
                height: 50,
                width: 50,
                decoration: _myBoxDecoration(),
                child: (widget.song.pathImg != null) ? FittedBox(fit: BoxFit.fill,
                    child: Image.network(widget.song.pathImg))
                    : Image.asset('images/appleMusic.png')
            ),
            title: new Text(widget.song.nombre),
            trailing:
            Wrap(
              children: <Widget>[
                IconButton(
                    icon: fav,
                    color: Colors.red,
                    onPressed: () {
                      print(fav);
                      if (fav.icon == (Icons.favorite_border)){
                        favSong(widget.me, widget.song.id);
                      }
                      else {
                        unFavSong(widget.me, widget.song.id);
                      }
                    }
                ),
                PopupMenuButton<String>(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context){
                    return Options.choicesSPl.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );

                    }).toList();
                  },
                ),
              ],
            ),
            enabled: true,
            subtitle: new Text(hayAutor ? _autor : ''),
            onTap: () => reproducirCancion(widget.song.id)
          );
        }
    );
  }

  BoxDecoration _myBoxDecoration(){
    return BoxDecoration(
        border: Border.all(
          color: Colors.cyan,
          width: 1.5,),
        borderRadius: BorderRadius.all(Radius.circular(5))
    );
  }

  void choiceAction(String choice) {
    if(choice == Options.p3){
      colaCancion(widget.song.id);
    }
    else if (choice == Options.p5){
      int playlistId = widget.playlist.id;
      print ("Quitar de la Playlist");
      takeOutSong(playlistId);

      // Push a la vista de playlists del usuario
    }
  }

}

class SongItemAlbum extends StatefulWidget {
  final AudioControl audio;
  final Album album;
  final Song song;
  final String me;
  SongItemAlbum(this.audio, this.album, this.song, this.me);

  @override
  SongItemAlbumState createState() => SongItemAlbumState();
}

class SongItemAlbumState extends State<SongItemAlbum> {

  Icon fav = Icon(Icons.favorite_border) ;
  Future _future2;
  var jsonData;
  String _autor;
  var _creador;
  int id;
  bool hayAutor = false;

  isFav(String me, int songId) async {
    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/markFavSong/$me/$songId');
    final response2 = await http.get(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    print ("isFAV:" + response2.statusCode.toString());
    if (response2.statusCode == 200) {
      var ret = json.decode(response2.body);
      if(ret == 0){
        setState(() {
          fav = Icon(Icons.favorite);
        });
      }
    }
  }

  favSong(String me, int songId) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/favSong/$me/$songId');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        fav = Icon(Icons.favorite);
      });
    }
  }

  unFavSong(String me, int songId) async {

    var uri2 = Uri.https('upbeatproyect.herokuapp.com','/cliente/eliminateFavSong/$me/$songId');
    final response2 = await http.put(
      uri2,headers: <String, String>{'Content-Type': 'application/json; charset=UTF-8',},
    );
    if (response2.statusCode == 200) {
      setState(() {
        fav = Icon(Icons.favorite_border);
      });
    }
  }

  reproducirCancion( var idSong) async{
    var usuario = widget.me;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/reproducirCancion/$usuario/$idSong",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status añadir a cola primera: ${response2.statusCode}');

    widget.audio.reproducir(widget.me);

  }

  colaCancion( var idSong) async{
    var usuario = widget.me;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/addCancionCola/$usuario/$idSong",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status añadir a cola primera: ${response2.statusCode}');

  }

  Future takeOutSong(int albumId) async{
    int songId= widget.song.id;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/album/takeOut/$albumId/$songId');
    final response = await http.put(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Added Song Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      setState(() {
      });
    }
  }



  Future<String> getSongAutor() async{
    List<Song> _list;
    id = widget.song.id;
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cancion/getbyId/$id');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json;',
      },
    );
    print('Response status get songs autor: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      print('get song done');
      setState(() {
        jsonData = json.decode(response.body);

        _creador = jsonData['creador'];
        print(_creador);
        print('_____23432____');
        _autor = _creador['username'];
        print(_autor);
        print('_____23432____');
        hayAutor = true;

      });

    }
    return _autor;
  }

  @override
  void initState() {
    super.initState();
    isFav(widget.me, widget.song.id);

  }
  @override
  Widget build(BuildContext context) {
    _future2 = getSongAutor();
    return FutureBuilder<dynamic>(
        future: _future2,
        builder: (context, snapshot) {
          return new ListTile(
            leading: Container(
                height: 50,
                width: 50,
                decoration: _myBoxDecoration(),
                child: (widget.song.pathImg != null) ? FittedBox(fit: BoxFit.fill,
                    child: Image.network(widget.song.pathImg))
                    : Image.asset('images/appleMusic.png')
            ),
            title: new Text(widget.song.nombre),
            trailing:
            Wrap(
              children: <Widget>[
                IconButton(
                    icon: fav,
                    color: Colors.red,
                    onPressed: () {
                      print(fav);
                      if (fav.icon == (Icons.favorite_border)){
                        favSong(widget.me, widget.song.id);
                      }
                      else {
                        unFavSong(widget.me, widget.song.id);
                      }
                    }
                ),
                PopupMenuButton<String>(
                  onSelected: choiceAction,
                  itemBuilder: (BuildContext context){
                    return Options.choicesSAl.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );

                    }).toList();
                  },
                ),
              ],
            ),
            enabled: true,
            subtitle: new Text(hayAutor ? _autor : ''),
            onTap: () => reproducirCancion(widget.song.id)
          );
        }
    );
  }

  BoxDecoration _myBoxDecoration(){
    return BoxDecoration(
        border: Border.all(
          color: Colors.cyan,
          width: 1.5,),
        borderRadius: BorderRadius.all(Radius.circular(5))
    );
  }

  void choiceAction(String choice) {

    if(choice == Options.p3){
      colaCancion(widget.song.id);
    }
    else if (choice == Options.p6){
      int albumId = widget.album.id;
      takeOutSong(albumId);
    }
  }

}
