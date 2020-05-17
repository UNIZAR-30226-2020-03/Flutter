import 'package:flutter/material.dart';
import 'package:prototipo_sw/Profile.dart';
import 'package:prototipo_sw/favScreen.dart';
import 'package:prototipo_sw/pantallas.dart';
import 'package:prototipo_sw/register.dart';
import 'package:prototipo_sw/searchScreen.dart';

class Home extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {

  String _email, _password;

  List<Widget> _children;
  int _currentIndex = 0;
  

  AnimationController _controller;

  Animation logoAnimation;

  @override
  void initState(){
    super.initState();
    
    
    _controller =
        AnimationController(vsync: this, duration: Duration(seconds: 4));

    logoAnimation =  Tween(begin: 50.0, end: 150.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: Interval(0, 1, curve: Curves.elasticInOut)));

    _controller.forward();
    _controller.addListener(() {
      setState(() {
      });
    });

  }

  @override
  Widget build(BuildContext context) {

    final ScreenArguments arguments = ModalRoute.of(context).settings.arguments;
    setState(() {
      _password = arguments.pass; //acordarse de cambiar esto: _password = arguments.pass;
      _email = arguments.email; //_email = arguments.email;
      _children = [
    HomeScreen(_email),
    FavScreen(_email),
    SearchList(_email),
    ProfileScreen(_email, _password),
  ];
    });

    return Scaffold(

      appBar: AppBar(
          elevation: 0.0,
          brightness: Brightness.light,
        centerTitle: true,
        title: Center(
          child: Image.asset('images/logoDefinitivo3.png', width: logoAnimation.value, height: logoAnimation.value)
        )
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex, // this will be set when a new tab is tapped
        onTap: tabbed,
        fixedColor: Colors.cyan,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(Icons.home),
            title: new Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.favorite),
            title: new Text('Favorite'),
          ),

          BottomNavigationBarItem(
            icon: new Icon(Icons.search),
            title: new Text('Search'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile')
          )
        ],
      ),
    );

  }

  void tabbed(int index){
    setState(() {
      _currentIndex = index;
    });
  }

}
class AppBarImage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AssetImage assetImage = AssetImage('images/logoDefinitivo3.png');
    Image image = Image(image: assetImage, width: 150.0, height: 150.0);
    return Container(child: image);
  }
}
