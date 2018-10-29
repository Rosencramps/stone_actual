import 'dart:async';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import './Matches.dart';
import './User_Profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';



int uidCount = 0;
final String addPhotoUrl = "https://vignette.wikia.nocookie.net/konosuba/images/4/4f/Megumin_1.jpg/revision/latest?cb=20180502131754";
bool succeed1 = false;
String jojo = 'blah';
String firstPic = 'firstPic';
String secondaryPic = 'secondPic';
String selfie = 'selfie';
List<DocumentSnapshot> photosList;

final MatchEngine matchEngine = new MatchEngine(
  matches: Profiles.map((mainPage profile) {
    return new DateMatch(profile: profile);
  }).toList(),
);

class User {
  const User(
      {this.username,
        this.id,
        this.photoUrl,
        this.email,
        this.displayName,
        this.bio,
        this.followers,
        this.following});

  final String email;
  final String id;
  final String photoUrl;
  final String username;
  final String displayName;
  final String bio;
  final Map followers;
  final Map following;

  factory User.fromDocument(DocumentSnapshot document) {
    return new User(
      email: document['email'],
      username: document['username'],
      photoUrl: document['photoUrl'],
      id: document.documentID,
      displayName: document['displayName'],
      bio: document['bio'],
      followers: document['followers'],
      following: document['following'],
    );
  }
}
class CardStack extends StatefulWidget {
  final MatchEngine matchEngine;
  String value;
  Color primary;
  Color secondary;

  CardStack(
      {Key key, this.value, this.primary, this.secondary, this.matchEngine})
      : super(key: key);

  @override
  _CardStackState createState() => _CardStackState();
}

class _CardStackState extends State<CardStack> {
  Key _frontCard;
  DateMatch _currentMatch;
  double _nextCardScale = 0.9;
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;
  final CollectionReference collectionReference =
  Firestore.instance.collection("wallpapers");

  final DocumentReference documentReference =
  Firestore.instance.document("wallpapers/D93JTZ9NfIGWGKLhFBxe");

  @override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });
    widget.matchEngine.addListener(_onMatchEngineChange);

    _currentMatch = widget.matchEngine.currentMatch;
    _currentMatch.addListener(_onMatchEngineChange);

    _frontCard = new Key(_currentMatch.profile.uid);
  }

  @override
  void didUpdateWidget(CardStack oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.matchEngine != oldWidget.matchEngine) {
      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
      widget.matchEngine.addListener(_onMatchEngineChange);

      if (_currentMatch != null) {
        _currentMatch.removeListener(_onMatchChange);
      }
      _currentMatch = widget.matchEngine.currentMatch;
      if (_currentMatch != null) {
        _currentMatch.addListener(_onMatchChange);
      }
    }
  }

  @override
  void dispose() {
    if (_currentMatch != null) {
      _currentMatch.removeListener(_onMatchChange);
    }
    subscription?.cancel();

    //widget.matchEngine.removeListener(_onMatchEngine);
    super.dispose();
  }

  void _onMatchEngineChange() {
    setState(() {
      if (_currentMatch != null) {
        _currentMatch.removeListener(_onMatchChange);
      }
      _currentMatch = widget.matchEngine.currentMatch;
      if (_currentMatch != null) {
        _currentMatch.addListener(_onMatchChange);
      }

      _frontCard = Key(_currentMatch.profile.uid);
    });
  }

  void _onMatchChange() {
    setState(() {});
  }

  Widget _buildBackCard() {
    return new Transform(
      transform: new Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
      alignment: Alignment.center,
      child: new profileCard(
        primary: widget.primary,
        secondary: widget.secondary,
        value: widget.value,
        mainpage: widget.matchEngine.nextMatch.profile,
      ),
    );
  }

  Widget _buildFrontCard() {
    return new profileCard(
      key: _frontCard,
      mainpage: widget.matchEngine.currentMatch.profile,
    );
  }

  SlideDirection _desiredSlideOutDirection() {
    switch (widget.matchEngine.currentMatch.decision) {
      case Decision.nope:
        return SlideDirection.left;
      case Decision.like:
        wallpapersList[0].data['nope'] = false;
        return SlideDirection.right;
      default:
        return null;
    }
  }

  void _onSlideUpdate(double distance) {
    setState(() {
      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
    });
  }

  void _onSlideOutComplete(SlideDirection direction) {
    DateMatch currentMatch = widget.matchEngine.currentMatch;

    switch (direction) {
      case SlideDirection.left:
        currentMatch.nope();
        break;
      case SlideDirection.right:
        currentMatch.like();
        break;
      default:
        break;
    }

    widget.matchEngine.cycleMatch();
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      children: <Widget>[
        new DraggableCard(
          card: _buildBackCard(),
          isDraggable: false,
        ),
        new DraggableCard(
          card: _buildBackCard(),
          isDraggable: false,
        ),
        new DraggableCard(
          card: _buildBackCard(),
          isDraggable: false,
        ),
        new DraggableCard(
          card: _buildFrontCard(),
          slideTo: _desiredSlideOutDirection(),
          onSlideUpdate: _onSlideUpdate,
          onSlideOutComplete: _onSlideOutComplete,
        ),
      ],
    );
  }
}


enum SlideDirection {
  left,
  right,
  up,
}

class DraggableCard extends StatefulWidget {
  final Widget card;
  final bool isDraggable;
  final SlideDirection slideTo;
  final Function(double distance) onSlideUpdate;
  final Function(SlideDirection direction) onSlideOutComplete;

