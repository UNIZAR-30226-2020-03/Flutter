import 'package:flutter/material.dart';

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
  final _songs = ['cancion 1', 'cancion 2', 'cancion 3', 'cancion 4'];
  final _singers = ['grupo 1', 'grupo 2', 'grupo 3', 'grupo 4'];
  final _saved = Set();
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
              itemCount: _songs.length,
              itemBuilder: (context, i){
                return _buildRow(_songs[i], _singers[i]);
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

  Widget _buildRow(var song, var group){
    final savedSongs = _saved.contains(song);
    return ListTile(
      title: Text(song),
      subtitle: Text(group),
      leading: Icon(Icons.play_arrow),
      trailing: IconButton(
        icon : Icon(savedSongs ? Icons.favorite : Icons.favorite_border),
        color : savedSongs ? Colors.red : null,
        onPressed: (){
          setState((){
            if(savedSongs){
              _saved.remove(song);
            }else{
              _saved.add(song);
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