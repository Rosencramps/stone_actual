import 'package:flutter/material.dart';
import 'dart:io';
//import './profile1.dart';
import './Profiles.dart';
import './Settings.dart';
import './MainPage.dart';
import './Start&Colors.dart';
import './LeaderboardPage.dart';
//import './photo.dart';
import 'dart:async';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

var succeed = false;
final FirebaseStorage _storage = FirebaseStorage.instance;
final FirebaseAuth _auth = FirebaseAuth.instance;
int visiblePhotoIndex;

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
  _UserProfilesState createState() => _UserProfilesState();
}

class _UserProfilesState extends State<userProfiles12> {
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
            filter: new ui.ImageFilter.blur(sigmaX: 0.0, sigmaY: 0.0),
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
  _ProfileCardState createState() => _ProfileCardState();
}

class _ProfileCardState extends State<profileCard1> {
  StreamSubscription<QuerySnapshot> subscription;
  StreamSubscription<DocumentSnapshot> userListSubscription;
  List<DocumentSnapshot> photosList;
  List<DocumentSnapshot> userList;
  FirebaseUser user;
  CollectionReference collectionReference;
  Stream<DocumentSnapshot> userReference;


  final String addPhotoUrl = "https://vignette.wikia.nocookie.net/konosuba/images/4/4f/Megumin_1.jpg/revision/latest?cb=20180502131754";
  String name;
  String hasThreePhotos;
  String school;
  String uid;
  bool isLoggedIn;
  int colorPrimary;
  int colorSecondary;
  int timestamp;
  String rank;
  List<String> apples;
  File _image;

  @override
  void initState() {
    super.initState();

    _isUserLoggedIn();

//    if(_auth.currentUser() == null) {
//      var route = new MaterialPageRoute(
//          builder: (BuildContext context) => new userProfiles12(
//          )
//      );
//      Navigator.of(context).push(route);
//    };
//
//    getLists();

    // _currentScreen();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }

  Widget _buildBackground() {
    String selfie;
    String firstPic;
    String secondPic;
    succeed ? selfie = photosList[0].data['selfie'] : selfie = addPhotoUrl;
    succeed ? firstPic = photosList[0].data['firstPhoto'] : firstPic = addPhotoUrl;
    succeed ? secondPic = photosList[0].data['secondaryPhoto'] : secondPic = addPhotoUrl;
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => leaderboard()),
                          );
                        }
                      )
                    ],
                  )),
              new IconButton(
                  icon: new Icon(
                    Icons.graphic_eq,
                    color: Colors.white,
                    size: 40.0,),
                  onPressed: () {
                    var route = new MaterialPageRoute(
                        builder: (BuildContext context) =>
                        new mainPage(school: school,
                            currentUserUid: uid,
                            primaryColorValue: colorPrimary)
                    );
                    Navigator.of(context).push(route);

//                    Navigator.push(
//                      context,
//                      MaterialPageRoute(builder: (context) => mainPage()),
//                    );


                  })

            ],
          ),
        ));
  }

  Widget _rank() {
    return new Container(
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(0.0, 500.0, 0.0, 0.0),
      child:  new ShadowText(succeed ? "$rank" : "",
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
            succeed ? name : "",
            style: new TextStyle(
                color: Colors.white,
                fontFamily: 'Gelio',
                fontSize: 40.0
            ),
          ),
          onTap:
              () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => settingPage()),
            );
          },
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
        onPressed: getImage,
