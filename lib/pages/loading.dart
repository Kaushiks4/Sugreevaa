import 'package:flutter/material.dart';
import 'package:sugreeva/pages/mainHome.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 1), () async {
      Navigator.of(context).pop();
      Navigator.push(context, new MaterialPageRoute(
          builder: (context) =>
          new Home())
      );
    });
    return Scaffold(
     backgroundColor: Colors.white,
      body:Center(
        child: Image(
          image: AssetImage('assets/sugreeva.jpg'),
          width: 500.0,
          height: 200.0,
        ),
      ),
    );
  }
}