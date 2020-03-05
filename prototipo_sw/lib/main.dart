import 'package:flutter/material.dart';
import 'package:prototipo_sw/first_screen.dart';
import 'package:prototipo_sw/login.dart';
import 'pantallas.dart';

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
      home: Home(),
    );
  }
}

class Home extends StatefulWidget{

  @override
  State<StatefulWidget> createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {


  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    FavScreen(),
    PlaylistScreen(),
    SearchScreen(),
    ProfileScreen(),
  ];

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
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        backgroundColor: Colors.white,
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
            title: new Text('Favorites'),
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.list),
            title: new Text('Playlists'),
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

