import 'package:flutter/material.dart';
import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';
import 'sizeConfig.dart';


class HomeScreen extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Songs();

  }
}

class Songs extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    print('songs');
    return SongsState();
  }
}

class SongsState extends State<Songs>{
  AudioPlayer audioPlayer;
  AudioCache audioCache;

  final _songsName = ['TT', 'Fancy', 'cancion 3', 'cancion 4','TT', 'Fancy', 'cancion 3', 'cancion 4','TT', 'Fancy', 'cancion 3', 'cancion 4'];
  final _singers = ['Twice', 'Twice', 'grupo 3', 'grupo 4','Twice', 'Twice', 'grupo 3', 'grupo 4','Twice', 'Twice', 'grupo 3', 'grupo 4'];
  final _songs = ['twice-tt-mv.mp3','twice-fancy-mv.mp3','','','twice-tt-mv.mp3','twice-fancy-mv.mp3','','','twice-tt-mv.mp3','twice-fancy-mv.mp3','',''];
  final _saved = Set();

  final _playlists = ['Playlist 1', 'Playlist 2', 'Playlist 3', 'Playlist 4', 'Playlist 5'];
  bool listFixPlaylist = true;

  bool reproduciendo = false;
  var currentSong = 0;

  double volume = 0.5;
  double volumeP = 0.0;
  double currentVolume;

  Duration duration = Duration();
  Duration position = Duration();

  var _currentScreenHome = 0;
  var _currentScreenHomeBool = [true,false,false,false];
  final _ScreensHome = [ 'Songs', 'Playlists', 'Albums', 'Podcasts'];





  @override
  void initState(){
    super.initState();
    audioPlayer = AudioPlayer();
    audioCache = AudioCache(fixedPlayer: audioPlayer);


  }

  @override
  Widget build(BuildContext context){


    SizeConfig().init(context);






    if (_currentScreenHomeBool[3]){
      return Scaffold(
        body: _buildPodcasts(),
      );

    }else if (_currentScreenHomeBool[2]){
      return Scaffold(
        body: _buildAlbums(),
      );

    }else if (_currentScreenHomeBool[1]){
      return Scaffold(
        body: _buildPlayLists(),
    );

    }else{
      return Scaffold(
        body: _buildAll(),
      );
    }
  }

  Widget _buildAll(){
    double tam_pantalla_alt = SizeConfig.screenHeight;
    double tam_body = tam_pantalla_alt -10-15-34-40-200;

    print(tam_body);
    return Container(
      color: Colors.white,
      child: Column (
        children: <Widget>[
          Container(
            height: 10,
          ),
          _buildFullTopMenu(),
          Container(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Text('   Tus últimas 10',
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
                _buildSongBar(),
              ],
            ),
          ),
        ]
      ),
    );
  }

  Widget _buildSongs(){
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
          ),
          _buildFullTopMenu(),
        ],
      ),
    );
  }

  Widget _buildPlayLists(){
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
          ),
          _buildFullTopMenu(),
          Container(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Text('     Playlists',
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

            height: 770,
            child: Stack(
              children: <Widget>[
                Container(

                  height: 730,
                  child:



                      ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _playlists.length,
                          itemBuilder: (context, i) {
                            print(i);


                            return _buildRowPlaylist(_playlists[i], i);
                          }

                      ),

                  ),







                _buildSongBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlbums(){
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
          ),
          _buildFullTopMenu(),
          Container(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Text('     Albums',
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

            height: 770,
            child: Stack(
              children: <Widget>[
                Container(

                  height: 730,
                  child:



                  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _playlists.length,
                      itemBuilder: (context, i) {
                        print(i);


                        return _buildRowPlaylist(_playlists[i], i);
                      }

                  ),

                ),



                _buildSongBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodcasts(){
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: 10,
          ),
          _buildFullTopMenu(),
          Container(
            height: 15,
          ),
          Row(
            children: <Widget>[
              Text('     Podcasts',
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

            height: 770,
            child: Stack(
              children: <Widget>[
                Container(

                  height: 730,
                  child:



                  ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _playlists.length,
                      itemBuilder: (context, i) {
                        print(i);


                        return _buildRowPlaylist(_playlists[i], i);
                      }

                  ),

                ),



                _buildSongBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _buildFullTopMenu(){


    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[

        SizedBox(
          width: 74,
          child: _buildTopMenu(0),
        ),

        SizedBox(
          width: 88,
          child: _buildTopMenu(1),
        ),

        Container(
          width: 83,
          child: _buildTopMenu(2),
        ),

        Container(
          width: 94,
          child: _buildTopMenu(3),
        ),




      ],
    );
}

 Widget _buildTopMenu(var screen){
    return ButtonTheme(
      minWidth: 40,
        child: FlatButton(

          color: Colors.white,
          disabledColor: Colors.white,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          onPressed: (){
            setState(() {
              if (screen == _currentScreenHome){

              } else{
                _currentScreenHome = screen;
                for(int i = 0; i<4; i++){
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

  BoxDecoration _myBoxDecoration(){
    return BoxDecoration(
      border: Border.all(
          color: Colors.cyan,
          width: 1.5,),
      borderRadius: BorderRadius.all(Radius.circular(5))
    );
  }

Widget _buildRowPlaylist(var playlistName, var index){

    return Container(
      child: Row(
        children: <Widget>[
          Container(width: 30,),
          Column(
            children: <Widget>[
              Container(
                width: 175,
                height: 175,
                decoration: _playlistDecoration(),
                child: Image.asset('images/appleMusic.png'),
              ),
              Text(playlistName),
            ],
          ),
        ],
      ),
    );
}

BoxDecoration _playlistDecoration(){
  return BoxDecoration(
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


  );
}


  Widget _buildSongBar(){


    return Positioned.fill(

      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: (){
            Navigator.of(context).pushNamed('song', arguments: reproduciendo);
          },
          child: Container(

            height: 30,
            child: Row (



              crossAxisAlignment: CrossAxisAlignment.end,
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
                IconButton(
                  icon : Icon((volume > 0.0) ? Icons.volume_up : Icons.volume_mute),
                  onPressed: (){
                    setState((){
                      if(volume > 0.0){
                        volumeP = volume;
                        volume = 0.0;
                      }else{
                        volume = volumeP;
                      }
                    });
                  },
                ),
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
          ),
        ),
      ),
    );
  }

}