  DraggableCard({
    this.card,
    this.isDraggable = true,
    this.slideTo,
    this.onSlideUpdate,
    this.onSlideOutComplete,
  });
  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard>
    with TickerProviderStateMixin {
  Offset cardOffset = const Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPostion;
  Offset slideBackStart;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;
  SlideDirection slideOutDirection;
  int x = 0;
  Decision decision;
  GlobalKey profileCardKey = new GlobalKey(debugLabel: 'profile_card_key');
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;




  final DocumentReference documentReference =
  Firestore.instance.document("wallpapers/cJ13M7GXEkHbeBw8sMdp");

  final CollectionReference collectionReference =
  Firestore.instance.collection("wallpapers");



  @override
  void initState() {
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });
    slideBackAnimation = new AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() => setState(() {
        cardOffset = Offset.lerp(slideBackStart, const Offset(0.0, 0.0),
            Curves.elasticOut.transform(slideBackAnimation.value));

        if (null != widget.onSlideUpdate) {
          widget.onSlideUpdate(cardOffset.distance);
        }
      }))
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          dragStart = null;
          slideBackStart = null;
          dragPostion = null;
        }
      });

    slideOutAnimation = new AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    )
      ..addListener(() {
        setState(() {
          cardOffset = slideOutTween.evaluate(slideOutAnimation);

          if (null != widget.onSlideUpdate) {
            widget.onSlideUpdate(cardOffset.distance);
          }
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            dragStart = null;
            dragPostion = null;
            slideOutTween = null;

            if (widget.onSlideOutComplete != null) {
              widget.onSlideOutComplete(slideOutDirection);
            }
          });
        }
      });
  }

  @override
  void didUpdateWidget(DraggableCard oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.card.key != oldWidget.card.key) {
      cardOffset = const Offset(0.0, 0.0);
    }

    if (oldWidget.slideTo == null && widget.slideTo != null) {
      switch (widget.slideTo) {
        case SlideDirection.left:
          _slideLeft();
          break;
        case SlideDirection.right:
          _slideRight();
          break;
        default:
          break;
      }
    }
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();
    subscription?.cancel();
    super.dispose();
  }

//  void _onMatchChange() {
//    if(widget.match.decision != decision) {
//      switch (widget.match.decision) {
//        case Decision.nope:
//          _slideLeft();
//          break;
//        case Decision.like:
//          _slideRight();
//          break;
//        default:
//          break;
//      }
//    }
//
//    decision = widget.match.decision;
//  }


  Offset _chooseRandomDragStart() {
    final cardContext = profileCardKey.currentContext;
    final cardTopLeft = (cardContext.findRenderObject() as RenderBox)
        .localToGlobal(const Offset(0.0, 0.0));
    final dragStartY = cardContext.size.height *
        (new Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
        cardTopLeft.dy;
    return new Offset(cardContext.size.width / 2 + cardTopLeft.dx, dragStartY);
  }

  void _slideLeft() async {
    final screenWidth = context.size.width;
    dragStart = _chooseRandomDragStart();
    slideOutTween = new Tween(
        begin: const Offset(0.0, 0.0), end: new Offset(-2 * screenWidth, 0.0));
    slideOutAnimation.forward(from: 0.0);
  }

  void _slideRight() async {
    final screenWidth = context.size.width;
    dragStart = _chooseRandomDragStart();
    slideOutTween = new Tween(
        begin: const Offset(0.0, 0.0), end: new Offset(2 * screenWidth, 0.0));
    slideOutAnimation.forward(from: 0.0);
  }

  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;

    if (slideBackAnimation.isAnimating) {
      slideBackAnimation.stop(canceled: true);
    }
  }

  void _onPanUpdate(DragUpdateDetails details) {
    setState(() {
      dragPostion = details.globalPosition;
      cardOffset = dragPostion - dragStart;

      if (null != widget.onSlideUpdate) {
        widget.onSlideUpdate(cardOffset.distance);
      }
    });
  }

  Widget _buildCards() {

  }

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;
    final isInNopeRegion = (cardOffset.dx / context.size.width) < - 0.45;
    final isInLikeRegion = (cardOffset.dx / context.size.width) > 0.45;


    Map<String, bool> data = <String, bool>{'nope': false};
    documentReference.updateData(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));

    print('isInNopeRegion: $isInNopeRegion');
    print('isInLikeRegion: $isInLikeRegion');

    setState(() {
      if (isInNopeRegion || isInLikeRegion) {
        slideOutTween = new Tween(
            begin: cardOffset, end: dragVector * (2 * context.size.width));
        slideOutAnimation.forward(from: 0.0);

        slideOutDirection =
        isInNopeRegion ? SlideDirection.left : SlideDirection.right;
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new Transform(
      transform:
      new Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0),
      child: new Container(
        key: profileCardKey,
        child: new GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: widget.card,
        ),
      ),
    );
  }
}

//  @override
//  Widget build(BuildContext context) {
//    return new AnchoredOverlay(
//      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor){
//     child: new Transform(
//        transform: new Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
//          ..rotateZ(_rotation(anchorBounds)),
//      origin: _rotationOrigin(anchorBounds),
//      child: new GestureDetector(
//      onPanStart: _onPanStart,
//      onPanUpdate: _onPanUpdate,
//      onPanEnd: _onPanEnd,
//      child: profileCard(),
//        ));});
//  }
//}



class mainPage extends StatefulWidget {
  String value;
  Color primary;
  Color secondary;
  String name;
  List<String> url;
  String gohan;
  String uid;


  mainPage({Key key, this.value, this.name, this.primary, this.secondary,this.url,this.gohan,this.uid})
      : super(key: key);
  @override
  _mainPageState createState() => _mainPageState();
}

class _mainPageState extends State<mainPage> {
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> userList;
  FirebaseUser user;
  CollectionReference collectionReference;
  Stream<DocumentSnapshot> userReference;
  String jose;


  final String addPhotoUrl = "https://orig00.deviantart.net/7935/f/2017/178/0/b/demon_rem_by_nocturnbros-dbe7ohh.png";
  var name;
  int colorPrimary;
  int colorSecondary;
  int timestamp;
  int rank;
  List<String> apples;
  File _image;

