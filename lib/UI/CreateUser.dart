import 'package:flutter/material.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import './PhotoAdd.dart';

final FirebaseDatabase _database = FirebaseDatabase.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;

class createUser extends StatefulWidget {
  String value;
  Color primary;
  Color secondary;
  String email;
  String password;

  createUser({Key key, this.value, this.primary, this.secondary, this.email, this.password})
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
      controller: firstNameInput,
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
            if(firstNameInput.text.length < 2) {
              showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                      content: new Text(
                        "Your name has to be aleast two characters, you slob",
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text('Leave Me Alone?'),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ]
                  )
              );
            } else if(sex != "M" && sex != "F") {
              showDialog(
                  context: context,
                  builder: (_) => new AlertDialog(
                      content: new Text(
                        "I'm a bad programmer, can you please re-select your sex?",
                      ),
                      actions: <Widget>[
                        new FlatButton(
                          child: new Text("Sorry :)"),
                          color: Colors.black,
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        )
                      ]
                  )
              );
            } else {
              _createUser();
            };
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

  Future _createUser() async {
    var succeed = true;
    FirebaseUser user = await _auth.createUserWithEmailAndPassword(
        email: widget.email, password: widget.password).catchError((error){
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              content: new Text(
                "SH*T.. Your email is badly formated OR your email is currently in use.",
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text("Go back and re-evaluate my life."),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]
          )
      );
      succeed = false;
    })
        .then((user) {
          if(succeed == true){
            primarySchoolColor = widget.primary;
            secondarySchoolColor = widget.secondary;
            happy = widget.value;

            user.sendEmailVerification();

            var route = new MaterialPageRoute(
                builder: (BuildContext context) => new photoAdd(
                  value: happy,
                  primary: primarySchoolColor,
                  secondary: secondarySchoolColor,
                )
            );

//      database.reference() .child("school").set({
//        "primary color": primarySchoolColor,
//        "secondary color": secondarySchoolColor,
//      });
            saveUserFirebase();
            Navigator.of(context).push(route);
          };
    })
//        .then((FirebaseUser user) {
//      // upon success, send email verification
//      user.sendEmailVerification();
//    })
 ;
  }

  Future<String> saveUserFirebase() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final timestamp = new DateTime.now().millisecondsSinceEpoch;
    _database.reference() .child("users").update({
      user.uid : ""
    });
    _database.reference().child("users").child(user.uid).set({
      "name" : firstNameInput.text,
      "school" : happy,
      "timestamp" : timestamp
    });
    _database.reference().child("users").child(user.uid).child("happy").set({
      "primaryColor" : primarySchoolColor.value.toString(),
      "secondaryColor" : secondarySchoolColor.value.toString()
    });
  }
}