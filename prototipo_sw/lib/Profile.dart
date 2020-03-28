import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget{
  var string = 'Profile';
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Center(
          child: Text(string)
      ),
    );
  }
}