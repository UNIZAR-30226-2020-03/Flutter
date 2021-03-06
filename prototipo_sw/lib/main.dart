import 'package:flutter/material.dart';

import 'package:prototipo_sw/Profile_only_read.dart';
import 'package:prototipo_sw/change_pass.dart';
import 'package:prototipo_sw/first_screen.dart';
import 'package:prototipo_sw/login.dart';
import 'package:prototipo_sw/songScreen.dart';
import 'package:prototipo_sw/crear_playlist.dart';
import 'AudioControl.dart';

import 'package:prototipo_sw/uploadSong.dart';
import 'package:prototipo_sw/SongListScreen.dart';
import 'home.dart';

import 'register.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UpBeat',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.cyan,
      ),
      home: Authenticate(),
      routes: {
        'login': (context) => Login(),
        'register': (context) => Register(),
        'home': (context) => Home(),
        'song': (context) => SongScreen(),
        'change_pass': (context) => ChangePass(),
        'song_list' : (context) => SongList(),
      }
    );
  }
}