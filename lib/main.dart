import 'package:flutter/material.dart';
import './UI/Start&Colors.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new StoneLogin(),
    theme: ThemeData(
      primaryColor: Colors.white,
      accentColor: Colors.white,
      hintColor: Colors.white
    ),
  ));
}


