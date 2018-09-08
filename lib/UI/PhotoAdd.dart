import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import './MainPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import './User_Profile.dart';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class photoAdd extends StatefulWidget {
  String value;
  Color primary;
  Color secondary;

//  final FirebaseStorage storage;

  photoAdd({Key key, this.value, this.primary, this.secondary})
      : super(key: key);
  @override
  _photoAddState createState() => _photoAddState();
}

class _photoAddState extends State<photoAdd> {
  Color primarySchoolColor;
  Color secondarySchoolColor;
  String happy;
  File _image;



  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      _image = image;
    });
    if(_image != null) {
      showDialog(
        context: context,
        barrierDismissible: false,
        child: new Center(
          child: new SizedBox(
              width: 40.0,
              height: 40.0,
              child:
              const CircularProgressIndicator(
//                value: null,
                strokeWidth: 2.0,
              )),
        ),
      );

      _uploadImageToFirebase();
//      new Future.delayed(new Duration(seconds: 3), () {
////        Navigator.pop(context); //pop dialog
//      });

    } else {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              content: new Text(
                "Your photo got janked up somehow",
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Retake it'),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]
          )
      );
    };
  }

  Future _uploadImageToFirebase() async {
    final userReference = Firestore.instance.collection("users");
    final schoolReference = Firestore.instance.collection("schools");
    var succeed = true;
    var fileName = "PhotoSelfie.jpeg";

    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    StorageUploadTask putFile = _storage.ref().child("userPhotos/${user.uid}/$fileName").putFile(_image);

    putFile.future.catchError((error){
      succeed = false;
    }).then((uploaded) async {
      if(succeed == true) {
        final downloadUrl = await _storage.ref().child('userPhotos').child(user.uid).child('PhotoSelfie.jpeg').getDownloadURL();

        Map<String, String> seflieUrl = <String, String>{
          "selfie" : "$downloadUrl",
        };

        userReference.document("${user.uid}").collection("photos").document("photosDoc").updateData(seflieUrl).whenComplete(() {
          print("User Selfie Added");
        }).catchError((e) => print(e));

        schoolReference.document("$happy").collection("profiles").document("${user.uid}").setData(seflieUrl).whenComplete(() {
          print("Profile Selfie Added");
        }).catchError((e) => print(e));

        var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
            new profileCard1(value: happy, primary: primarySchoolColor, secondary: secondarySchoolColor,)
        );

        Navigator.of(context).push(route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final image = new Container(
        child: new Center(
          child: new Text(
            "What's Cooking, Good Looking?",
            style: new TextStyle(color: widget.primary, fontSize: 40.0),
          ),
        )
    );

    final addPic = new MaterialButton(
      onPressed: getImage,
      color: widget.primary,
      child: new Text(
        'Add A Selfie',
        style: new TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ),
      ),
    );

    final skipPic = new MaterialButton(
      onPressed: () {
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new userProfiles12(
              value: happy,
              primary: primarySchoolColor,
              secondary: secondarySchoolColor,
            )
        );
        Navigator.of(context).push(route);
      },
      color: widget.primary,
      child: new Text(
        'Give Me A Sec',
        style: new TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ),
      ),
    );

    final selfieWarning = new Container(
      child: Center(
        child: new Text(
          'Non-Selfies Will Not Be Excepted, Fool!',
            style: new TextStyle(
              color: widget.primary,
              fontSize: 13.0,
          )
        ),
      ),
    );

    final nahWarning = new Container(
      child: Center(
        child: new Text(
            'You Must upload a selfie within four days!',
            style: new TextStyle(
              color: widget.primary,
              fontSize: 13.0,
            )
        ),
      ),
    );

    return new Scaffold(
        appBar: new AppBar(
          backgroundColor: widget.primary,
          title: new Text(
            '${widget.value}',
            style: new TextStyle(color: Colors.white),
          ),
          leading: BackButton(
            color: Colors.white,
          ),
        ),
        body: new Center(
            child: new ListView(
              padding: EdgeInsets.only(left: 50.0, right: 50.0),
              children: <Widget>[
                SizedBox(height: 100.0),
                image,
                SizedBox(height: 130.0),
                addPic,
                SizedBox(height: 5.0),
                selfieWarning,
                SizedBox(height: 20.0),
                skipPic,
                SizedBox(height: 5.0),
                nahWarning
              ],
            )));
  }
}