  @override
  void initState() {
    super.initState();
    setupUidList();
    setState(() {
//      jojo = 'https://orig00.deviantart.net/7935/f/2017/178/0/b/demon_rem_by_nocturnbros-dbe7ohh.png';
    });
    // _currentScreen();
  }

//   gohan() {
//    setState(() {
//      succeed ? naruto = photosList[0].data['selfie'] : naruto =  addPhotoUrl;
//    });
//    print(naruto);
//  }





  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }



  void setupUidList() async {

    final prefs = await SharedPreferences.getInstance();
    final prefGender = prefs.getString('PrefGender') ?? " ";

    List<DocumentSnapshot> wallpapersList;
    final userReference = Firestore.instance.collection("users").document(prefGender).collection("profiles");
//  List<DocumentSnapshot> wallpapersList;

//    print("here?1");
    userReference.snapshots().listen((datasnapshot) {
//        print("here?2");
      wallpapersList = datasnapshot.documents;
//        print("here?3");
      for(int i = 0; i <= wallpapersList.length; i++) {
        uidCount = i;

        print("people ${wallpapersList}");
        print("people length ${wallpapersList.length}");
        String uid = wallpapersList[i].documentID;



        getUrlLists(uid, prefGender);

      }
    });
  }


  void getUrlLists(String uid, String prefGender) async {
    final userReference = Firestore.instance.collection("users").document(prefGender).collection("profiles");
    List<DocumentSnapshot> uidPhotos;
    collectionReference = Firestore.instance.collection("users").document(prefGender).collection("profiles").document(uid).collection("photos");
    final currentUserReference = userReference.document("$uid").snapshots();

    currentUserReference.listen((dataSnapshot) {
      setState(() {
        name = dataSnapshot.data['name'];
      });
    });
    collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        uidPhotos = datasnapshot.documents;
        photosList = datasnapshot.documents;
        succeed = true;
        addProfile(uidPhotos, uid, name);
      });
    });
  }


  @override
  Widget build(BuildContext context) {

      selfie = photosList[0].data['selfie'];
      firstPic = photosList[0].data['firstPhoto'];
      secondaryPic = photosList[0].data['secondaryPhoto'];

//    addProfile();
    return new Scaffold(
      backgroundColor: widget.primary,
      body: CardStack(
        matchEngine: matchEngine,
      ),
    );
  }
}
//
//class ShadowText extends StatelessWidget {
//  ShadowText(this.data, {this.style}) : assert(data != null);
//
//  final String data;
//  final TextStyle style;
//
//  Widget build(BuildContext context) {
//    return new ClipRect(
//      child: new Stack(
//        children: [
//          new Positioned(
//            top: 2.0,
//            left: 2.0,
//            child: new Text(
//              data,
//              style: style.copyWith(color: Colors.black.withOpacity(0.5)),
//            ),
//          ),
//          new BackdropFilter(
//            filter: new ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
//            child: new Text(data, style: style),
//          ),
//        ],
//      ),
//    );
//  }
//}





addProfile(List<DocumentSnapshot> urls, String uid, String name){

//  succeed ? print("yea right bub") : print("aye");

print("urls ${urls[0].data["selfie"]} ${urls[0].data["firstPhoto"]} ${urls[0].data["secondaryPhoto"]}");

  Profiles.add(
    new mainPage(
      url: [
        urls[0].data["selfie"],
        urls[0].data["firstPhoto"],
        urls[0].data["secondaryPhoto"]
      ],
      name: name,
//      'Rem ${urls[0].data["selfie"]}',
      uid: uid,
    ),
  );
  print("UID : $uid");
  succeed ? print("yea right bub") : print("aye");
}




final List<mainPage> Profiles = [
//  new mainPage(
//    url: [
//      'https://static.zerochan.net/Eucliwood.Hellscythe.full.1182233.jpg',
//    ],
//    firstpic: 'maxwell',
//  ),
//  new mainPage(
//    url: [
//      'https://static.zerochan.net/Eucliwood.Hellscythe.full.1182233.jpg',
//    ],
//    firstpic: 'mark',
//  ),
];



class butthole{
  List<String> url;
  butthole({
    this.url

  });
}

final List<butthole> or = [
  new butthole(
      url: [
        'http://pm1.narvii.com/5889/714f57498fcf7cd7cc07c57cfd6eb7c6eaaa6f30_00.jpg'
      ]
  )
];


class profileCard extends StatefulWidget {
  final Profile profile;
  final profileCard profilecard;
  final mainPage mainpage;
  final butthole butt;
  String name;
  String value;
  Color primary;
  Color secondary;
  List<String> uid;
  List<String> image;
//  final List<mainPage> john = [
//    new mainPage(
//      url: [
//        'http://pm1.narvii.com/5889/714f57498fcf7cd7cc07c57cfd6eb7c6eaaa6f30_00.jpg',
//      ],
//      firstpic: 'maxwell',
//    ),
//    new mainPage(
//      url: [
//        'http://pm1.narvii.com/5889/714f57498fcf7cd7cc07c57cfd6eb7c6eaaa6f30_00.jpg',
//      ],
//      firstpic: 'mark',
//    ),
//  ];
////  final DataSnapshot messageSnapshot;
  bool swipe;



  profileCard({
    Key key,
    this.butt,
    this.mainpage,
    this.name,
    this.profilecard,
    this.image,
//    this.messageSnapshot,
    this.value,
    this.primary,
    this.secondary,
    this.profile,
    this.uid,
  }) : super(key: key);
  @override
  _profileCardState createState() => _profileCardState();
}


class _profileCardState extends State<profileCard> {
  StreamSubscription<QuerySnapshot> subscription;
  StreamSubscription<DocumentSnapshot> userListSubscription;
  List<DocumentSnapshot> userList;
  FirebaseUser user;
  CollectionReference collectionReference;
  Stream<DocumentSnapshot> userReference;

  StreamSubscription<QuerySnapshot> yup;
  List<DocumentSnapshot> wallpapersList;
  Color primarySchoolColor;
  Color secondarySchoolColor;
  String happy;
  bool swipe;
//  BannerAd _bannerAd;
  List<DocumentSnapshot> users;
  final Query uids = Firestore.instance.collection('users');

//  static final MobileAdTargetingInfo targetInfo = new MobileAdTargetingInfo(
//    testDevices: <String>[],
//    keywords: <String>['wallpapers', 'walls', 'amoled'],
//    birthday: new DateTime.now(),
//    childDirected: true,
//  );
//  BannerAd createBannerAd() {
//    return new BannerAd(
//        adUnitId: BannerAd.testAdUnitId,
//        size: AdSize.banner,
//        targetingInfo: targetInfo,
//        listener: (MobileAdEvent event) {
//          print("Banner event : $event");
//        });
//  }


  final String addPhotoUrl = "https://vignette.wikia.nocookie.net/fairytail/images/7/75/Armadura_Fairy.PNG/revision/latest?cb=20130303202008";
  var name;
  int colorPrimary;
  int colorSecondary;
  int timestamp;
  int rank;
  List<String> apples;
  File _image;

  @override
  void initState() {
    super.initState();
//    getLists();
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
      photoAssetPaths: widget.mainpage.url,
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
          padding: const EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 100.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new IconButton(
                          icon: new Icon(
                            Icons.bubble_chart,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            primarySchoolColor = widget.primary;
                            secondarySchoolColor = widget.secondary;
                            happy = widget.value;
                            var route = new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new userProfiles12(
                                  value: happy,
                                  primary: primarySchoolColor,
                                  secondary: secondarySchoolColor,
                                ));
                            Navigator.of(context).push(route);
                          })
                    ],
                  )),
              new InkWell(
                  child: new ShadowText(
                    widget.mainpage.name,
                    style: new TextStyle(
                        fontSize: 50.0, color: Colors.white, fontFamily: 'Gelio'),
                  )),
            ],
          ),
        ));
  }

  void getLists() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    collectionReference = Firestore.instance.collection("users").document('GXQcT3ieH7f8BRInbHW2YAymazI3').collection("photos");
    userReference = Firestore.instance.collection("users").document("GXQcT3ieH7f8BRInbHW2YAymazI3").snapshots();

    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        photosList = datasnapshot.documents;
        succeed = true;
      });
    });

