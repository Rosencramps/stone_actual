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

class _SignUpState extends State<SignUp> with SingleTickerProviderStateMixin{
  Color primarySchoolColor;
  Color secondarySchoolColor;
  String happy;
  AnimationController _controller;
  Animation _animation;
  double jump = 100.0;
  FocusNode _focusNode = FocusNode();
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  final firstNameInput = TextEditingController();
  final sex = TextEditingController();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 60.0, end: 0.0).animate(_controller)
      ..addListener(() {
        setState(() {});
      });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

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
    final googleAndSignUp = Row(
      children: <Widget>[
        new Expanded(
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.black,
                elevation: 5.0,
                child: MaterialButton(
                  minWidth: 300.0,
                  height: 42.0,
                  onPressed: () => _gSignIn(),
                  color: widget.secondary,
                  child: Text('Google Sign In',
                      style: TextStyle(color: widget.primary)),
                ),
              ),
            )),
        new Expanded(
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.black,
                elevation: 5.0,
                child: MaterialButton(
                  minWidth: 40.0,
                  height: 42.0,
                  onPressed: () => _signUp(),
                  color: widget.secondary,
                  child: Text('Sign Up',
                      style: TextStyle(color: widget.primary)),
                ),
              ),
            ))
      ],
    );

    final emailSignOut = new Material(
      borderRadius: BorderRadius.circular(30.0),
      shadowColor: Colors.black,
      elevation: 5.0,
      child: MaterialButton(
        minWidth: 200.0,
        height: 42.0,
        onPressed: () => _gSignLogOut(),
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
      keyboardType: TextInputType.emailAddress,
      focusNode: _focusNode,
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
      focusNode: _focusNode,
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
      body: new InkWell(
        splashColor: widget.secondary,
        onTap: () {
          FocusScope.of(context).requestFocus(FocusNode());
        },
        child: ListView(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: _animation.value),
            stoneName,
            SizedBox(height: 0.0),
            yourName,
            SizedBox(height: 8.0),
            password,
            SizedBox(height: 5.0),
            signIn,
            googleAndSignUp,
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
                "Something is wrong, get it together.",
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

  Future _signUp() async {
//    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
//        email: emailInput.text, password: passwordInput.text)
//        .then((user) {
//      var route = new MaterialPageRoute(
//          builder: (BuildContext context) => new createUser(
//            value: happy,
//            primary: primarySchoolColor,
//            secondary: secondarySchoolColor,
//          ));
//      Navigator.of(context).push(route);
//    }).catchError((error) {
//      showDialog(
//          context: context,
//          builder: (_) => new AlertDialog(
//              content: new Text(
//                "Email is badly formated or in use :/",
//              ),
//              actions: <Widget>[
//                new FlatButton(
//                  child: const Text('God Damn it'),
//                )
//              ]
//          )
//      );
//    });


    primarySchoolColor = widget.primary;
    secondarySchoolColor = widget.secondary;
    happy = widget.value;

    var route = new MaterialPageRoute(
        builder: (BuildContext context) => new createUser(
          value: happy,
          primary: primarySchoolColor,
          secondary: secondarySchoolColor,
        ));
    Navigator.of(context).push(route);
  }

  _gSignLogOut() {
    setState(() {
      _googleSignIn.signOut();
    });
  }

//  _emailSignLogOut() {
//    setState(() {
//      _auth.signOut();
//    });
//  }

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
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<createUser> {
  Color primarySchoolColor;
  Color secondarySchoolColor;
  String happy;
  final emailInput = TextEditingController();
  final passwordInput = TextEditingController();
  final firstNameInput = TextEditingController();
  var sex;
  bool _pressed = false;

  void _buttonPressed(){
    setState(() {
      _pressed = !_pressed;
    });
  }


  @override
  Widget build(BuildContext context) {
    Color mButtonColor = widget.secondary;
    Color fButtonColor = widget.secondary;

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
    final firstName = TextFormField(
      controller: emailInput,
      style: new TextStyle(color: Colors.white),
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'First Name',
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );

    final sexButtons = Row(
      children: <Widget>[
        new Expanded(
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.black,
                elevation: 5.0,
                child: MaterialButton(
                  minWidth: 300.0,
                  height: 42.0,
                  onPressed: () {
                    if(sex != "M") {
                      sex = "M";
                      _buttonPressed();
                    }
                    print("SEX MALE: ${sex}");

                  },
                  color: _pressed ? mButtonColor : mButtonColor.withOpacity(0.3),
                  child: Text('Male',
                      style: TextStyle(color: widget.primary)),
                ),
              ),
            )),
        new Expanded(
            child: Padding(
              padding: EdgeInsets.all(3.0),
              child: Material(
                borderRadius: BorderRadius.circular(30.0),
                shadowColor: Colors.black,
                elevation: 5.0,
                child: MaterialButton(
                  minWidth: 40.0,
                  height: 42.0,
                  onPressed: () {
                    if(sex != "F") {
                      sex = "F";
                      _buttonPressed();
                    }
                    print("SEX FEMALE: ${sex}");
                  },
                  color: _pressed ? fButtonColor.withOpacity(0.3) : fButtonColor,
                  child: Text('Female',
                      style: TextStyle(color: widget.primary)),
                ),
              ),
            ))
      ],
    );

    final continueButton = Padding(
      padding: EdgeInsets.symmetric(vertical: 0.0),
      child: Material(
        borderRadius: BorderRadius.circular(30.0),
        shadowColor: Colors.black,
        elevation: 5.0,
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          onPressed: () {
            //_signInWithEmail();
          },
          color: widget.secondary,
          child: Text('Continue', style: TextStyle(color: widget.primary)),
        ),
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
            firstName,
            SizedBox(height: 5.0),
            sexButtons,
            SizedBox(height: 65.0),
            continueButton
          ],
        ),
      ),
    );
  }

  var firstNameGLobal;
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
