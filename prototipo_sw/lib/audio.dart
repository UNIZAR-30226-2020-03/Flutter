import 'package:flutter/material.dart';
import 'package:audiofileplayer/audiofileplayer.dart';




class audioControl extends StatefulWidget {

  @override
  _audioControlState createState() => _audioControlState();
}

class _audioControlState extends State<audioControl> {
  Audio audio ;

  var URL;

  double volume = 0.5;

  double volumeP = 0.0;

  bool reproduciendo = false;

  @override
  Widget build(BuildContext context) {

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
                      //audio.pause();
                    }else {
                      //audio.play();
                    }

                    setState(() {
                      reproduciendo = !reproduciendo;
                    });

                  },
                ),
                Expanded(
                  child: Container(
                    child: Text('Song Name',
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
                      //audio.setVolume(volume);
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
