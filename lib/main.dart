import 'package:flutter/material.dart';
import './UI/Settings.dart';
import 'package:stone_actual/UI/User_Profile.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new userProfiles12(),
//    home: new settingPage(),
    theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.white,
        hintColor: Colors.white
    ),
  ));
}