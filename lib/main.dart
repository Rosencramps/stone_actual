import 'package:flutter/material.dart';
import './UI/Start&Colors.dart';
import './UI/User_Profile.dart';
import './iDontGiveAFuck.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_database/firebase_database.dart';
import './UI/MainPage.dart';

void main() {
  runApp(new MaterialApp(
    debugShowCheckedModeBanner: false,
    home: new userProfiles12(),
    theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.white,
        hintColor: Colors.white
    ),
  ));
}