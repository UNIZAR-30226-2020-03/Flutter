//import 'dart:html';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ScreenArguments2 {
  final bool reproduciendo;
  final bool mitad;
  final String name;
  final AudioControl audio;
  final double sliderValue;
  final double duration;

  ScreenArguments2(this.reproduciendo, this.mitad, this.name, this.audio, this.sliderValue, this.duration);
}

class AudioControl {
  Audio audio;

  double volume = 0.5;

  double volumeP = 0.0;
  bool reproduciendo = false;
  String songName = '';
  double audioDuration;
  double audioPosition;
  double sliderValue;
  String ImgPath;

  String getImagen(){
    return ImgPath;
  }

  void volumeChange(double vol){
    audio.setVolume(vol);
  }

  void parar(){
    audio.pause();
    //audio.dispose();
  }

  void seguir(){
    print(reproduciendo);
    if (reproduciendo){

    audio.resume();
    }

  }
  String getNomCancion(){
    return songName;
  }

  double getDuration(){
    return audioDuration;
  }

  double getSliderPos(){
  print(sliderValue);
    return sliderValue;
  }

  void reproducir2(){
    print('reproducir2');
    audio.play();
  }

  void seek (double pos){
    print('seek________');
    print(reproduciendo);
    if(reproduciendo){

      print(pos);
      audio.seek(pos);
    }

  }
  int idSong;
  String _user;

