import 'dart:convert';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:prototipo_sw/home.dart';
import 'package:prototipo_sw/model/playlist.dart';
import 'package:prototipo_sw/model/song.dart';
import 'package:prototipo_sw/searchScreen.dart';
import 'package:prototipo_sw/uploadSong.dart';
import 'AudioControl.dart';

import 'package:http/http.dart' as http;

import 'package:path/path.dart' as Path;



class PlaylistScreen extends StatefulWidget {
  final Playlist playlist;
  final String email;
  final AudioControl audio;
  const PlaylistScreen(this.playlist, this.email, this.audio);

  @override
  _PlaylistScreenState createState() => _PlaylistScreenState();
}


class _PlaylistScreenState extends State<PlaylistScreen> {
  Future future;

  var jsonData;

  List<Song> songList;

  @override
  void initState(){
    future = getPlaylistSongs(widget.playlist);
    super.initState();
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


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar:  AppBar(
          centerTitle: true,
          title: Center(
              child: AppBarImage()
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
              children: <Widget> [
                Container(width: 30,),
                Column(
                  children: <Widget>[
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
                        width: 120,
                        height: 120,
                        decoration: _playlistDecoration(),
                        child: (widget.playlist.pathImg != null)
                        ? Image.network(widget.playlist.pathImg)
                        : Image.asset('images/appleMusic.png'),
                ),
                    ),
                  Container(height: 10,),
                  Text(widget.playlist.nombre),
                  SizedBox(
                    height:40.0
                  ),
                    Container(
                      height: 20,
                    ),
                    FutureBuilder<List<Song>>(
                        future: future,
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
                                                contact, widget.email, widget.audio)).toList()
                                    ),
                                  ),
                                ]
                            ),
                          );
                        }
                    ),
              ]
           ),
          ]
        ),
      )
    );
  }
}