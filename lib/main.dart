import 'package:flutter/material.dart';
import 'package:photo_maker/ui/screens/HomeScreen.dart';
import 'package:photo_maker/ui/screens/PhotoCreator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dollyparton challenge",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        accentColor: Colors.pink,
        fontFamily: "Montserrat",
        buttonColor: Colors.pink,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.pink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: PhotoCreator(),
    );
  }
}
