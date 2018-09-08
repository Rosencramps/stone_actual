import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class leaderboard extends StatefulWidget {
  final String value;
  final Color primary;
  final Color secondary;

  leaderboard({Key key, this.value, this.primary, this.secondary})
      : super(key: key);
  @override
  _leaderboardState createState() => _leaderboardState();
}

class ShadowText extends StatelessWidget {
  ShadowText(this.data, {this.style}) : assert(data != null);

  final String data;
  final TextStyle style;

  Widget build(BuildContext context) {
    return new ClipRect(
      child: new Stack(
        children: [
          new Positioned(
            top: 2.0,
            left: 2.0,
            child: new Text(
              data,
              style: style.copyWith(color: Colors.black.withOpacity(0.5)),
            ),
          ),
          new BackdropFilter(
            filter: new ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
            child: new Text(data, style: style),
          ),
        ],
      ),
    );
  }
}

class _leaderboardState extends State<leaderboard> {
  StreamSubscription<QuerySnapshot> subscription;
  StreamSubscription<QuerySnapshot> bob;
  List<DocumentSnapshot> boys;
  List<DocumentSnapshot> wallpapersList;
  final CollectionReference collectionReference2 =
  Firestore.instance.collection("boys");
  final CollectionReference collectionReference =
  Firestore.instance.collection("wallpapers");
  Color primarySchoolColor;
  Color secondarySchoolColor;
  String happy;
  bool swipe;

  @override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });
    bob = collectionReference2.snapshots().listen((datasnapshot) {
      setState(() {
        boys = datasnapshot.documents;
      });
    });
  }

  @override
  void dispose() {
    bob?.cancel();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text(
            'The Best of The Best',
            style: new TextStyle(
                fontFamily: 'Gelio',
                fontSize: 30.0,
                //TODO: Add Primary Color From FireBase
                color: Colors.black),
          ),
          leading: new BackButton(
            //TODO: Add Primary Color From FireBase
            color: Color(4290190364),
          ),
          bottom: TabBar(tabs: <Widget>[
            Tab(
                icon: new Image.asset('images/male.png',
                    //TODO: Add Primary Color From FireBase
                    color: Colors.black)),
            Tab(
                icon: new Image.asset(
                  'images/femenine.png',
                  //TODO: Add Primary Color From FireBase
                  color: Colors.black,
                )),
          ]),
          //TODO: Add Secondary Color From FireBase
          backgroundColor: Colors.blueAccent,
        ),
        body: TabBarView(children: [
          new StaggeredGridView.countBuilder(
            padding: const EdgeInsets.all(8.0),
            crossAxisCount: 4,
            itemCount: boys.length,
            itemBuilder: (context, i) {
              String imgPath = boys[i].data['url'];
              int rank = boys[i].data['rank'];
              return new Material(
                elevation: 8.0,
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                child: new InkWell(
                  onTap: null,
                  child: new Hero(
                    tag: imgPath,
                    child: new ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: new Material(
                        child: new Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            new Image.network(
                              imgPath,
                              fit: BoxFit.cover,
                            ),
                            new Positioned(
                                left: 0.0,
                                right: 0.0,
                                bottom: 0.0,
                                child: new Container(
                                  decoration: new BoxDecoration(
                                    gradient: new LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.8),
                                        ]),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Row(
                                    //crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Expanded(
                                          child: new Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              new ShadowText(
                                                '$rank',
                                                style: new TextStyle(
                                                    fontSize: 40.0,
                                                    color: Colors.white,
                                                    fontFamily: 'Gelio'),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (i) =>
            new StaggeredTile.count(2, i.isEven ? 2 : 3),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
          new StaggeredGridView.countBuilder(
            padding: const EdgeInsets.all(8.0),
            crossAxisCount: 4,
            itemCount: wallpapersList.length,
            itemBuilder: (context, i) {
              String imgPath = wallpapersList[i].data['url'];
              int rank = wallpapersList[i].data['rank'];
              return new Material(
                elevation: 8.0,
                borderRadius: new BorderRadius.all(new Radius.circular(8.0)),
                child: new InkWell(
                  onTap: null,
                  child: new Hero(
                    tag: imgPath,
                    child: new ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: new Material(
                        child: new Stack(
                          fit: StackFit.expand,
                          children: <Widget>[
                            new Image.network(
                              imgPath,
                              fit: BoxFit.cover,
                            ),
                            new Positioned(
                                left: 0.0,
                                right: 0.0,
                                bottom: 0.0,
                                child: new Container(
                                  decoration: new BoxDecoration(
                                    gradient: new LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          Colors.transparent,
                                          Colors.black.withOpacity(0.8),
                                        ]),
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: new Row(
                                    //crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisSize: MainAxisSize.max,
                                    children: <Widget>[
                                      new Expanded(
                                          child: new Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                            mainAxisSize: MainAxisSize.max,
                                            children: <Widget>[
                                              new ShadowText(
                                                '$rank',
                                                style: new TextStyle(
                                                    fontSize: 40.0,
                                                    color: Colors.white,
                                                    fontFamily: 'Gelio'),
                                              )
                                            ],
                                          )),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            staggeredTileBuilder: (i) =>
            new StaggeredTile.count(2, i.isEven ? 2 : 3),
            mainAxisSpacing: 8.0,
            crossAxisSpacing: 8.0,
          ),
        ]),
        //TODO: Add Primary Color From FireBase
        backgroundColor: Color(4290190364),
      ),
    );
  }
}