  Future<void> streamSong() async{
    print('streamSong');
    print(idSong);
    var uri = Uri.https('upbeatproyect.herokuapp.com','/cancion/getStreamUrlMp3byId/$idSong');
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response status stream: ${response.statusCode}');
    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON
      /*setState(() {

        print(response.body);
        print('--');
        //jsonData = json.decode(response.body);
        cancion = response.body;

        print(cancion);
        print('--');
      });*/

    }
    return ('Success');
  }

  var _song;
  var _secs;
  var song;
  reproducirCancion() async{
    var jsonData;
    print('____________________');
    print(_user);
    var response2 = await http.get("https://upbeatproyect.herokuapp.com/cliente/play/$_user",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status play song: ${response2.statusCode}');
    jsonData = json.decode(response2.body);
    print(jsonData);
    print('____________________');
    _song = jsonData['cancion'];
    print(_song);
    _secs = jsonData['segundos'];
    idSong = _song['id'];
    ImgPath = _song['pathImg'];
    songName = _song['nombre'];
    song = _song['pathMp3'];
  }


  nextCancion() async{
    var jsonData;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/next/$_user",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status next song: ${response2.statusCode}');
    jsonData = json.decode(response2.body);
    print(jsonData);
    print('____________________');_song = jsonData['cancion'];
    print(_song);
    _secs = jsonData['segundos'];
    idSong = _song['id'];
    ImgPath = _song['pathImg'];
    songName = _song['nombre'];
    song = _song['pathMp3'];


  }





   AudioBar audio2;
  void getBar(var barSong){
    audio2 = barSong;
  }

  void reproducir3(){
    reproducir(_user);
  }
  void getUser(var user){
    _user = user;
  }

  bool first = true;
  void reproducir( var user) async{

    _user = user;
    print('repr:    $reproduciendo');
    if (!reproduciendo){
      /*idSong = id;
      ImgPath = Img;
      songName = nomCanc;


      print(nomCanc);*/
      print('reproducir');
      print (reproduciendo);
      //streamSong();
      print('first:    $first');
      if (first){
        first = false;
        await reproducirCancion();
      }else{
        await nextCancion();
      }
      print('Antes de reproducir : song');
      print(song);
      audio = Audio.loadFromRemoteUrl(song,
          onComplete: (){
            reproduciendo = false;
            print('ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc');
            print(reproduciendo);
            reproducir(user);
          },
          onDuration:(double duration) => audioDuration=duration,
          onPosition: (double posSeconds) {
            audioPosition = posSeconds;
            sliderValue = audioPosition/audioDuration;
          }
      );
      print('xxxxxxxxxxxxxxxxxxxxxx');
      print(audioDuration);
      print(audioPosition);
      print(sliderValue);

      audio.play();
      reproduciendo = true;
      print(reproduciendo);
    } else{
      audio.pause();
      audio.dispose();

      await reproducirCancion();
      print('Antes de reproducir : song');
      print(song);
      audio = Audio.loadFromRemoteUrl(song,
          onComplete: (){
            reproduciendo = false;
            print('ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc');
            print(reproduciendo);
            reproducir(user);
          },
          onDuration:(double duration) => audioDuration=duration,
          onPosition: (double posSeconds) {
            audioPosition = posSeconds;
            sliderValue = audioPosition/audioDuration;
          }
      );
      print(audioDuration);
      print(audioPosition);
      print(sliderValue);

      audio.play();
      reproduciendo = true;
      print(reproduciendo);
    }

  }

  void reproducirPod(var url, var nom, var img) async{
    print('nom: $nom');
    ImgPath =img;
    songName = nom;
    print('repr:    $reproduciendo');
    if (!reproduciendo){
      /*idSong = id;
      ImgPath = Img;
      songName = nomCanc;


      print(nomCanc);*/
      print('reproducir');
      print (reproduciendo);
      //streamSong();
      audio = Audio.loadFromRemoteUrl(url,
          onComplete: (){
            reproduciendo = false;
            print(reproduciendo);
          },
          onDuration:(double duration) => audioDuration=duration,
          onPosition: (double posSeconds) {
            audioPosition = posSeconds;
            sliderValue = audioPosition/audioDuration;
          }
      );

      print(audioDuration);
      print(audioPosition);
      print(sliderValue);

      audio.play();
      reproduciendo = true;
      print(reproduciendo);
    } else{
      audio.pause();
      audio.dispose();

      print('Antes de reproducir : song');
      print(song);
      audio = Audio.loadFromRemoteUrl(url,
          onComplete: (){
            reproduciendo = false;
            print(reproduciendo);
          },
          onDuration:(double duration) => audioDuration=duration,
          onPosition: (double posSeconds) {
            audioPosition = posSeconds;
            sliderValue = audioPosition/audioDuration;
          }
      );
      print(audioDuration);
      print(audioPosition);
      print(sliderValue);

      audio.play();
      reproduciendo = true;
      print(reproduciendo);
    }

  }


  var lastIdSong;
  lastCancion() async{
    var jsonData;
    var response2 = await http.put("https://upbeatproyect.herokuapp.com/cliente/addCancionCola/$_user/$lastIdSong",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    print('Response2 status next song: ${response2.statusCode}');
    jsonData = json.decode(response2.body);
    print(jsonData);
    print('____________________');_song = jsonData['cancion'];
    print(_song);
    _secs = jsonData['segundos'];
    idSong = _song['id'];
    ImgPath = _song['pathImg'];
    songName = _song['nombre'];
    song = _song['pathMp3'];


  }

  void addEnd(var id) async{
    lastIdSong = id;
    lastCancion();
  }

  void nextSong() async{
    audio.pause();
    audio.dispose();

    await nextCancion();
    print('Antes de reproducir : song');
    print(song);
    audio = Audio.loadFromRemoteUrl(song,
        onComplete: (){
          reproduciendo = false;
          print('ccccccccccccccccccccccccccccccccccccccccccccccccccccccccccccc');
          print(reproduciendo);
          reproducir(_user);
        },
        onDuration:(double duration) => audioDuration=duration,
        onPosition: (double posSeconds) {
          audioPosition = posSeconds;
          sliderValue = audioPosition/audioDuration;
        }
    );
    print(audioDuration);
    print(audioPosition);
    print(sliderValue);

    audio.play();
    reproduciendo = true;
    print(reproduciendo);
  }




}

class AuxAudioBar {
  double volume = 0.5;
  double volumeP = 0;
  bool mitad = false;
  bool icon = false;
  void printVol(){
    print(volume);
    print('dsdbhunjsdvgbhsn');
  }

  double getVol(){

    return volume;
  }
  double getVolP(){
    return volumeP;
  }
  bool getMitad(){
    return mitad;
  }
  bool getIcon(){
    return icon;
  }
  void setVol(double v){
    volume = v;
  }
  void setVolP(double v){
  volumeP = v;
  }
  void setMitad(bool b){
    mitad = b;
  }
  void setIcon(bool b){
    icon = b;
  }

}

class AudioBar extends StatefulWidget {
  final AudioControl audio;
  final AuxAudioBar auxAudio;
  AudioBar(this.audio, this.auxAudio);


  @override
  _AudioBarState createState() => _AudioBarState(audio, auxAudio);
}

class _AudioBarState extends State<AudioBar> {
  final AudioControl audio;
  final AuxAudioBar auxAudio;
  _AudioBarState(this.audio, this.auxAudio);

  var reproduciendo;
  double volume ;
  double volumeP ;
  bool mitad ;
  bool icon ;

   callback() {
     print('calback___________________________');
    setState(() {

    });
  }
  String _now;
  Timer _everySecond;

  @override
  void initState(){
    super.initState();
    auxAudio.printVol();

    print('gdhbdjvbhnj');
    volume = 0;
    volume = auxAudio.getVol();
    volumeP = auxAudio.getVolP();
    mitad = auxAudio.getMitad();
    icon = auxAudio.getIcon();

    // sets first value
    _now = DateTime.now().second.toString();

    // defines a timer
    _everySecond = Timer.periodic(Duration(seconds: 2), (Timer t) {

      setState(() {
        print('lololololo');
        _now = DateTime.now().second.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    reproduciendo = audio.reproduciendo;
    if (reproduciendo){
      print('rep = true');
      icon = true;
      print(mitad);
      if (mitad){

        icon = false;
      }
    }

    print('icon');
    print(icon);

    String songName = '';
    songName =audio.getNomCancion();
    double duration;
    duration = audio.getDuration();
    double sliderVal;
    sliderVal = audio.getSliderPos();


    print('volumen________');
    print(volume);
    print(volumeP);
    auxAudio.setMitad(mitad);
    auxAudio.setIcon(icon);

    return Positioned.fill(

      child: Align(
        alignment: Alignment.bottomCenter,
        child: InkWell(
          onTap: (){
            Navigator.of(context).pushNamed('song', arguments: ScreenArguments2(reproduciendo, mitad, songName,audio,sliderVal, duration));
          },
          child: Container(

            height: 30,
            child: Row (
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                IconButton(
                  icon: Icon(icon ? Icons.pause : Icons.play_arrow),
                  onPressed: (){
                    print(reproduciendo);
                    if (reproduciendo){
                      if(!mitad){
                        print('parada');
                        audio.parar();
                        mitad = true;
                        //auxAudio.setMitad(mitad);
                      }else{
                        print('seguir');
                        audio.seguir();
                        mitad = false;
                        //auxAudio.setMitad(mitad);
                      }

                    }else {
                      print('ooooooooooooooooooooooooooo');
                      audio.reproducir3();
                    }

                    setState(() {
                      reproduciendo = !reproduciendo;
                    });

                  },
                ),
                Expanded(
                  child: Container(
                    child: Text(songName,
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
                        audio.volumeChange(0.0);
                        auxAudio.setVol(volume);
                        auxAudio.setVolP(volumeP);
                      }else{
                        volume = volumeP;
                        audio.volumeChange(volume);
                        auxAudio.setVol(volume);
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
                      audio.volumeChange(volume);
                      auxAudio.setVol(volume);
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

class SongScreen extends StatefulWidget {
  @override
  _SongScreenState createState() => _SongScreenState();
}

class _SongScreenState extends State<SongScreen> {

  bool reproduciendo;
  bool mitad;
  String name;
  AudioControl audio;
  String imgPath;
  double duration;
  double sliderValue;
  double auxSliderValue = 0.0;
  String _now;
  Timer _everySecond;

  @override
  void initState() {
    super.initState();

    // sets first value
    _now = DateTime.now().second.toString();

    // defines a timer
    _everySecond = Timer.periodic(Duration(seconds: 2), (Timer t) {

      setState(() {
        _now = DateTime.now().second.toString();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!mounted){
      print('no mounted');
      return null;
    }

    final ScreenArguments2 arguments = ModalRoute.of(context).settings.arguments;
    setState(() {
      reproduciendo = arguments.reproduciendo;
      mitad = arguments.mitad;
      name = arguments.name;
      audio = arguments.audio;
      sliderValue = arguments.sliderValue;
      duration = arguments.duration;
    });
    print('________________');
    print(sliderValue);
  if (sliderValue == null){
    sliderValue = 0.0;
  }
  sliderValue=audio.getSliderPos();
  if(auxSliderValue > 0){
    sliderValue = auxSliderValue;
  }
    if (sliderValue == null){
      sliderValue = 0.0;
    }
    if (sliderValue > 1){
      sliderValue = 0.0;
    }
  auxSliderValue = 0;
    //bool reproduciendo = ModalRoute.of(context).settings.arguments[0];
    print(duration);
    String duration6 = '';
    if(duration != null){
      print('dfshdbfnjdsdsfvgsbhjnfkjvsbhjnkjvbddnkm');
      int duration2 = duration.toInt();
      String duration3 = duration2.toString();
      String duration4 = duration3.substring(0, duration3.length-2);
      String duration5 = duration3.substring(duration3.length-2, duration3.length);
       duration6 = duration4+':'+duration5;
    }else{
       duration6 = '';
    }

    imgPath = audio.getImagen();
    name = audio.getNomCancion();

  print(imgPath);

    return Scaffold(

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
                          _everySecond.cancel();
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
                    child: (imgPath == null) ? Image.asset('images/appleMusic.png') : Image.network(imgPath),

                  ),
                  Container(height: 50,),
                  Text (name,
                    style: TextStyle(fontSize: 40.0,
                        fontWeight: FontWeight.w600),
                  ),
                  Container(height: 40,),
                ],
              ),
            ),



            Container(height: 25,),
            /*Text ('Grupo',
              style: TextStyle(fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[700]),
            ),*/
            Container(height: 75,),
            /*Row(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(Icons.access_alarm),
                      Text (duration6),
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
            ),*/
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[


                Container(width: 10,),
                IconButton(
                  icon: Icon(Icons.skip_next, color: Colors.black, size: 50,),
                  onPressed: (){audio.nextSong();},
                ),
              ],
            ),
            Slider(
                value: sliderValue,
                onChanged: (double val) {
                  setState(() => sliderValue = val);
                  auxSliderValue = val;
                  final double positionSeconds = val * duration ;
                  audio.seek(positionSeconds);
                }),


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
