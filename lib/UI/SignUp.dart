import 'package:flutter/material.dart';
import 'dart:async';
import './PhotoAdd.dart';
import './CreateUser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

final FirebaseDatabase database = FirebaseDatabase.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

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
  FocusNode _focusEmail = FocusNode();
  FocusNode _focusPassword = FocusNode();
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

    _focusEmail.addListener(() {
      if (_focusEmail.hasFocus) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
    _focusPassword.addListener(() {
      if (_focusPassword.hasFocus) {
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
                  onPressed: (){},
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
        onPressed: () => _emailLogOut(),
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
      focusNode: _focusEmail,
      controller: emailInput,
      style: new TextStyle(color: Colors.white),
      autofocus: false,
      decoration: InputDecoration(
        hintText: 'Your School Email',
        fillColor: Colors.white,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
      ),
    );
    final password = TextFormField(
      focusNode: _focusPassword,
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
                "Something is wrong, get it together",
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Damn it'),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]
          )
      );
    }).then((newUser) {
      if (validated == true && newUser.isEmailVerified) {
        _successfulLogin();
      } else {
        print("User Not Authenticated");
        showDialog(
            context: context,
            builder: (_) => new AlertDialog(
                content: new Text(
                  "Verifiy your email you lazy scum",
                ),
                actions: <Widget>[
                  new FlatButton(
                    child: new Text('Leave me alone.'),
                    color: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )
                ]
            )
        );
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

  if(emailInput.text.contains('.edu') && passwordInput.text.length >= 6){
    primarySchoolColor = widget.primary;
    secondarySchoolColor = widget.secondary;
    happy = widget.value;

    var route = new MaterialPageRoute(
        builder: (BuildContext context) => new createUser(
          value: happy,
          primary: primarySchoolColor,
          secondary: secondarySchoolColor,
          email: emailInput.text,
          password: passwordInput.text,
        ));
    Navigator.of(context).push(route);
  } else {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
            content: new Text(
              "Type in your SCHOOL email and your password has to be atleast "
                  "six characters, you nerd.",
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("I can't do anything right."),
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

  _emailLogOut() {
    setState(() {
      _auth.signOut();
    });
  }

//  @override
//  void dispose() {
//    // Clean up the controller when the Widget is disposed
////    emailInput.dispose();
////    passwordInput.dispose();
//    super.dispose();
//  }
}

