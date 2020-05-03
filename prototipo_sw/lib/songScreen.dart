import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'sizeConfig.dart';

class SongScreen extends StatefulWidget {
  @override
  _SongScreenState createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {



  @override
  Widget build(BuildContext context) {

    bool reproduciendo = ModalRoute.of(context).settings.arguments;

    SizeConfig().init(context);
    print('---');
    print(SizeConfig.screenHeight);
    print(SizeConfig.screenWidth);

    return Scaffold(
      /*appBar: AppBar(
          elevation: 0.0,
          brightness: Brightness.light,
          centerTitle: true,
          title: Center(
              child: Image.asset('images/logoDefinitivo3.png')
          )
      ),*/
      body: Container(
        color: Colors.grey[100],
        child: Column(
          children: <Widget>[
            Container(

              decoration: _myBoxDecoration2(),
              child: Column(
                children: <Widget>[
                  Container(height: 50,),
                  Row(
                    children: <Widget>[
                      Container(width: 10),
                      IconButton(
                        icon: Icon(Icons.arrow_back, size: 30,
                        ),
                        onPressed: (){
                          Navigator.pop(context);
                        },
                      ),
                    ],
                  ),
                  Text(
                    'Now playing',
                    style: TextStyle(fontSize: 34.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(height: 75,),
                  Container(
                    width: 250,
                    height: 250,
                    //color: Colors.white,
                    decoration: _myBoxDecoration(),
                    child: Image.asset('images/appleMusic.png'),

                  ),
                  Container(height: 50,),
                  Text ('Nombre canción',
                    style: TextStyle(fontSize: 40.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(height: 40,),
                ],
              ),
            ),



            Container(height: 25,),
            Text ('Grupo',
              style: TextStyle(fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700]),
            ),
            Container(height: 75,),
            Row(
              children: <Widget>[
                Expanded(
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Icon(Icons.access_alarm),
                            Text ('Duracion'),
                           ],
                      ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.calendar_today),
                      Text ('Fecha'),
                    ],
                  ),
                ),
              ],
            ),
            IconButton(
              icon: Icon(reproduciendo ? Icons.pause : Icons.play_arrow),
              onPressed: (){
                if (reproduciendo){
                  //audioPlayer.stop();
                }else {
                  //audioCache.play(_songs[currentSong]);
                }

                setState(() {
                  reproduciendo = !reproduciendo;
                });

              },
            ),


          ],
        ),
      ),
    );
  }


  BoxDecoration _myBoxDecoration(){
    return BoxDecoration(
      color: Colors.white,
      border: Border.all(
          width: 4.0,
          color: Colors.cyan,
      ),
      borderRadius: BorderRadius.all(Radius.circular(20)
      ),
    );
  }


  BoxDecoration _myBoxDecoration2(){
    return BoxDecoration(
      color: Colors.cyan[100],
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(40),
        bottomRight: Radius.circular(40),
      )
    );
  }


}
