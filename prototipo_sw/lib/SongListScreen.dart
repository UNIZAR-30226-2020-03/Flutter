import 'package:flutter/material.dart';
import 'sizeConfig.dart';


class SongList extends StatelessWidget {




  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double tam_pantalla_alt = SizeConfig.screenHeight;
    double tam_body = tam_pantalla_alt -10-15-34-40-200;



    final _songsName = ['TT', 'Fancy', 'cancion 3', 'cancion 4','TT', 'Fancy', 'cancion 3', 'cancion 4','TT', 'Fancy', 'cancion 3', 'cancion 4'];
    final _singers = ['Twice', 'Twice', 'grupo 3', 'grupo 4','Twice', 'Twice', 'grupo 3', 'grupo 4','Twice', 'Twice', 'grupo 3', 'grupo 4'];
    final _songs = ['twice-tt-mv.mp3','twice-fancy-mv.mp3','','','twice-tt-mv.mp3','twice-fancy-mv.mp3','','','twice-tt-mv.mp3','twice-fancy-mv.mp3','',''];
    final _saved = Set();

    print(tam_body);
    return Scaffold(
      appBar: AppBar(
          elevation: 0.0,
          brightness: Brightness.light,
          centerTitle: true,
          backgroundColor: Colors.cyan,
          title: Center(
              child: Container(
                  width: 150,
                  height: 150,
                  child: Image.asset('images/logoDefinitivo3.png'))
          )
      ),
      body: Container(
        color: Colors.white,
        child: Column (
            children: <Widget>[
              Container(
                height: 10,
              ),
              Container(
                height: 15,
              ),
              Row(
                children: <Widget>[

                  Text('   Playlist X',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  InkWell(
                    child: Container(
                      decoration: _repDecoration(),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text( 'REPRODUCIR',
                          style: TextStyle(
                              fontSize: 22.0,
                              fontWeight: FontWeight.w800,
                              color: Colors.cyan,

                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: tam_body,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: tam_body-40,
                      child:
                      ListView.builder(
                          scrollDirection: Axis.vertical,
                          itemCount: _songsName.length,
                          itemBuilder: (context, i){
                            return Column(
                              children: <Widget>[
                                _buildRow(_songsName[i], _singers[i], _songs [i], i),
                                Divider(
                                  color: Colors.cyan,
                                  indent: 20,
                                  endIndent: 20,
                                ),
                              ],
                            );
                          }
                      ),
                    ),
                    //_buildSongBar(),
                  ],
                ),
              ),
            ]
        ),
      ),
    );
  }



  Widget _buildRow(var songName, var group, var song, var index){
    //final savedSongs = _saved.contains(songName);
    return ListTile(
      title: Text(songName),
      subtitle: Text(group),
      leading: Container(
        width: 85,
        child: Row(

          children: <Widget>[


            Container(
                height: 50,
                width: 50,
                decoration: _myBoxDecoration(),
                child: Image.asset('images/appleMusic.png')),
            SizedBox(width: 10,),
            Icon(Icons.play_arrow),
          ],
        ),
      ),
      onTap: (){
        /*audioCache.play(song);
        currentSong = index;
        setState(() {
          reproduciendo = true;
        });*/
      },
      /*trailing: IconButton(
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
      ),*/

    ) ;
  }

  BoxDecoration _myBoxDecoration(){
    return BoxDecoration(
        border: Border.all(
          color: Colors.cyan,
          width: 1.5,),
        borderRadius: BorderRadius.all(Radius.circular(5))
    );
  }

  BoxDecoration _repDecoration(){
    return BoxDecoration(
      border: Border.all(
        color: Colors.cyan,
        width: 3,
      ),
        borderRadius: BorderRadius.all(Radius.circular(10)),

    );
  }



}
