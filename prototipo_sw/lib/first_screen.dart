import 'package:flutter/material.dart';
import 'package:prototipo_sw/main.dart';
import 'package:prototipo_sw/register.dart';
import 'package:prototipo_sw/login.dart';
class FirstScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Center(
            child: AppBarImage()
        ),
      ),
      body: Buttons(),
    );
  }
}

class Buttons extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new ButtonsState();
  }
}

class ButtonsState extends State<Buttons>{
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Login(), fullscreenDialog: true));
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.cyan,
                    Colors.lightBlueAccent,
                    Colors.cyanAccent
                  ],
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                  'Iniciar Sesión',
                  style: TextStyle(fontSize: 20)
              ),
            ),
          ),
          const SizedBox(height: 30),
          RaisedButton(
            onPressed: () {Navigator.push(context, MaterialPageRoute(builder: (context) => Register(), fullscreenDialog: true));
            },
            textColor: Colors.white,
            padding: const EdgeInsets.all(0.0),
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.cyan,
                    Colors.lightBlueAccent,
                    Colors.cyanAccent
                  ],
                ),
              ),
              padding: const EdgeInsets.all(10.0),
              child: const Text(
                  '  Registrarse  ',
                  style: TextStyle(fontSize: 20)
              ),
            ),
          ),
        ],
      ),
    );
  }
}