//            () {
//          Navigator.push(
//            context,
//            MaterialPageRoute(builder: (context) => Photos()),
//          );
//        },
      ),
    );
  }

  _timestampDifference() {
    final currentTimestamp = new DateTime.now().millisecondsSinceEpoch;
    int timestampDifference;
    timestampDifference = currentTimestamp - timestamp;

//    print("timestamp diff: $timestampDifference");
//
//    print("hasThreePhotos: $hasThreePhotos");
//
//    print("apples[]   ${apples[0]}, ${apples[1]}, ${apples[2]}");

    if(hasThreePhotos == "no") {
      if(apples[0] == addPhotoUrl || apples[1] == addPhotoUrl || apples[2] == addPhotoUrl) {
        if(timestampDifference >= 0 && timestampDifference <= 86400000) {
          return 'You Have 3 Days To Upload New Photos Or Else You Cannot View Profiles';
        } else if (timestampDifference <= 172800000) {
          return 'You Have 2 Days To Upload New Photos Or Else You Cannot View Profiles';
        } else if (timestampDifference <= 259200000) {
          return 'You Have 1 Day To Upload New Photos Or Else You Cannot View Profiles';
        } else if (timestampDifference <= 345600000) {
          return 'It Is Your Last Day To Upload New Photos Or Else You Cannot View Profiles';
        } else {
          // Todo must add no swiping on users funtionality

          return 'You Must Upload Photos To View Profiles';
        }
      } else {
        updateHasThreePhotos();
        return '';
      }
    } else {
      return '';
    }
  }

  _timestampDifferenceInt() {
    final currentTimestamp = new DateTime.now().millisecondsSinceEpoch;
    int timestampDifference;
    timestampDifference = currentTimestamp - timestamp;

    if(apples[0] != addPhotoUrl && apples[1] != addPhotoUrl && apples[2] != addPhotoUrl) {
      if (timestampDifference > 345600000) {
        return 1;
      } else {
        return 0;
      }
    }
  }


  Widget _uploadPhotosText() {
    return new Container(
      padding: EdgeInsets.fromLTRB(50.0, 00.0, 50.0, 28.0),
      alignment: Alignment.bottomCenter,
      child: new Text(
          succeed ? _timestampDifference() : '',
          textAlign: TextAlign.center,
          style: new TextStyle(
            fontSize: 15.0,
            fontFamily: 'Gelio',
            color: Colors.white,
          )
      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    if(isLoggedIn == true) {
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
                _uploadPhotosText(),
              ],
            ),
          ),
        ),
      );
    } else {
      return new Container(
        child: new Scaffold(
          backgroundColor: Colors.white,
        ),
      );
    }
  }

  void getLists() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
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
        school = datasnapshot.data['school'];
        uid = user.uid;
        hasThreePhotos = datasnapshot.data['hasThreePhotos'];
        colorPrimary = datasnapshot.data['colorPrimary'];
        colorSecondary = datasnapshot.data['colorSecondary'];
        timestamp = datasnapshot.data['timestamp'];
        if(datasnapshot.data['rank'] != null) {
          rank = datasnapshot.data['rank'];
        } else {
          rank = "";
        }

