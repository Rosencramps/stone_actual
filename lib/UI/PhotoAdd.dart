import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import './MainPage.dart';

class photoAdd extends StatefulWidget {
  String value;
  Color primary;
  Color secondary;

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
  }

  @override
  Widget build(BuildContext context) {
    final image = new Container(
        child: new Center(
          child: new Text(
            "What's Cooking, Good Looking?",
            style: new TextStyle(color: widget.primary, fontSize: 40.0),
          ),
        ));
    final addPic = new MaterialButton(
      onPressed: () {
        primarySchoolColor = widget.primary;
        secondarySchoolColor = widget.secondary;
        happy = widget.value;
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new mainPage(
              value: happy,
              primary: primarySchoolColor,
              secondary: secondarySchoolColor,
            ));
        Navigator.of(context).push(route);
      },
      color: widget.primary,
      child: new Text(
        'Add Selfie',
        style: new TextStyle(
          color: Colors.white,
          fontSize: 15.0,
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
              ],
            )));
  }
}
