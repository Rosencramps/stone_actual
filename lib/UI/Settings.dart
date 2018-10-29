import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './Start&Colors.dart';
import './Help&Support.dart';


class settingPage extends StatefulWidget {
  @override
  _settingPageState createState() => _settingPageState();
}

class _settingPageState extends State<settingPage> with SingleTickerProviderStateMixin {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //rate on app store...
  //help&support -- private policy,terms,reset password, delete account
  //logout
  _emailLogOut() {
    setState(() {
      _auth.signOut();
    });
  }

  @override
  Widget build(BuildContext context) {
    final help = new Container(
        child: new Row(
          children: <Widget>[
            new Icon(
              Icons.help,
              size: 50.0,
              color: Colors.white,
            ),
            new InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => helpSupport()),
                );
              },
              child: new Text(
                ' Help & Support',
                style: new TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'Gelio',
                    color: Colors.white
                ),
              ),
            )
          ],
        )
    );
    final logout = new Container(
        child: new Row(
          children: <Widget>[
            new Icon(
              Icons.launch,
              size: 50.0,
              color: Colors.white,
            ),
            new InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => StoneLogin()),
                );
                _emailLogOut();
              },
              child: new Text(
                ' Logout',
                style: new TextStyle(
                    fontSize: 40.0,
                    fontFamily: 'Gelio',
                    color: Colors.white
                ),
              ),
            )
          ],
        )
    );
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          'Settings',
          style: new TextStyle(
              color: Colors.black,
              fontFamily: 'Gelio',
              fontSize: 40.0
          ),
        ),
        leading: BackButton(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: ListView(
          padding: EdgeInsets.only(left: 24.0, right: 24.0),
          children: <Widget>[
            SizedBox(height: 230.0),
            help,
            SizedBox(height: 50.0),
            logout,
          ],
        ),
      ),
    );
  }
}
