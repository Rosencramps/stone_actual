import 'dart:math';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import './MainPage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseStorage _storage = FirebaseStorage.instance;

class photoAdd extends StatefulWidget {
  String value;
  Color primary;
  Color secondary;

  final FirebaseStorage storage;

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
      _uploadImageToFirebase();
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
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    var succeed = true;
    var rng = new Random();
    var fileName = "Photo${rng.nextInt(10000)}.jpeg";
    StorageUploadTask putFile =
    _storage.ref().child("userPhotos/${user.uid}/$fileName").putFile(_image);
    putFile.future.catchError((error){
      succeed = false;
    }).then((uploaded){
      if(succeed == true) {
        primarySchoolColor = widget.primary;
        secondarySchoolColor = widget.secondary;
        happy = widget.value;
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new mainPage(
              value: happy,
              primary: primarySchoolColor,
              secondary: secondarySchoolColor,
            )
        );
        Navigator.of(context).push(route);
      };
    });

    UploadTaskSnapshot uploadSnapshot = await putFile.future;

    print("image uploaded");

//    Map<String, dynamic> pictureData = new Map<String, dynamic>();
//    pictureData["url"] = uploadSnapshot.downloadUrl.toString();
//
//
//    DocumentReference collectionReference =
//    Firestore.instance.collection("collection").document(fileName);
//
//    await Firestore.instance.runTransaction((transaction) async {
//      await transaction.set(collectionReference, pictureData);
//      print("instance created");
//    }).catchError(onError);
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
        'Add Selfie',
        style: new TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ),
      ),
    );

    final skipPic = new MaterialButton(
      onPressed: getImage,
      color: widget.primary,
      child: new Text(
        'Add Selfie',
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
                SizedBox(height: 150.0),
                addPic,
                SizedBox(height: 10.0),
                selfieWarning,
              ],
            )));
  }
}
