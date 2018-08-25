import 'package:flutter/material.dart';
//import './profile1.dart';
import './Profiles.dart';
//import './settings.dart';
import './MainPage.dart';
//import './Leaderboard.dart';
//import './photo.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class userProfiles12 extends StatefulWidget {
  final Profile profile;
  String value;
  Color primary;
  Color secondary;


  userProfiles12({
    Key key,
    this.value,
    this.primary,
    this.secondary,
    this.profile,
  }) : super(key: key);
  @override
  _userProfilesState createState() => _userProfilesState();
}

class _userProfilesState extends State<userProfiles12> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.transparent,
      body: profileCard1(),
    );
  }
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

class profileCard1 extends StatefulWidget {
  final Profile profile;
  String value;
  Color primary;
  Color secondary;



  profileCard1({
    Key key,
    this.value,
    this.primary,
    this.secondary,
    this.profile,
  }) : super(key: key);
  @override
  _profileCardState createState() => _profileCardState();
}

class _profileCardState extends State<profileCard1> {
  StreamSubscription<QuerySnapshot> subscription;
  StreamSubscription<DocumentSnapshot> userListSubscription;
  List<DocumentSnapshot> photosList;
  List<DocumentSnapshot> userList;
  FirebaseUser user;
  CollectionReference collectionReference;
  Stream<DocumentSnapshot> userReference;

  var name;
  int colorPrimary;
  int colorSecondary;
  String rank;
  var timestamp;




  @override
  void initState() {
    super.initState();
    getLists();
    // _currentScreen();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }
  Color primarySchoolColor;
  Color secondarySchoolColor;
  String happy;
  Widget _buildBackground() {
    List<String> apples;
    String selfie;
    String firstPic;
    String secondPic;
    selfie = photosList[0].data['selfie'];
    firstPic = photosList[0].data['firstPhoto'];
    secondPic = photosList[0].data['secondaryPhoto'];
    print(selfie);
    print(firstPic);
    print(secondPic);
    apples = [
      selfie,
      firstPic,
      secondPic
    ];

    return new PhotoBrowser(
      photoAssetPaths: apples,
      visiblePhotoIndex: 0,
    );
  }

  Widget _buildProfileSynopsis() {
    return new Positioned(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      new IconButton(
                        icon: new Icon(
                          Icons.equalizer,
                          color: Colors.white,
                          size: 40.0,
                        ),
                        onPressed: null,
//                            () {
//                          Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) => Leaderboard()),
//                          );
//                        },
//                              (){
//                            primarySchoolColor = widget.primary;
//                            secondarySchoolColor = widget.secondary;
//                            happy = widget.value;
//                            var route = new MaterialPageRoute(
//                                builder: (BuildContext context) =>
//                                new Leaderboard(value: happy, primary: primarySchoolColor, secondary: secondarySchoolColor,)
//                            );
//                            Navigator.of(context).push(route);
                        //}
                      )
                    ],
                  )),
              new IconButton(
                  icon: new Icon(
                    Icons.graphic_eq,
                    color: Colors.white,
                    size: 40.0,),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => mainPage()),
                    );
                  })

            ],
          ),
        ));
  }

  Widget _rank() {
    return new Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(0.0, 500.0, 0.0, 0.0),
      child:  new ShadowText('#54',
        style: new TextStyle(
            color: Colors.white.withOpacity(0.25),
            fontSize: 150.0,
            fontFamily: 'Gelio'),),
    );
  }

  Widget _topButton() {
    return new Container(
        padding: EdgeInsets.fromLTRB(10.0, 50.0, 0.0, 0.0),
        alignment: Alignment.topLeft,
        child: new InkWell(
          child: new ShadowText(
            name,
            style: new TextStyle(
                color: Colors.white,
                fontFamily: 'Gelio',
                fontSize: 40.0
            ),
          ),
          onTap: null,
//              () {
//            Navigator.push(
//              context,
//              MaterialPageRoute(builder: (context) => settingPage()),
//            );
//          },
        )
    );
  }
  Widget _topRightButton() {
    return new Container(
      padding: EdgeInsets.fromLTRB(0.0, 45.0, 5.0, 0.0),
      alignment: Alignment.topRight,
      child: new IconButton(
        icon: new Icon(
            Icons.camera_alt,
            color: Colors.white,
            size: 40.0
        ),
        onPressed: null,
//            () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => Photos()),
//          );
//        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: ClipRRect(
        borderRadius: new BorderRadius.circular(5.0),
        child: new Material(
          child: new Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildBackground(),
              _rank(),
              _buildProfileSynopsis(),
              _topButton(),
              _topRightButton(),
            ],
          ),
        ),
      ),
    );
  }

  void getLists() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    print("USER UID: ${user.uid}");
    collectionReference = Firestore.instance.collection("users").document("${user.uid}").collection("photos");
    userReference = Firestore.instance.collection("users").document("${user.uid}").snapshots();

    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        photosList = datasnapshot.documents;
      });
    });

    userListSubscription = userReference.listen((datasnapshot) {
      setState(() {
        name = datasnapshot.data['name'];
        colorPrimary = datasnapshot.data['colorPrimary'];
        colorSecondary = datasnapshot.data['colorSecondary'];
        timestamp = datasnapshot.data['timestamp'];
        if(datasnapshot.data['rank'] != null) {
          rank = datasnapshot.data['rank'];
        } else {
          rank = ">100";
        }
        print("name : $name");
        print("colorPrimary : $colorPrimary");
        print("c0p0r_r8kary : $colorSecondary");
        print("name : $timestamp");
        print("name : $rank");
      });
    });
  }
}