//    userListSubscription = userReference.listen((datasnapshot) {
//      setState(() {
//        name = datasnapshot.data['name'];
//        colorPrimary = datasnapshot.data['colorPrimary'];
//        colorSecondary = datasnapshot.data['colorSecondary'];
//        timestamp = datasnapshot.data['timestamp'];
//        if(datasnapshot.data['rank'] != null) {
//          rank = datasnapshot.data['rank'];
//        } else {
//          rank = 0;
//        }
//        print("name : $name");
//        print("colorPrimary : $colorPrimary");
//        print("c0p0r_r8kary : $colorSecondary");
//        print("name : $timestamp");
//        print("name : $rank");
//        succeed = true;
//      });
//    });
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
              _buildProfileSynopsis(),
            ],
          ),
        ),
      ),
    );
  }
}

class PhotoBrowser extends StatefulWidget {
  final List<String> photoAssetPaths;
  final String firstPic;
  final String secondPic;
  final int visiblePhotoIndex;
  final mainPage firstpic;
  final profileCard pop;
//  final DataSnapshot messageSnapshot;

  PhotoBrowser(
      {this.photoAssetPaths,
//      this.messageSnapshot,
        this.firstpic,
        this.firstPic,
        this.secondPic,
        this.visiblePhotoIndex,
        this.pop});
  @override
  _PhotoBrowserState createState() => _PhotoBrowserState();
}

class _PhotoBrowserState extends State<PhotoBrowser> {
  //StorageReference reference = FirebaseDatabase.instance.reference().child('users');
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;
  final CollectionReference collectionReference =
  Firestore.instance.collection("wallpapers");


  int visiblePhotoIndex;

  @override
  void initState() {
    super.initState();
    visiblePhotoIndex = widget.visiblePhotoIndex;
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });
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
//        new Hero(
//            tag: widget.photoAssetPaths,
//            child: new FadeInImage(
//              placeholder: new AssetImage("images/StoneLightGrey.png"),
//              image: new NetworkImage(widget.photoAssetPaths[visiblePhotoIndex] ?? ''),
//              fit: BoxFit.cover,
//            )
//        ),

        new CachedNetworkImage(
          imageUrl: widget.photoAssetPaths[visiblePhotoIndex],
          fit: BoxFit.cover,
        ),

        new Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: new Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                    ])),
            child: new SelectedPhotoIndicator(
              photoCount: widget.photoAssetPaths.length,
              visiblePhotoIndex: visiblePhotoIndex,
            ),
          ),
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

class Profile extends StatefulWidget {
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;
  CollectionReference collectionReference;
  List<String> photos;
  String name;
  String image;

  Profile({
    this.photos,
    this.name,
    this.collectionReference
  });
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}







































































































