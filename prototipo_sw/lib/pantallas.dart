import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

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

  double volume = 1;
  double currentVolume;

  Duration duration = Duration();
  Duration position = Duration();

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

    return Column (
      children: <Widget>[
        Expanded(
          child: Container(
            child:
            ListView.builder(
              itemCount: _songsName.length,
              itemBuilder: (context, i){
                return _buildRow(_songsName[i], _singers[i], _songs [i], i);
              }
            ),
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
            Expanded(
              child: Container(
                child: Text(_songsName[currentSong],
                  overflow: TextOverflow.clip,),
              ),
            ),
            Icon(Icons.volume_up),
            Slider(
              value: volume,
              max: 3.0,
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


    );
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
        color : savedSongs ? Colors.red : null,
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