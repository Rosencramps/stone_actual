import 'dart:async';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import '../Logic/CreateUser.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:firebase_storage/firebase_storage.dart';


final FirebaseDatabase _database = FirebaseDatabase.instance;

final List<Profile> demoProfiles = [
//  new Profile(
//    photos: [
//      'images/GodT3.png',
//      'images/GodT2.jpg',
//      'images/GodT1.jpg',
//    ],
//    name: 'God Tongue',
//  ),
//  new Profile(
//    photos: [
//      'images/Rory2.jpg',
//      'images/Rory3.jpg',
//      'images/Rory4.jpg',
//    ],
//    name: 'Rory',
//  ),
  new Profile(
    name: 'pleaseUno?',
    photos: [


    ]

//    photoSelfie: _someMethod(),
//    photoOne: _someMethod(),
//    photoTwo: _someMethod()
  ),
new Profile(
  name: 'pleaseDos?',
    photos: [
//      image as String,
//      image as String,
//      image as String,

],
)];



class Profile {
//  final String photoSelfie;
//  final String photoOne;
//  final String photoTwo;
  final String name;
//  final String photo;
  final List<String> photos;
//  final String url = _url(url: image);

//
//  Profile.fromSnapshot(DataSnapshot snapshot) :
//        name = 'pleaseUno?',
//        photos = snapshot.value["selfie"];
//
//  toJson() {
//    return {
//      "name": name,
//      "photos": photos,
//    };
//  }






  Profile({
//    this.photoSelfie,
//    this.photoOne,
//    this.photoTwo,,
//    this.photo,
    this.name,
    this.photos,
  });
}


//  String _someMethodWhy() {
//  var stringOfUrlsPls = downloadUrl;
//  //final downUri = new Uri.file(_someMethod());
//  return stringOfUrlsPls as String;
//  }
//
//  var urlString;
//  bool done = false;

_someMethod() async {
    final FirebaseDatabase _database = FirebaseDatabase.instance;
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
//    if(done == "0";){
//      _someMethod();
//    } else {
//      _someMethod();
//    };


//  var ref = await _database.reference().child('userPhotos').child(user.uid).child('')

  var ref = await _database.reference().child("users").child(user.uid).child("photos").once().then((DataSnapshot){
    var downloadUrl = DataSnapshot.value['selfie'];
    print(downloadUrl.toString());
    print(downloadUrl as String);
    return downloadUrl as String;
  });



//        .whenComplete((){
//    print("done");
//    done = true;
//    return _someMethodWhy();
//    });

//        .then((bro){
//      final downUri = new Uri.file(bro);
//      print(downUri);
//
//      return downUri;
//    });


//    Future.wait(_someMethod());
//    final downUri = new Uri.file(bro);
//    print(downUri);
//
//    return downUri;


//    final downUri = new Uri.file(downloadUrl);
//
//    _url(url: downUri.toString());
//
//    var data = await FirebaseStorage.instance.ref().child('userPhotos').child(user.uid).child('PhotoSelfie.jpeg').getData(900000000);
//    var text = new String.fromCharCodes(data);
//    print("Data:  $data");
//    print("Text:  $text");
//
//
//    final selfieUrl  = _database.reference().child("users").child(user.uid).child("photos").key;
//
//    print("selfieUrl:  ${selfieUrl}");
//    print("cunt2:  ${downUri}");
//    //downloadUrl = downloadUrl.toString();
////    print(downloadUrl);
////    final urlString = downloadUrl.toString();
////    print(urlString);
//    //return downloadUrl;
//  return "$text";
}

//_url({String url}) {
//  final image = url;
//  return image;
//}
