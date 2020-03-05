import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeScreen extends StatelessWidget{




  @override
  Widget build(BuildContext context) {

    return Songs();

  }
}



class Songs extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return SongsState();
  }
}

class SongsState extends State<Songs>{
  AudioPlayer audioPlayer;
  AudioCache audioCache;

  final _songsName = ['TT', 'Fancy', 'cancion 3', 'cancion 4'];
  final _singers = ['Twice', 'Twice', 'grupo 3', 'grupo 4'];
  final _songs = ['twice-tt-mv.mp3','twice-fancy-mv.mp3','',''];
  final _saved = Set();

  bool reproduciendo = false;
  var currentSong = 0;

  double volume = 0.5;
  double currentVolume;

  Duration duration = Duration();
  Duration position = Duration();

  var _currentScreenHome = 0;
  var _currentScreenHomeBool = [true,false,false,false,false];
  final _ScreensHome = ['All', 'Songs', 'Playlists', 'Albuns', 'Podcasts'];

  @override
  void initState(){
    super.initState();
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);

    /*audioPlayer.positionHandler = (p) => setState((){
      position = p;
    });

    audioPlayer.durationHandler = (p) => setState((){
      duration = p;
    });
    */
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: _buildSongs(),

    );
  }

  Widget _buildSongs(){

    return Container(
      color: Colors.white,
      child: Column (
        children: <Widget>[
          Container(
            height: 10,
          ),
          Row(
            children: <Widget>[
              Container(
                width: 45,
              ),
              SizedBox(
                width: 50,
                child: _buildTopMenu(0),
              ),
              Container(
                width: 5,
              ),
              SizedBox(
                width: 80,
                child: _buildTopMenu(1),
              ),
              Container(
                width: 5,
              ),
              Container(
                width: 90,
                child: _buildTopMenu(2),
              ),
              Container(
                width: 5,
              ),
              Container(
                width: 80,
                child: _buildTopMenu(3),
              ),
              Container(
                width: 5,
              ),
              Container(
                width: 100,
                child: _buildTopMenu(4),
              ),


            ],
          ),
          Container(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Text('  Tus últimas 10',
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
            height: 730.0,
            child:
            ListView.builder(
                itemCount: _songsName.length,
                itemBuilder: (context, i){
                  return _buildRow(_songsName[i], _singers[i], _songs [i], i);
                }
            ),
          ),

          Row (

            //crossAxisAlignment: CrossAxisAlignment.baseline,
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
              Container(
                child: Text(_songsName[currentSong],
                  overflow: TextOverflow.clip,),
                width: 225.0,

              ),
              Icon(Icons.volume_up),
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

        ]


      ),
    );
  }

 Widget _buildTopMenu(var screen){
    return ButtonTheme(
      minWidth: 40,
        child: FlatButton(

          color: Colors.white,
          disabledColor: Colors.white,

          onPressed: (){
            setState(() {
              if (screen == _currentScreenHome){

              } else{
                _currentScreenHome = screen;
                for(int i = 0; i<5; i++){
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
      leading: Icon(Icons.play_arrow),
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
}



class FavScreen extends StatelessWidget{
  var string = 'Favorite';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
          child: Text(string)
      ),
    );
  }
}

class PlaylistScreen extends StatelessWidget{
  var string = 'PlayLists';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
          child: Text(string)
      ),
    );
  }
}

class SearchScreen extends StatelessWidget{
  var string = 'Search';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
            child: Text(string)
        ),
    );
  }
}

class ProfileScreen extends StatelessWidget{
  var string = 'Profile';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body: Center(
            child: Text(string)
        ),
    );
  }
}