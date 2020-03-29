import 'package:flutter/material.dart';
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: new Stack(
        children: <Widget>[
          ClipPath(
            child: Container(color: Colors.lightBlue[200].withOpacity(0.8),),
            clipper: getClipper(),
          ),
          Positioned(
            width: 350.0,
            left: 25.0,
            top: MediaQuery.of(context).size.height / 7,
            child: Column(
              children: <Widget> [
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                      image: NetworkImage('https://scontent-mad1-1.xx.fbcdn.net/v/t1.0-9/16196015_10154888128487744_6901111466535510271_n.png?_nc_cat=103&_nc_sid=85a577&_nc_ohc=Lzgz1RIuAd4AX9FoBP7&_nc_ht=scontent-mad1-1.xx&oh=892e609c9eb0df5f1ca268c9aafda4e9&oe=5EA5B597'),
                      fit: BoxFit.contain
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(75.0)
                    ),
                    boxShadow: [
                      BoxShadow(blurRadius: 13.0, color: Colors.black)
                    ]
                  ),
                ),
                SizedBox(
                  height:40.0
                ),
                Text(
                  'Username', 
                  style: TextStyle(
                    fontSize: 30.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Montserrat'
                  ),
                ),
                 SizedBox(
                  height:20.0
                ),
              ]
            )
          )
        ],
      ),
    );
  }
}


class getClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size){
    var path = new Path();
    path.lineTo(0.0, size.height/1.9);
    path.lineTo(size.width + 125, 0.0);
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper){
    return true;
  }
}