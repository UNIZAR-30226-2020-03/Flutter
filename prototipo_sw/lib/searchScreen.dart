import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';

class SearchScreen extends StatelessWidget{
  var string = 'Search';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
          child: Column(
            children: <Widget>[
              Text(string),
              IconButton(
                icon: Icon(Icons.settings),
                onPressed: (){
                  //File file = await FilePicker.getFile();
                },
              ),
            ],
          )
      ),
    );
  }
}