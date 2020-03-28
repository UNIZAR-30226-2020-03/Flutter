import 'package:flutter/material.dart';
import 'package:prototipo_sw/main.dart';
import 'package:prototipo_sw/register.dart';
import 'package:prototipo_sw/login.dart';


class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate>
    with SingleTickerProviderStateMixin {

  AnimationController _controller;

  Animation<double> logoAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));

    logoAnimation =  Tween(begin: 50.0, end: 150.0).animate(CurvedAnimation(
        parent: _controller,
        curve: Interval(0, 1, curve: Curves.elasticInOut)));
    _controller.forward();
    _controller.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 80, 0, 0),
            child: Center(
              child: Container(
                height: 200,
                width: 200,
                child: Image.asset('images/logoDefinitivo1.png'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 90, 0, 30),
            child: Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.grey,
                    Colors.blueGrey,
                    Colors.lightBlue[200],
                  ],
                ),
              ),
              child: RaisedButton(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.black)),
                onPressed: () {
                  Navigator.pushNamed(context, 'login');
                },
                textColor: Colors.black,
                child: const Text('Iniciar Sesión', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
          Row(children: <Widget>[
            Expanded(
                child: Divider(
              endIndent: 15,
              indent: 15,
            )),
          ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: Container(
              width: 300,
              height: 40,
              decoration: BoxDecoration(
                borderRadius: new BorderRadius.circular(15.0),
                gradient: LinearGradient(
                  colors: <Color>[
                    Colors.grey,
                    Colors.blueGrey,
                    Colors.lightBlue[200],
                  ],
                ),
              ),
              child: RaisedButton(
                color: Colors.transparent,
                shape: RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(15.0),
                    side: BorderSide(color: Colors.black)),
                onPressed: () {
                  Navigator.pushNamed(context, 'register');
                },
                textColor: Colors.black,
                child: const Text('Registrarse', style: TextStyle(fontSize: 20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
