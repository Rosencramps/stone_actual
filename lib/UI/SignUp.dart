import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import './MainPage.dart';
import './Start&Colors.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;
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
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  final firstNameInput = TextEditingController();
  final sex = TextEditingController();
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
            _signInWithEmail();
          },
          color: widget.secondary,
          child: Text('Sign In', style: TextStyle(color: widget.primary)),
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
        child: Text('Google Sign In', style: TextStyle(color: widget.primary)),
      ),
    );

    final emailSignUp = new Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: 200.0,
        height: 42.0,
        onPressed: () => _createUser(),
        color: widget.secondary,
        child: Text('Sign Up With An Email',
            style: TextStyle(color: widget.primary)),
      ),
    );

    final emailSignOut = new Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: 200.0,
        height: 42.0,
        onPressed: () => _emailSignLogOut(),
        color: widget.secondary,
        child: Text('email sign out',
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
            color: widget.secondary),
      ),
    );
    final yourName = TextFormField(
      controller: emailInput,
      style: new TextStyle(color: Colors.white),
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final password = TextFormField(
      controller: passwordInput,
      style: new TextStyle(
        color: Colors.white,
      ),
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          '${widget.value}',
          style: new TextStyle(color: widget.primary),
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
            emailSignOut,
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _gSignIn() async {
    var validated = true;

    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken).catchError((error) {
          print("Oops, something went wrong! ${error.toString()}");
          var validated = false;
          showDialog(
              context: context,
              builder: (_) => new AlertDialog(
                  content: new Text(
                    "${error.toString()}",
                  ),
                  actions: <Widget>[
                    new FlatButton(
                      child: const Text('God Damn it'),
                    )
                  ]
              )
          );
    }).then((newUser) {
      if (validated == true) {
        _successfulLogin();
      } else {
        print("User Not Authenticated");
      }
    });



    print('User is: ${user.displayName}');

    return user;
  }

  _signInWithEmail() {
    var validated = true;

    _auth.signInWithEmailAndPassword(
            email: emailInput.text, password: passwordInput.text)
        .catchError((error) {
      print("Oops, something went wrong! ${error.toString()}");
      validated = false;
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              content: new Text(
                "${error.toString()}",
              ),
              actions: <Widget>[
                new FlatButton(
                  child: const Text('God Damn it'),
                )
              ]
          )
      );
    }).then((newUser) {
      if (validated == true) {
        _successfulLogin();
      } else {
        print("User Not Authenticated");
      }
    });
  }

  _successfulLogin() {
    primarySchoolColor = widget.primary;
    secondarySchoolColor = widget.secondary;
    happy = widget.value;
    var route = new MaterialPageRoute(
        builder: (BuildContext context) => new photoAdd(
          value: happy,
          primary: primarySchoolColor,
          secondary: secondarySchoolColor,
        ));
    Navigator.of(context).push(route);

//    database.reference() .child("").set({
//      "firstname": "cunt",
//      "lastname": "hamman",
//      "age": "20"
//    });

  }

  var firstName;
  Future _createUser() async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
            email: emailInput.text, password: passwordInput.text)
        .then((user) {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              content: new Text(
                "Your First Name and sex 8======D",
              ),
              actions: <Widget>[
                new TextFormField(
                  controller: firstNameInput,
                  style: new TextStyle(color: Colors.white),
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'First Name',
                    fillColor: Colors.white,
//                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                )
              ]
          )
      );
      print("Fisrt Name: ${firstNameInput.text}");
      //_signInWithEmail();
    });

  }

