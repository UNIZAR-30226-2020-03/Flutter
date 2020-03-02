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
  final _songsName = ['TT', 'cancion 2', 'cancion 3', 'cancion 4'];
  final _singers = ['Twice', 'grupo 2', 'grupo 3', 'grupo 4'];
  final _songs = ['twice-tt-mv.mp3','','',''];
  final _saved = Set();

  @override
  void initState(){
    super.initState();
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);
    print('init');
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
        Container(
          height: 850.0,
          child:
          ListView.builder(
              itemCount: _songsName.length,
              itemBuilder: (context, i){
                return _buildRow(_songsName[i], _singers[i], _songs [i]);
              }
          ),
        ),
        Row (
        //crossAxisAlignment: CrossAxisAlignment.baseline,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: (){

              },
            ),
            Text('Cancion actual')
          ],
        )
      ]


    );
  }

  Widget _buildRow(var songName, var group, var song){
    final savedSongs = _saved.contains(songName);
    return ListTile(
      title: Text(songName),
      subtitle: Text(group),
      leading: Icon(Icons.play_arrow),
      onTap: (){
        audioCache.play(song);
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