import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import './MainPage.dart';
import './Start&Colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

final FirebaseAuth _auth = FirebaseAuth.instance;
final GoogleSignIn _googleSignIn = new GoogleSignIn();

class SignUp extends StatefulWidget {
  String value;
  Color primary;
  Color secondary;

  SignUp({Key key, this.value, this.primary, this.secondary}) : super(key: key);
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Color primarySchoolColor;
  Color secondarySchoolColor;
  String happy;
  @override
  Widget build(BuildContext context) {
    final signIn = Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.black,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            primarySchoolColor = widget.primary;
            secondarySchoolColor = widget.secondary;
            happy = widget.value;
            var route = new MaterialPageRoute(
                builder: (BuildContext context) =>
                new photoAdd(value: happy, primary: primarySchoolColor, secondary: secondarySchoolColor,)
            );
            Navigator.of(context).push(route);
          },
          color: widget.secondary,
          child: Text('Sign In',
              style: TextStyle(color: widget.primary)),
        ),
      ),
    );

    final googleSignIn = new Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: 200.0,
        height: 42.0,
        onPressed: () => _gSignIn(),
        color: widget.secondary,
        child: Text('Google Sign In',
            style: TextStyle(color: widget.primary)),
      ),
    );

    final emailSignUp = new Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: 200.0,
        height: 42.0,
        onPressed: () => _emailSignUp(),
        color: widget.secondary,
        child: Text('Sign Up With An Email',
            style: TextStyle(color: widget.primary)),
      ),
    );

    final stoneName = new Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(bottom: 150.0),
      child: new Text(
        'Stone',
        style: new TextStyle(
            fontSize: 120.0,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w800,
            fontFamily: 'Gelio',
            color: widget.secondary
        ),
      ),
    );
    final yourName = TextFormField(
      style: new TextStyle(
        color: Colors.white
      ),
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'First Name',
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final password = TextFormField(
      style: new TextStyle(
        color: Colors.white,
      ),
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          '${widget.value}',
          style: new TextStyle(
              color: widget.primary
          ),
        ),
        leading: BackButton(
          color: widget.primary,
        ),
        backgroundColor: widget.secondary,
      ),
      backgroundColor: widget.primary,
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 100.0),
            stoneName,
            SizedBox(height: 0.0),
            yourName,
            SizedBox(height: 5.0),
            password,
            signIn,
            googleSignIn,
            emailSignUp,
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _gSignIn() async {
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken);

    print('User is: ${user.displayName}');

    return user;
  }

  _emailSignUp() async {

  }

}
class photoAdd extends StatefulWidget {
  String value;
  Color primary;
  Color secondary;

  photoAdd({Key key, this.value, this.primary, this.secondary}) : super(key: key);
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
        style: new TextStyle(
          color: widget.primary,
          fontSize: 40.0
        ),
      ),
    ));
    final addPic = new MaterialButton(
      onPressed: ()
      {
        primarySchoolColor = widget.primary;
        secondarySchoolColor = widget.secondary;
        happy = widget.value;
        var route = new MaterialPageRoute(
            builder: (BuildContext context) =>
            new mainPage(value: happy, primary: primarySchoolColor, secondary: secondarySchoolColor,)
        );
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
          style: new TextStyle(
            color: Colors.white
          ),
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