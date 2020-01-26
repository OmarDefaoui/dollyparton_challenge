import 'package:flutter/material.dart';
import 'package:dolly_parton_challenge/ui/screens/HomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Dolly parton challenge",
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
      home: HomeScreen(),
    );
  }
}