class PhotoBrowser extends StatefulWidget {
  final List<String> photoAssetPaths;
  final int visiblePhotoIndex;

  PhotoBrowser({this.photoAssetPaths, this.visiblePhotoIndex});
  @override
  _PhotoBrowserState createState() => _PhotoBrowserState();
}

class _PhotoBrowserState extends State<PhotoBrowser> {
  int visiblePhotoIndex;

  @override
  void initState() {
    super.initState();
    visiblePhotoIndex = widget.visiblePhotoIndex;
  }

  @override
  void didUpdateWidget(PhotoBrowser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.visiblePhotoIndex != oldWidget.visiblePhotoIndex) {
      setState(() {
        visiblePhotoIndex = widget.visiblePhotoIndex;
      });
    }
  }

  void prevImage() {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex > 0 ? visiblePhotoIndex - 1 : 0;
    });
  }

  void nextImage() {
    setState(() {
      visiblePhotoIndex = visiblePhotoIndex < widget.photoAssetPaths.length - 1
          ? visiblePhotoIndex + 1
          : visiblePhotoIndex;
    });
  }

  Widget _buildPhotoControls() {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new GestureDetector(
          onTap: prevImage,
          child: new FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topLeft,
            child: new Container(
              color: Colors.transparent,
            ),
          ),
        ),
        new GestureDetector(
          onTap: nextImage,
          child: new FractionallySizedBox(
            widthFactor: 0.5,
            heightFactor: 1.0,
            alignment: Alignment.topRight,
            child: new Container(
              color: Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Image.network(
          widget.photoAssetPaths[visiblePhotoIndex],
          fit: BoxFit.cover,
        ),
        new Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: new Container(
            child: new SelectedPhotoIndicator(
              photoCount: widget.photoAssetPaths.length,
              visiblePhotoIndex: visiblePhotoIndex,
            ),
          ),
//          child: new SelectedPhotoIndicator(
//            photoCount: widget.photoAssetPaths.length,
//            visiblePhotoIndex: visiblePhotoIndex,
//          ),
        ),
        _buildPhotoControls(),
      ],
    );
  }
}

class SelectedPhotoIndicator extends StatelessWidget {
  final int photoCount;
  final int visiblePhotoIndex;

  SelectedPhotoIndicator({
    this.photoCount,
    this.visiblePhotoIndex,
  });

  Widget _buildInactiveIndicators() {
    return new Expanded(
        child: new Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: new Container(
            height: 3.0,
            decoration: new BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: new BorderRadius.circular(2.5),
//              boxShadow: [
//                new BoxShadow(
//                  color: const Color(0x22000000),
//                  spreadRadius: 0.0,
//                  blurRadius: 2.0,
//                  offset: const Offset(0.0, 1.0)
//                )
//              ]
            ),
          ),
        ));
  }

  Widget _buildActiveIndicators() {
    return new Expanded(
        child: new Padding(
          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
          child: new Container(
            height: 3.0,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.circular(2.5),
                boxShadow: [
                  new BoxShadow(
                      color: const Color(0x22000000),
                      spreadRadius: 0.0,
                      blurRadius: 2.0,
                      offset: const Offset(0.0, 1.0))
                ]),
          ),
        ));
  }

  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < photoCount; ++i) {
      indicators.add(i == visiblePhotoIndex
          ? _buildActiveIndicators()
          : _buildInactiveIndicators());
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 0.0),
      child: new Row(
        children: _buildIndicators(),
      ),
    );
  }
}
