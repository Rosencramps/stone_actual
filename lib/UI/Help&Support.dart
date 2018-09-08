import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class helpSupport extends StatefulWidget {
  @override
  _helpSupportState createState() => _helpSupportState();
}

class _helpSupportState extends State<helpSupport> {
  @override
  Widget build(BuildContext context) {
    final terms = new Container(
      child: new Row(
          children: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.color_lens,
                size: 36.0,
                color: Colors.white,
              ),
              onPressed: null,
            ),
            new InkWell(
              child: new Text(
                '  Terms and Conditions',
                style: new TextStyle(
                    fontSize: 28.5,
                    fontFamily: 'Gelio',
                    color: Colors.white),
              ),
            )
          ]
      ),
    );
    final private = new Container(
      child: new Row(
          children: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.style,
                size: 36.0,
                color: Colors.white,
              ),
              onPressed: null,
            ),
            new InkWell(
              onTap: () {
                launch('https://termsfeed.com/privacy-policy/82297978c6805adec572a51e13a5df2a');
              },
              child: new Text(
                '  Private Policy',
                style: new TextStyle(
                    fontSize: 28.5,
                    fontFamily: 'Gelio',
                    color: Colors.white),
              ),
            )
          ]
      ),
    );
    final nameChange = new Container(
      child: new Row(
          children: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.add_shopping_cart,
                size: 36.0,
                color: Colors.white,
              ),
              onPressed: null,
            ),
            new InkWell(
              child: new Text(
                '  Change Name',
                style: new TextStyle(
                    fontSize: 28.5,
                    fontFamily: 'Gelio',
                    color: Colors.white),
              ),
            )
          ]
      ),
    );
    final delete = new Container(
      child: new Row(
          children: <Widget>[
            new IconButton(
              icon: new Icon(
                Icons.airline_seat_legroom_extra,
                size: 36.0,
                color: Colors.white,
              ),
              onPressed: null,
            ),
            new InkWell(
              child: new Text(
                '  Delete Account',
                style: new TextStyle(
                    fontSize: 28.5,
                    fontFamily: 'Gelio',
                    color: Colors.white),
              ),
            )
          ]
      ),
    );
    return Scaffold(
      appBar: AppBar(
        title: new Text(
          'Help and Support',
          style: new TextStyle(
              color: Colors.black,
              fontFamily: 'Gelio',
              fontSize: 32.0
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
            SizedBox(height: 50.0),
            terms,
            SizedBox(height: 50.0),
            private,
            SizedBox(height: 50.0),
            nameChange,
            SizedBox(height: 50.0),
            delete
          ],
        ),
      ),
    );
  }
}
