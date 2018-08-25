import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';
import 'package:stone_actual/UI/profiles.dart';
import './matches.dart';
import './User_Profile.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



final MatchEngine matchEngine = new MatchEngine(
  matches: demoProfiles.map((Profile profile) {
    return new DateMatch(profile: profile);
  }).toList(),
);



class CardStack extends StatefulWidget {
  final MatchEngine matchEngine;
  String value;
  Color primary;
  Color secondary;

  CardStack({Key key, this.value, this.primary, this.secondary, this.matchEngine})
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

    _frontCard = new Key(_currentMatch.profile.name);
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

      _frontCard = Key(_currentMatch.profile.name);
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
        profile: widget.matchEngine.nextMatch.profile,
      ),
    );
  }

  Widget _buildFrontCard() {
    return new profileCard(
      key: _frontCard,
      profile: widget.matchEngine.currentMatch.profile,
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
          card: _buildFrontCard(),
          slideTo: _desiredSlideOutDirection(),
          onSlideUpdate: _onSlideUpdate,
          onSlideOutComplete: _onSlideOutComplete,
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

class mainPage extends StatefulWidget {
  String value;
  Color primary;
  Color secondary;
  String firstpic;

  mainPage({Key key, this.value,this.firstpic, this.primary, this.secondary})
      : super(key: key);
  @override
  _mainPageState createState() => _mainPageState();
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

  final DocumentReference documentReference =
  Firestore.instance.document("wallpapers/D93JTZ9NfIGWGKLhFBxe");

  @override
  void initState() {
    super.initState();
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

  void _onPanEnd(DragEndDetails details) {
    final dragVector = cardOffset / cardOffset.distance;
    final isInNopeRegion = (cardOffset.dx / context.size.width) < -0.45;
    final isInLikeRegion = (cardOffset.dx / context.size.width) > 0.45;

    Map<String, bool> data = <String, bool>{
      'nope' : false
    };
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

class _mainPageState extends State<mainPage> {
  @override
  Widget build(BuildContext context) {
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

class profileCard extends StatefulWidget {
  final Profile profile;
  final profileCard profilecard;
  String name;
  String value;
  Color primary;
  Color secondary;
  List<String> image;
  final DataSnapshot messageSnapshot;
  bool swipe;



  profileCard({
    Key key,
    this.name,
    this.profilecard,
    this.image,
    this.messageSnapshot,
    this.value,
    this.primary,
    this.secondary,
    this.profile,
  }) : super(key: key);
  @override
  _profileCardState createState() => _profileCardState();
}

class _profileCardState extends State<profileCard> {
  StreamSubscription<QuerySnapshot> subscription;
  List<DocumentSnapshot> wallpapersList;
  final CollectionReference collectionReference =
  Firestore.instance.collection("users");
  Color primarySchoolColor;
  Color secondarySchoolColor;
  String happy;
  bool swipe;





  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    subscription = collectionReference.snapshots().listen((datasnapshot) {
      setState(() {
        wallpapersList = datasnapshot.documents;
      });
    });

    // _currentScreen();
  }

  @override
  void dispose() {
    subscription?.cancel();
    super.dispose();
  }


  Widget _buildBackground() {

    List<String> apples;
    List<String> noUser = [
      'images/Rory.jpg',
    ];
    String img;
    String img1;
    for(var i = 0; i < 3; i++){
//      if(wallpapersList[i].data['nope'] == true) {
        img1 = wallpapersList[i].data['selfie'];
//        img = wallpapersList[i].data['url2'];
        apples = [
          img1,
//          img
        ];
        return new PhotoBrowser(
          photoAssetPaths: apples,
          visiblePhotoIndex: 0,
        );
//      }
//      else {
//        print('no users left');
//        return new PhotoBrowser(
//          photoAssetPaths: noUser,
//          visiblePhotoIndex: 0,
//        );
//      }
    }
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
          padding: const EdgeInsets.all(24.0),
          child: new Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              new Expanded(
                  child: new Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
//    new StreamBuilder<Event>(
//    stream: FirebaseDatabase.instance
//        .reference()
//        .child('users')
//        .child('Nse2kxgejeVSV1gZRbN9dNzVj8u1')
//        .onValue,
//    builder:
//      (BuildContext context, AsyncSnapshot<Event> event) {
//    if (!event.hasData)
//    return new Center(child: new Text('Loading...'));
//    Map<dynamic, dynamic> data = event.data.snapshot.value;
//    return Column(children: [
//    new Text('${data['name']}',
//    style: new TextStyle(fontSize: 30.0))]);}),

                      new IconButton(
                          icon: new Icon(
                            Icons.bubble_chart,
                            color: Colors.white,
                          ),
                          onPressed: (){
                            primarySchoolColor = widget.primary;
                            secondarySchoolColor = widget.secondary;
                            happy = widget.value;
                            var route = new MaterialPageRoute(
                                builder: (BuildContext context) =>
                                new userProfiles12(value: happy, primary: primarySchoolColor, secondary: secondarySchoolColor,)
                            );
                            Navigator.of(context).push(route);
                          })
                    ],
                  )),
              new ShadowText(
                'Rory',
                style: new TextStyle(
                    fontSize: 50.0, color: Colors.white, fontFamily: 'Gelio'),
              )
            ],
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
//      decoration: BoxDecoration(
//        borderRadius: new BorderRadius.circular(10.0),
//        boxShadow: [
//          new BoxShadow(
//            color: const Color(0x11000000),
//            blurRadius: 5.0,
//            spreadRadius: 2.0,
//          ),
//        ]
//      ),
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
  final DataSnapshot messageSnapshot;



  PhotoBrowser({this.photoAssetPaths,this.messageSnapshot, this.firstpic, this.firstPic, this.secondPic, this.visiblePhotoIndex});
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
    visiblePhotoIndex = widget.visiblePhotoIndex;subscription = collectionReference.snapshots().listen((datasnapshot) {
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
//                placeholder: new AssetImage("images/Rory3.jpg"),
//                image: new NetworkImage(widget.photoAssetPaths),
//                fit: BoxFit.cover,
//            )
//        ),

        new Image.network(
          widget.photoAssetPaths[visiblePhotoIndex],
          fit: BoxFit.cover,
        ),
//        new StaggeredGridView.countBuilder(
//          padding: const EdgeInsets.all(8.0),
//          crossAxisCount: 4,
//          itemCount: wallpapersList.length,
//          itemBuilder: (context, i) {
//            String imgPath = wallpapersList[i].data['url'];
//            return new Material(
//              elevation: 8.0,
//              borderRadius:
//              new BorderRadius.all(new Radius.circular(8.0)),
//              child: new InkWell(
//                onTap: null,
//                child: new Hero(
//                  tag: imgPath,
//                  child: new FadeInImage(
//                    image: new NetworkImage(imgPath),
//                    fit: BoxFit.cover,
//                    placeholder: new AssetImage("images/Rory3.jpg"),
//                  ),
//                ),
//              ),
//            );
//          },
//          staggeredTileBuilder: (i) =>
//          new StaggeredTile.count(2, i.isEven ? 2 : 3),
//          mainAxisSpacing: 8.0,
//          crossAxisSpacing: 8.0,
//        ),
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
                    ]
                )
            ),
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