//        print("name : $name");
//        print("colorPrimary : $colorPrimary");
//        print("c0p0r_r8kary : $colorSecondary");
//        print("name : $timestamp");
//        print("name : $rank");
        succeed = true;
      });
    });
  }

  Future getImage() async {

    showDialog(
        context: context,
        builder: (_) =>
        new AlertDialog (
            content: new Text(
              "Upload A New Photo, ",
            ),
            actions: <Widget>[
              new FlatButton (
                child: new Text('Take A Photo'),
                color: Colors.black,
                onPressed: () {
                  getImageCamera();
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Choose One'),
                color: Colors.black,
                onPressed: () {
                  getImageGallery();
                  Navigator.of(context).pop();
                },
              )
            ]
        )
    );

//    setState(() {
//      _image = image;
//    });
//    if(_image != null) {
//      _uploadImageToFirebase();
//    } else {
//      showDialog(
//          context: context,
//          builder: (_) => new AlertDialog(
//              content: new Text(
//                "Your photo got janked up somehow",
//              ),
//              actions: <Widget>[
//                new FlatButton(
//                  child: new Text('Retake it'),
//                  color: Colors.black,
//                  onPressed: () {
//                    Navigator.of(context).pop();
//                  },
//                )
//              ]
//          )
//      );
//    };
  }

  Future getImageCamera() async {
    var cameraImage = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = cameraImage;
    });
    if(_image != null) {
      _uploadImageToFirebase(_image, _timestampDifferenceInt());
    } else {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              content: new Text(
                "Your photo got janked up somehow",
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Retake it'),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]
          )
      );
    }
  }

  Future getImageGallery() async {
    var cameraImage = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = cameraImage;
    });
    if(_image != null) {
      _uploadImageToFirebase(_image, _timestampDifferenceInt());
    } else {
      showDialog(
          context: context,
          builder: (_) => new AlertDialog(
              content: new Text(
                "Your photo got janked up somehow",
              ),
              actions: <Widget>[
                new FlatButton(
                  child: new Text('Retake it'),
                  color: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                )
              ]
          )
      );
    }
  }

  void _isUserLoggedIn() {
    _auth.currentUser().then((value){
      if(value == null) {
        isLoggedIn = false;
        var route = new MaterialPageRoute(
            builder: (BuildContext context) => new StoneLogin(
            )
        );
        Navigator.of(context).push(route);
      } else {
        isLoggedIn = true;
        getLists();
      }
    });
  }

  void updateHasThreePhotos() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    final userReference = Firestore.instance.collection("users");
    final schoolReference = Firestore.instance.collection("schools");

    Map<String, String> usersUidData = <String, String>{
      "hasThreePhotos" : "yes",
    };

    Map<String, String> profileUidData = <String, String>{
      "name" : name,
      "uid" : "${user.uid}",
    };

    Map<String, String> usersPhotosUidData = <String, String>{
      "firstPhoto" : "${apples[1]}",
      "secondaryPhoto" : "${apples[2]}",
      "selfie" : "${apples[0]}",
    };

    userReference.document("${user.uid}").updateData(usersUidData).whenComplete(() {
    }).catchError((e) => print(e));

    schoolReference.document(school).collection("profiles").document("${user.uid}").setData(profileUidData).whenComplete(() {
    }).catchError((e) => print(e));

    schoolReference.document(school).collection("profiles").document("${user.uid}").collection("photos").document("photosDoc").setData(usersPhotosUidData).whenComplete(() {
    }).catchError((e) => print(e));


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
        widget.photoAssetPaths[visiblePhotoIndex] != null ?
        new FadeInImage(
            fit: BoxFit.cover,
            placeholder: new AssetImage('images/StoneLightGrey.png'),
            image: new NetworkImage(widget.photoAssetPaths[visiblePhotoIndex]))
        : new CircularProgressIndicator(),
//        new Image.network(
//          widget.photoAssetPaths[visiblePhotoIndex],
//          fit: BoxFit.cover,
//        ),
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
//      print(i);
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

Future _uploadImageToFirebase(File _image, int timestampExpired) async {
  final userReference = Firestore.instance.collection("users");
  var succeed = true;
  var fileName;
  String photoPath;

  FirebaseUser user = await FirebaseAuth.instance.currentUser();

  if(visiblePhotoIndex == 0) {
    fileName = "PhotoSelfie.jpeg";
    photoPath = "selfie";
  } else if (visiblePhotoIndex == 1) {
    fileName = "FirstPhoto.jpeg";
    photoPath = "firstPhoto";
  } else if (visiblePhotoIndex == 2) {
    fileName = "SecondaryPhoto.jpeg";
    photoPath = "secondaryPhoto";
  }

  StorageUploadTask putFile = _storage.ref().child("userPhotos/${user.uid}/$fileName").putFile(_image);

  putFile.future.catchError((error){
    succeed = false;

  }).then((uploaded) async {
    if(succeed == true) {
      final downloadUrl = await _storage.ref().child('userPhotos').child(user.uid).child('$fileName').getDownloadURL();

      Map<String, String> photoUrl = <String, String>{
        photoPath : "$downloadUrl",
      };

      userReference.document("${user.uid}").collection("photos").document("photosDoc").updateData(photoUrl).whenComplete(() {
      }).catchError((e) => print(e));


      //todo if users have all three photos in a timely manner add to school

      if(timestampExpired == 0 ) {

      }


//      final schoolReference = Firestore.instance.collection("schools");
//
//      schoolReference.document("$happy").collection("profiles").document("${user.uid}").setData(seflieUrl).whenComplete(() {
//        print("Profile Selfie Added");
//      }).catchError((e) => print(e));

    }
  });
}