//  _gSignLogOut() {
//    setState(() {
//      _googleSignIn.signOut();
//    });
//  }

  _emailSignLogOut() {
    setState(() {
      _auth.signOut();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    emailInput.dispose();
    passwordInput.dispose();
    super.dispose();
  }
}

class createUser extends StatefulWidget {
  String value;
  Color primary;
  Color secondary;

  createUser({Key key, this.value, this.primary, this.secondary})
      : super(key: key);
  @override
  _photoAddState createState() => _photoAddState();
}

class _CreateUserState extends State<SignUp> {
  Color primarySchoolColor;
  Color secondarySchoolColor;
  String happy;
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  final firstNameInput = TextEditingController();
  final sex = TextEditingController();
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
            _signInWithEmail();
          },
          color: widget.secondary,
          child: Text('Sign In', style: TextStyle(color: widget.primary)),
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
        child: Text('Google Sign In', style: TextStyle(color: widget.primary)),
      ),
    );

    final emailSignUp = new Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: 200.0,
        height: 42.0,
        onPressed: () => _createUser(),
        color: widget.secondary,
        child: Text('Sign Up With An Email',
            style: TextStyle(color: widget.primary)),
      ),
    );

    final emailSignOut = new Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: 200.0,
        height: 42.0,
        onPressed: () => _emailSignLogOut(),
        color: widget.secondary,
        child: Text('email sign out',
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
            color: widget.secondary),
      ),
    );
    final yourName = TextFormField(
      controller: emailInput,
      style: new TextStyle(color: Colors.white),
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Email',
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final password = TextFormField(
      controller: passwordInput,
      style: new TextStyle(
        color: Colors.white,
      ),
      autofocus: false,
      obscureText: true,
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    return Scaffold(
      appBar: new AppBar(
        title: new Text(
          '${widget.value}',
          style: new TextStyle(color: widget.primary),
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
            emailSignOut,
          ],
        ),
      ),
    );
  }

  Future<FirebaseUser> _gSignIn() async {
    var validated = true;

    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();

    GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    FirebaseUser user = await _auth.signInWithGoogle(
        idToken: googleSignInAuthentication.idToken,
        accessToken: googleSignInAuthentication.accessToken).catchError((error) {
      print("Oops, something went wrong! ${error.toString()}");
      var validated = false;
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              content: new Text(
                "${error.toString()}",
              ),
              actions: <Widget>[
                new FlatButton(
                  child: const Text('God Damn it'),
                )
              ]
          )
      );
    }).then((newUser) {
      if (validated == true) {
        _successfulLogin();
      } else {
        print("User Not Authenticated");
      }
    });



    print('User is: ${user.displayName}');

    return user;
  }

  _signInWithEmail() {
    var validated = true;

    _auth.signInWithEmailAndPassword(
        email: emailInput.text, password: passwordInput.text)
        .catchError((error) {
      print("Oops, something went wrong! ${error.toString()}");
      validated = false;
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              content: new Text(
                "${error.toString()}",
              ),
              actions: <Widget>[
                new FlatButton(
                  child: const Text('God Damn it'),
                )
              ]
          )
      );
    }).then((newUser) {
      if (validated == true) {
        _successfulLogin();
      } else {
        print("User Not Authenticated");
      }
    });
  }

  _successfulLogin() {
    primarySchoolColor = widget.primary;
    secondarySchoolColor = widget.secondary;
    happy = widget.value;
    var route = new MaterialPageRoute(
        builder: (BuildContext context) => new photoAdd(
          value: happy,
          primary: primarySchoolColor,
          secondary: secondarySchoolColor,
        ));
    Navigator.of(context).push(route);

//    database.reference() .child("").set({
//      "firstname": "cunt",
//      "lastname": "hamman",
//      "age": "20"
//    });

  }

  var firstName;
  Future _createUser() async {
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: emailInput.text, password: passwordInput.text)
        .then((user) {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              content: new Text(
                "Your First Name and sex 8======D",
              ),
              actions: <Widget>[
                new TextFormField(
                  controller: firstNameInput,
                  style: new TextStyle(color: Colors.white),
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText: 'First Name',
                    fillColor: Colors.white,
//                    contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
//                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
                  ),
                )
              ]
          )
      );
      print("Fisrt Name: ${firstNameInput.text}");
      //_signInWithEmail();
    });

  }

//  _gSignLogOut() {
//    setState(() {
//      _googleSignIn.signOut();
//    });
//  }

  _emailSignLogOut() {
    setState(() {
      _auth.signOut();
    });
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    emailInput.dispose();
    passwordInput.dispose();
    super.dispose();
  }
}

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
