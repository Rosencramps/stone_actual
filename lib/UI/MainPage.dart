import 'package:flutter/material.dart';

class mainPage extends StatefulWidget {
  String value;
  Color primary;
  Color secondary;

  mainPage({Key key, this.value, this.primary, this.secondary}) : super(key: key);
  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: new Scaffold(
        appBar: AppBar(
          backgroundColor: widget.primary,
          title: new Text(
            'Stone Logo',
            style: new TextStyle(
              color: widget.secondary
            ),
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.tag_faces,
                color: widget.secondary,),
                onPressed: null)
          ],
          leading: BackButton(
            color: widget.secondary,
          ),
        ),
      ),
    );
  }
}
