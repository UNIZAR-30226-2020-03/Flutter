import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:prototipo_sw/home.dart';

import 'package:prototipo_sw/model/album.dart';
import 'package:prototipo_sw/model/song.dart';
import 'package:prototipo_sw/searchScreen.dart';


import 'package:http/http.dart' as http;


class AlbumScreen extends StatefulWidget {
  final Album album;
  final String email;
  const AlbumScreen(this.album, this.email);

  @override
  _AlbumScreenState createState() => _AlbumScreenState();
}


class _AlbumScreenState extends State<AlbumScreen> {
  Future future;

  var jsonData;

  List<Song> songList;

  @override
  void initState(){
    future = getAlbumSongs(widget.album);
    super.initState();
  }


  BoxDecoration _AlbumDecoration(){
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

  Future<List<Song>> getAlbumSongs(Album album) async{
    List<Song> _list;
    int albumId = album.id;
    print('getSongsAlbum');
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
      print('canciones de Album ok');
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
                          decoration: _AlbumDecoration(),
                          child: (widget.album.pathImg != null)
                              ? Image.network(widget.album.pathImg)
                              : Image.asset('images/appleMusic.png'),
                        ),
                      ),
                      Container(height: 10,),
                      Text(widget.album.nombre),
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
                                                  contact, widget.email)).toList()
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