//import 'dart:async';
//
//import 'package:firebase_auth/firebase_auth.dart';
//import 'package:flutter/material.dart';
//import 'dart:math';
//import 'package:stone_actual/UI/profiles.dart';
//import './matches.dart';
//import './User_Profile.dart';
//import 'package:firebase_database/firebase_database.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';
//
//String currentSchool;
//int uidCount = 0;
//int photosListLength;
//
//final MatchEngine matchEngine = new MatchEngine(
//  matches: demoProfiles?.map((Profile profile) {
//    return new DateMatch(profile: profile);
//  })?.toList() ?? [],
//);
//
//
//
//class CardStack extends StatefulWidget {
//  final MatchEngine matchEngine;
//  Profile profile;
//  String value;
//  String school;
//  String currentUserUid;
//  Color primary;
//  Color secondary;
//
//  CardStack({Key key, this.school, this.profile, this.currentUserUid, this.matchEngine})
//      : super(key: key);
//
//  @override
//  _CardStackState createState() => _CardStackState();
//}
//
//class _CardStackState extends State<CardStack> {
//  Key _frontCard;
//  DateMatch _currentMatch;
//  double _nextCardScale = 0.9;
//
//
//  @override
//  void initState() {
//    super.initState();
//
//    widget.matchEngine.addListener(_onMatchEngineChange);
//
//    _currentMatch = widget.matchEngine.currentMatch;
//    _currentMatch.addListener(_onMatchEngineChange);
//
//    _frontCard = new Key(_currentMatch.profile.name);
//  }
//
//  @override
//  void didUpdateWidget(CardStack oldWidget) {
//    super.didUpdateWidget(oldWidget);
//
//    if (widget.matchEngine != oldWidget.matchEngine) {
//      oldWidget.matchEngine.removeListener(_onMatchEngineChange);
//      widget.matchEngine.addListener(_onMatchEngineChange);
//      if (_currentMatch != null) {
//        _currentMatch.removeListener(_onMatchChange);
//      }
//      _currentMatch = widget.matchEngine.currentMatch;
//      if (_currentMatch != null) {
//        _currentMatch.addListener(_onMatchChange);
//      }
//    }
//  }
//
//  @override
//  void dispose() {
//    if (_currentMatch != null) {
//      _currentMatch.removeListener(_onMatchChange);
//    }
//
//    //widget.matchEngine.removeListener(_onMatchEngine);
//    super.dispose();
//  }
//
//  void _onMatchEngineChange() {
//    setState(() {
//      if (_currentMatch != null) {
//        _currentMatch.removeListener(_onMatchChange);
//      }
//      _currentMatch = widget.matchEngine.currentMatch;
//      if (_currentMatch != null) {
//        _currentMatch.addListener(_onMatchChange);
//      }
//
//      _frontCard = Key(_currentMatch.profile.name);
//    });
//  }
//
//  void _onMatchChange() {
//    setState(() {});
//  }
//
//  Widget _buildBackCard() {
//    return new Transform(
//      transform: new Matrix4.identity()..scale(_nextCardScale, _nextCardScale),
//      alignment: Alignment.center,
//      child: new ProfileCard(
//        backcard: true,
////        profile: widget.profile,
//        profile: widget.matchEngine.currentMatch.profile,
//        school: widget.currentUserUid,
//        currentUserUid: widget.currentUserUid,
//      ),
//    );
//  }
//
//  Widget _buildFrontCard() {
//    return new ProfileCard(
////      key: _frontCard,
//      profile: widget.matchEngine.currentMatch.profile,
//      backcard: false,
//      school: widget.currentUserUid,
//      currentUserUid: widget.currentUserUid,
//    );
//  }
//
//  SlideDirection _desiredSlideOutDirection() {
//    switch (widget.matchEngine.currentMatch.decision) {
//      case Decision.nope:
//        return SlideDirection.left;
//      case Decision.like:
//        return SlideDirection.right;
//      default:
//        return null;
//    }
//  }
//
//  void _onSlideUpdate(double distance) {
//    setState(() {
//      _nextCardScale = 0.9 + (0.1 * (distance / 100.0)).clamp(0.0, 0.1);
//    });
//  }
//
//  void _onSlideOutComplete(SlideDirection direction) {
//    DateMatch currentMatch = widget.matchEngine.currentMatch;
//
//    switch (direction) {
//      case SlideDirection.left:
//        currentMatch.nope();
//        break;
//      case SlideDirection.right:
//        currentMatch.like();
//        break;
//      default:
//        break;
//    }
//
//    widget.matchEngine.cycleMatch();
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    print("hhe");
//    if(widget.school == "yellow") {
//
//    }
//
//    return new Stack(
//      children: <Widget>[
//        new DraggableCard(
//          card: _buildBackCard(),
//          isDraggable: false,
//        ),
////        new DraggableCard(
////          card: _buildBackCard(),
////          isDraggable: false,
////        ),
////        new DraggableCard(
////          card: _buildBackCard(),
////          isDraggable: false,
////        ),
////        new DraggableCard(
////          card: _buildBackCard(),
////          isDraggable: false,
////        ),
////        new DraggableCard(
////          card: _buildBackCard(),
////          isDraggable: false,
////        ),
//        new DraggableCard(
//          card: _buildFrontCard(),
//          slideTo: _desiredSlideOutDirection(),
//          onSlideUpdate: _onSlideUpdate,
//          onSlideOutComplete: _onSlideOutComplete,
//        ),
//
////        new DraggableCard(
////          card: _buildFrontCard(),
////          slideTo: _desiredSlideOutDirection(),
////          onSlideUpdate: _onSlideUpdate,
////          onSlideOutComplete: _onSlideOutComplete,
////        ),
//      ],
//    );
//  }
//}
//
//class mainPage extends StatefulWidget {
//  String school;
//  String currentUserUid;
//  int primaryColorValue;
//
//  mainPage({Key key, this.school, this.currentUserUid, this.primaryColorValue})
//      : super(key: key);
//  @override
//  _mainPageState createState() => _mainPageState();
//}
//
//enum SlideDirection {
//  left,
//  right,
//  up,
//}
//
//class DraggableCard extends StatefulWidget {
//  final Widget card;
//  final bool isDraggable;
//  final SlideDirection slideTo;
//  final Function(double distance) onSlideUpdate;
//  final Function(SlideDirection direction) onSlideOutComplete;
//
//  DraggableCard({
//    this.card,
//    this.isDraggable = true,
//    this.slideTo,
//    this.onSlideUpdate,
//    this.onSlideOutComplete,
//  });
//  @override
//  _DraggableCardState createState() => _DraggableCardState();
//}
//
//class _DraggableCardState extends State<DraggableCard>
//    with TickerProviderStateMixin {
//  Offset cardOffset = const Offset(0.0, 0.0);
//  Offset dragStart;
//  Offset dragPostion;
//  Offset slideBackStart;
//  AnimationController slideBackAnimation;
//  Tween<Offset> slideOutTween;
//  AnimationController slideOutAnimation;
//  SlideDirection slideOutDirection;
//  int x = 0;
//  Decision decision;
//  GlobalKey profileCardKey = new GlobalKey(debugLabel: 'profile_card_key');
//
//  final DocumentReference documentReference =
//  Firestore.instance.document("wallpapers/D93JTZ9NfIGWGKLhFBxe");
//
//  @override
//  void initState() {
//    super.initState();
//    slideBackAnimation = new AnimationController(
//      duration: const Duration(milliseconds: 1000),
//      vsync: this,
//    )
//      ..addListener(() => setState(() {
//        cardOffset = Offset.lerp(slideBackStart, const Offset(0.0, 0.0),
//            Curves.elasticOut.transform(slideBackAnimation.value));
//
//        if (null != widget.onSlideUpdate) {
//          widget.onSlideUpdate(cardOffset.distance);
//        }
//      }))
//      ..addStatusListener((AnimationStatus status) {
//        if (status == AnimationStatus.completed) {
//          dragStart = null;
//          slideBackStart = null;
//          dragPostion = null;
//        }
//      });
//
//    slideOutAnimation = new AnimationController(
//      duration: const Duration(milliseconds: 500),
//      vsync: this,
//    )
//      ..addListener(() {
//        setState(() {
//          cardOffset = slideOutTween.evaluate(slideOutAnimation);
//
//          if (null != widget.onSlideUpdate) {
//            widget.onSlideUpdate(cardOffset.distance);
//          }
//        });
//      })
//      ..addStatusListener((AnimationStatus status) {
//        if (status == AnimationStatus.completed) {
//          setState(() {
//            dragStart = null;
//            dragPostion = null;
//            slideOutTween = null;
//
//            if (widget.onSlideOutComplete != null) {
//              widget.onSlideOutComplete(slideOutDirection);
//            }
//          });
//        }
//      });
//  }
//
//  @override
//  void didUpdateWidget(DraggableCard oldWidget) {
//    super.didUpdateWidget(oldWidget);
//
//    if (widget.card.key != oldWidget.card.key) {
//      cardOffset = const Offset(0.0, 0.0);
//    }
//
//    if (oldWidget.slideTo == null && widget.slideTo != null) {
//      switch (widget.slideTo) {
//        case SlideDirection.left:
//          _slideLeft();
//          break;
//        case SlideDirection.right:
//          _slideRight();
//          break;
//        default:
//          break;
//      }
//    }
//  }
//
//  @override
//  void dispose() {
//    slideBackAnimation.dispose();
//    super.dispose();
//  }
//
////  void _onMatchChange() {
////    if(widget.match.decision != decision) {
////      switch (widget.match.decision) {
////        case Decision.nope:
////          _slideLeft();
////          break;
////        case Decision.like:
////          _slideRight();
////          break;
////        default:
////          break;
////      }
////    }
////
////    decision = widget.match.decision;
////  }
//
//  Offset _chooseRandomDragStart() {
//    final cardContext = profileCardKey.currentContext;
//    final cardTopLeft = (cardContext.findRenderObject() as RenderBox)
//        .localToGlobal(const Offset(0.0, 0.0));
//    final dragStartY = cardContext.size.height *
//        (new Random().nextDouble() < 0.5 ? 0.25 : 0.75) +
//        cardTopLeft.dy;
//    return new Offset(cardContext.size.width / 2 + cardTopLeft.dx, dragStartY);
//  }
//
//  void _slideLeft() async {
//    final screenWidth = context.size.width;
//    dragStart = _chooseRandomDragStart();
//    slideOutTween = new Tween(
//        begin: const Offset(0.0, 0.0), end: new Offset(-2 * screenWidth, 0.0));
//    slideOutAnimation.forward(from: 0.0);
//  }
//
//  void _slideRight() async {
//    final screenWidth = context.size.width;
//    dragStart = _chooseRandomDragStart();
//    slideOutTween = new Tween(
//        begin: const Offset(0.0, 0.0), end: new Offset(2 * screenWidth, 0.0));
//    slideOutAnimation.forward(from: 0.0);
//  }
//
//  void _onPanStart(DragStartDetails details) {
//    dragStart = details.globalPosition;
//
//    if (slideBackAnimation.isAnimating) {
//      slideBackAnimation.stop(canceled: true);
//    }
//  }
//
//  void _onPanUpdate(DragUpdateDetails details) {
//    setState(() {
//      dragPostion = details.globalPosition;
//      cardOffset = dragPostion - dragStart;
//
//      if (null != widget.onSlideUpdate) {
//        widget.onSlideUpdate(cardOffset.distance);
//      }
//    });
//  }
//
//  void _onPanEnd(DragEndDetails details) {
//    final dragVector = cardOffset / cardOffset.distance;
//    final isInNopeRegion = (cardOffset.dx / context.size.width) < -0.45;
//    final isInLikeRegion = (cardOffset.dx / context.size.width) > 0.45;
//
//    Map<String, bool> data = <String, bool>{
//      'nope' : false
//    };
//    documentReference.updateData(data).whenComplete(() {
//      print("Document Added");
//    }).catchError((e) => print(e));
//
//
//    print('isInNopeRegion: $isInNopeRegion');
//    print('isInLikeRegion: $isInLikeRegion');
//
//    setState(() {
//      if (isInNopeRegion || isInLikeRegion) {
//        slideOutTween = new Tween(
//            begin: cardOffset, end: dragVector * (2 * context.size.width));
//        slideOutAnimation.forward(from: 0.0);
//
//        slideOutDirection =
//        isInNopeRegion ? SlideDirection.left : SlideDirection.right;
////        ++uidCount;
////        print("increment counter: $uidCount");
//      } else {
//        slideBackStart = cardOffset;
//        slideBackAnimation.forward(from: 0.0);
//      }
//    });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Transform(
//      transform:
//      new Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0),
//      child: new Container(
//        key: profileCardKey,
//        child: new GestureDetector(
//          onPanStart: _onPanStart,
//          onPanUpdate: _onPanUpdate,
//          onPanEnd: _onPanEnd,
//          child: widget.card,
//        ),
//      ),
//    );
//  }
//}
//
////  @override
////  Widget build(BuildContext context) {
////    return new AnchoredOverlay(
////      overlayBuilder: (BuildContext context, Rect anchorBounds, Offset anchor){
////     child: new Transform(
////        transform: new Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0)
////          ..rotateZ(_rotation(anchorBounds)),
////      origin: _rotationOrigin(anchorBounds),
////      child: new GestureDetector(
////      onPanStart: _onPanStart,
////      onPanUpdate: _onPanUpdate,
////      onPanEnd: _onPanEnd,
////      child: profileCard(),
////        ));});
////  }
////}
//
//class _mainPageState extends State<mainPage> {
//  @override
//  Widget build(BuildContext context) {
//    return new Scaffold(
//      backgroundColor: Colors.white,
//      body: CardStack(
//        matchEngine: matchEngine,
//        school: widget.school,
//        currentUserUid: widget.currentUserUid
//      ),
//    );
//  }
//}
////
////class ShadowText extends StatelessWidget {
////  ShadowText(this.data, {this.style}) : assert(data != null);
////
////  final String data;
////  final TextStyle style;
////
////  Widget build(BuildContext context) {
////    return new ClipRect(
////      child: new Stack(
////        children: [
////          new Positioned(
////            top: 2.0,
////            left: 2.0,
////            child: new Text(
////              data,
////              style: style.copyWith(color: Colors.black.withOpacity(0.5)),
////            ),
////          ),
////          new BackdropFilter(
////            filter: new ui.ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
////            child: new Text(data, style: style),
////          ),
////        ],
////      ),
////    );
////  }
////}
//
////todo shit here bruh
//class ProfileCard extends StatefulWidget {
//  final Profile profile;
//  final ProfileCard profilecard;
//  String school;
//  String currentUserUid;
//  List<String> image;
//  bool swipe;
//  bool backcard;
//
//
//
//  ProfileCard({
//    Key key,
//    this.profile,
//    this.school,
//    this.currentUserUid,
//    this.backcard,
//  }) : super(key: key);
//  @override
//  _profileCardState createState() => _profileCardState();
//}
//
//class _profileCardState extends State<ProfileCard> {
//  StreamSubscription<QuerySnapshot> subscription;
//  List<DocumentSnapshot> wallpapersList;
////  final CollectionReference collectionReference = Firestore.instance.collection("schools").document(school).collection();
//  Color primarySchoolColor;
//  Color secondarySchoolColor;
//  String happy;
//  bool swipe;
//  bool succeed = false;
//  List<DocumentSnapshot> photosList;
//  List<DocumentSnapshot> userList;
////  FirebaseUser user;
//  CollectionReference collectionReference;
//  Stream<DocumentSnapshot> userReference;
//  List<String> apples;
//
//  final String addPhotoUrl = "https://vignette.wikia.nocookie.net/konosuba/images/4/4f/Megumin_1.jpg/revision/latest?cb=20180502131754";
//
//
//  void getUserPhotos(String uid) async {
////    FirebaseUser user = await FirebaseAuth.instance.currentUser();
//
////    if(uid == null) {
////      uid = addPhotoUrl;
////    }
//
//    ++uidCount;
//    collectionReference = Firestore.instance.collection("users").document(uid).collection("photos");
////    userReference = Firestore.instance.collection("users").document("${widget.currentUserUid}").snapshots();
//
//    subscription = collectionReference.snapshots().listen((datasnapshot) {
//      setState(() {
//        photosList = datasnapshot.documents;
//        succeed = true;
//      });
//    });
//
//  }
//
////  void getUids() async {
////    QuerySnapshot querySnapshot = await Firestore.instance.collection("schools").document(widget.school).collection("profiles").getDocuments();
////    var list = querySnapshot.documents;
////    print(list);
////  }
//
//  void getUids() async {
//
//    final userReference = Firestore.instance.collection("users");
//    List<DocumentSnapshot> wallpapersList;
//
//    userReference.snapshots().listen((datasnapshot) {
//      setState(() {
//        wallpapersList = datasnapshot.documents;
//        photosListLength = wallpapersList.length;
////        print(wallpapersList);
//
////        if(wallpapersList[uidCount].documentID == null) {
////          getUids();
////        }
//
//
//          print("u r serious?/? ${widget.backcard}");
//
////        if(widget.backcard == true) {
////          if(wallpapersList[uidCount].documentID != null) {
////              print("backcard1: ${wallpapersList[uidCount+1].documentID}");
////            getLists(wallpapersList[uidCount].documentID);
////          } else {
////            print("end of profiles");
////          }
////        } else {
//          if(wallpapersList[uidCount].documentID != null) {
//            print("frontcard: ${wallpapersList[uidCount].documentID}");
//            getUserPhotos(wallpapersList[uidCount].documentID);
//          } else {
//            print("end of profiles");
//          }
////        }
//
//
////        wallpapersList.forEach((uid) {
////          print("heh? ${uid.documentID}");
////          if(uid.documentID[uidCount] != widget.currentUserUid) {
////            print("ooooooooo: ${uid.documentID}");
//////            getWallpaperList(uid.documentID);
////            getLists(uid.documentID);
//////            ++uidCount;
//////            print("running $uidCount");
////          } else {
////            print("I Dont Know ${wallpapersList[1].documentID}");
////            ++uidCount;
////            getUids();
////          }
////        });
//
//
//      });
//    });
//  }
//
//  @override
//  void initState() {
//    super.initState();
//
//    getUids();
//
//
//
//  }
//
//  //todo clean this
////  void getWallpaperList(String uid) {
////    print("the uid: $uid");
////    final schoolReference = Firestore.instance.collection("schools").document("${widget.school}").collection("profiles").document("${widget.currentUserUid}").collection("photos");
////
//////    CollectionReference uidSon = Firestore.instance.collection("schools").document("${widget.school}").collection("profiles");
////
////    subscription = schoolReference.snapshots().listen((datasnapshot) {
////      setState(() {
////        photosList = datasnapshot.documents;
////      });
////    });
////  }
//
//
//  @override
//  void dispose() {
//    subscription?.cancel();
//    super.dispose();
//  }
//
//
//  Widget _buildBackground() {
//
//    String selfie;
//    String firstPic;
//    String secondPic;
//    succeed ? selfie = photosList[0].data['selfie'] : selfie = addPhotoUrl;
//    succeed ? firstPic = photosList[0].data['firstPhoto'] : firstPic = addPhotoUrl;
//    succeed ? secondPic = photosList[0].data['secondaryPhoto'] : secondPic = addPhotoUrl;
//    apples = [
//      selfie,
//      firstPic,
//      secondPic
//    ];
//
//    return new PhotoBrowser(
//      photoAssetPaths: apples,
//      visiblePhotoIndex: 0,
//    );
//
//  }
//
//
//  Widget _buildProfileSynopsis() {
//    return new Positioned(
//        left: 0.0,
//        right: 0.0,
//        bottom: 0.0,
//        child: new Container(
//          decoration: new BoxDecoration(
//            gradient: new LinearGradient(
//                begin: Alignment.topCenter,
//                end: Alignment.bottomCenter,
//                colors: [
//                  Colors.transparent,
//                  Colors.black.withOpacity(0.8),
//                ]),
//          ),
//          padding: const EdgeInsets.all(24.0),
//          child: new Row(
//            mainAxisSize: MainAxisSize.max,
//            children: <Widget>[
//              new Expanded(
//                  child: new Column(
//                    crossAxisAlignment: CrossAxisAlignment.start,
//                    mainAxisSize: MainAxisSize.min,
//                    children: <Widget>[
////    new StreamBuilder<Event>(
////    stream: FirebaseDatabase.instance
////        .reference()
////        .child('users')
////        .child('Nse2kxgejeVSV1gZRbN9dNzVj8u1')
////        .onValue,
////    builder:
////      (BuildContext context, AsyncSnapshot<Event> event) {
////    if (!event.hasData)
////    return new Center(child: new Text('Loading...'));
////    Map<dynamic, dynamic> data = event.data.snapshot.value;
////    return Column(children: [
////    new Text('${data['name']}',
////    style: new TextStyle(fontSize: 30.0))]);}),
//
//                      new IconButton(
//                          icon: new Icon(
//                            Icons.bubble_chart,
//                            color: Colors.white,
//                          ),
//                          onPressed: (){
//                            var route = new MaterialPageRoute(
//                                builder: (BuildContext context) =>
//                                new userProfiles12()
//                            );
//                            Navigator.of(context).push(route);
//                          })
//                    ],
//                  )),
//              new ShadowText(
//                "Rosencramps",
//                style: new TextStyle(
//                    fontSize: 50.0, color: Colors.white, fontFamily: 'Gelio'),
//              )
//            ],
//          ),
//        ));
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Container(
////      decoration: BoxDecoration(
////        borderRadius: new BorderRadius.circular(10.0),
////        boxShadow: [
////          new BoxShadow(
////            color: const Color(0x11000000),
////            blurRadius: 5.0,
////            spreadRadius: 2.0,
////          ),
////        ]
////      ),
//      child: ClipRRect(
//        borderRadius: new BorderRadius.circular(5.0),
//        child: new Material(
//          child: new Stack(
//            fit: StackFit.expand,
//            children: <Widget>[
//              _buildBackground(),
//              _buildProfileSynopsis(),
//            ],
//          ),
//        ),
//      ),
//    );
//  }
//}
//
//
//
//
//class PhotoBrowser extends StatefulWidget {
//  final List<String> photoAssetPaths;
//  final String firstPic;
//  final String secondPic;
//  final int visiblePhotoIndex;
//  final mainPage firstpic;
//  final DataSnapshot messageSnapshot;
//
//
//
//  PhotoBrowser({this.photoAssetPaths,this.messageSnapshot, this.firstpic, this.firstPic, this.secondPic, this.visiblePhotoIndex});
//  @override
//  _PhotoBrowserState createState() => _PhotoBrowserState();
//}
//
//class _PhotoBrowserState extends State<PhotoBrowser> {
//  //StorageReference reference = FirebaseDatabase.instance.reference().child('users');
//
//  int visiblePhotoIndex;
//
//  @override
//  void initState() {
//    super.initState();
//    visiblePhotoIndex = widget.visiblePhotoIndex;
//
//
//  }
//
//
//  @override
//  void didUpdateWidget(PhotoBrowser oldWidget) {
//    super.didUpdateWidget(oldWidget);
//    if (widget.visiblePhotoIndex != oldWidget.visiblePhotoIndex) {
//      setState(() {
//        visiblePhotoIndex = widget.visiblePhotoIndex;
//      });
//    }
//  }
//
//  void prevImage() {
//    setState(() {
//      visiblePhotoIndex = visiblePhotoIndex > 0 ? visiblePhotoIndex - 1 : 0;
//    });
//  }
//
//  void nextImage() {
//    setState(() {
//      visiblePhotoIndex = visiblePhotoIndex < widget.photoAssetPaths.length - 1
//          ? visiblePhotoIndex + 1
//          : visiblePhotoIndex;
//    });
//  }
//
//  Widget _buildPhotoControls() {
//    return new Stack(
//      fit: StackFit.expand,
//      children: <Widget>[
//        new GestureDetector(
//          onTap: prevImage,
//          child: new FractionallySizedBox(
//            widthFactor: 0.5,
//            heightFactor: 1.0,
//            alignment: Alignment.topLeft,
//            child: new Container(
//              color: Colors.transparent,
//            ),
//          ),
//        ),
//        new GestureDetector(
//          onTap: nextImage,
//          child: new FractionallySizedBox(
//            widthFactor: 0.5,
//            heightFactor: 1.0,
//            alignment: Alignment.topRight,
//            child: new Container(
//              color: Colors.transparent,
//            ),
//          ),
//        ),
//      ],
//    );
//  }
//
//
//
//
//  @override
//  Widget build(BuildContext context) {
//    return new Stack(
//      fit: StackFit.expand,
//      children: <Widget>[
//        new Hero(
//            tag: widget.photoAssetPaths,
//            child: new FadeInImage(
//                placeholder: new AssetImage("images/StoneLightGrey.png"),
//                image: new NetworkImage(widget.photoAssetPaths[visiblePhotoIndex]),
//                fit: BoxFit.cover,
//            )
//        ),
////        new StaggeredGridView.countBuilder(
////          padding: const EdgeInsets.all(8.0),
////          crossAxisCount: 4,
////          itemCount: wallpapersList.length,
////          itemBuilder: (context, i) {
////            String imgPath = wallpapersList[i].data['url'];
////            return new Material(
////              elevation: 8.0,
////              borderRadius:
////              new BorderRadius.all(new Radius.circular(8.0)),
////              child: new InkWell(
////                onTap: null,
////                child: new Hero(
////                  tag: imgPath,
////                  child: new FadeInImage(
////                    image: new NetworkImage(imgPath),
////                    fit: BoxFit.cover,
////                    placeholder: new AssetImage("images/Rory3.jpg"),
////                  ),
////                ),
////              ),
////            );
////          },
////          staggeredTileBuilder: (i) =>
////          new StaggeredTile.count(2, i.isEven ? 2 : 3),
////          mainAxisSpacing: 8.0,
////          crossAxisSpacing: 8.0,
////        ),
//        new Positioned(
//          top: 0.0,
//          left: 0.0,
//          right: 0.0,
//          child: new Container(
//            decoration: new BoxDecoration(
//                gradient: new LinearGradient(
//                    begin: Alignment.bottomCenter,
//                    end: Alignment.topCenter,
//                    colors: [
//                      Colors.transparent,
//                      Colors.white,
//                    ]
//                )
//            ),
//            child: new SelectedPhotoIndicator(
//              photoCount: widget.photoAssetPaths.length,
//              visiblePhotoIndex: visiblePhotoIndex,
//            ),
//          ),
////          child: new SelectedPhotoIndicator(
////            photoCount: widget.photoAssetPaths.length,
////            visiblePhotoIndex: visiblePhotoIndex,
////          ),
//        ),
//        _buildPhotoControls(),
//      ],
//    );
//  }
//}
//
//
//class SelectedPhotoIndicator extends StatelessWidget {
//  final int photoCount;
//  final int visiblePhotoIndex;
//
//  SelectedPhotoIndicator({
//    this.photoCount,
//    this.visiblePhotoIndex,
//  });
//
//  Widget _buildInactiveIndicators() {
//    return new Expanded(
//        child: new Padding(
//          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
//          child: new Container(
//            height: 3.0,
//            decoration: new BoxDecoration(
//              color: Colors.black.withOpacity(0.2),
//              borderRadius: new BorderRadius.circular(2.5),
////              boxShadow: [
////                new BoxShadow(
////                  color: const Color(0x22000000),
////                  spreadRadius: 0.0,
////                  blurRadius: 2.0,
////                  offset: const Offset(0.0, 1.0)
////                )
////              ]
//            ),
//          ),
//        ));
//  }
//
//  Widget _buildActiveIndicators() {
//    return new Expanded(
//        child: new Padding(
//          padding: const EdgeInsets.only(left: 2.0, right: 2.0),
//          child: new Container(
//            height: 3.0,
//            decoration: new BoxDecoration(
//                color: Colors.white,
//                borderRadius: new BorderRadius.circular(2.5),
//                boxShadow: [
//                  new BoxShadow(
//                      color: const Color(0x22000000),
//                      spreadRadius: 0.0,
//                      blurRadius: 2.0,
//                      offset: const Offset(0.0, 1.0))
//                ]),
//          ),
//        ));
//  }
//
//  List<Widget> _buildIndicators() {
//    List<Widget> indicators = [];
//    for (int i = 0; i < photoCount; ++i) {
//      indicators.add(i == visiblePhotoIndex
//          ? _buildActiveIndicators()
//          : _buildInactiveIndicators());
//    }
//    return indicators;
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return new Padding(
//      padding: const EdgeInsets.fromLTRB(8.0, 40.0, 8.0, 0.0),
//      child: new Row(
//        children: _buildIndicators(),
//      ),
//    );
//  }
//}

