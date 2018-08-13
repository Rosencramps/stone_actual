import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:ui' as ui;


class mainPage extends StatefulWidget {
  String value;
  Color primary;
  Color secondary;

  mainPage({Key key, this.value, this.primary, this.secondary}) : super(key: key);
  @override
  _mainPageState createState() => _mainPageState();
}

class DraggableCard extends StatefulWidget {
  @override
  _DraggableCardState createState() => _DraggableCardState();
}

class _DraggableCardState extends State<DraggableCard> with TickerProviderStateMixin{
  Offset cardOffset = const Offset(0.0, 0.0);
  Offset dragStart;
  Offset dragPostion;
  Offset slideBackStart;
  AnimationController slideBackAnimation;
  Tween<Offset> slideOutTween;
  AnimationController slideOutAnimation;



  @override
  void initState() {
    super.initState();
    slideBackAnimation = new AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )
      ..addListener(() => setState(() {
        cardOffset = Offset.lerp(
            slideBackStart,
            const Offset(0.0, 0.0),
            Curves.elasticOut.transform(slideBackAnimation.value)
        );
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
        });
      })
      ..addStatusListener((AnimationStatus status) {
        if (status == AnimationStatus.completed){
          setState(() {
            dragStart = null;
            dragPostion = null;
            slideOutTween = null;
            cardOffset = const Offset(0.0, 0.0);
          });
        }
      });
  }

  @override
  void dispose() {
    slideBackAnimation.dispose();
    super.dispose();
  }


  void _onPanStart(DragStartDetails details) {
    dragStart = details.globalPosition;
  }

  void _onPanUpdate(DragUpdateDetails details){
    setState(() {
      dragPostion = details.globalPosition;
      cardOffset = dragPostion - dragStart;
    });
  }

  void _onPanEnd(DragEndDetails details){
    final dragVector = cardOffset / cardOffset.distance;
    final isInNopeRegion = (cardOffset.dx / context.size.width).abs() < 0.60;
    final isInLikeRegion = (cardOffset.dx / context.size.width).abs() > 0.60;

    print('isInNopeRegion: $isInNopeRegion');
    print('isInLikeRegion: $isInLikeRegion');

    setState(() {
      if(isInNopeRegion || isInLikeRegion) {
        slideOutTween = new Tween(begin: cardOffset, end: dragVector * (2 * context.size.width));
        slideOutAnimation.forward(from: 0.0);
      } else {
        slideBackStart = cardOffset;
        slideBackAnimation.forward(from: 0.0);
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return new Transform(
      transform: new Matrix4.translationValues(cardOffset.dx, cardOffset.dy, 0.0),
      child: new Container(
        child: new GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: new profileCard(),
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
//        appBar: AppBar(
//          backgroundColor: widget.primary,
//          title: new Text(
//            'Stone Logo',
//            style: new TextStyle(
//              color: widget.secondary
//            ),
//          ),
//          actions: <Widget>[
//            IconButton(
//                icon: Icon(Icons.list,
//                color: widget.secondary,),
//                onPressed: null)
//          ],
//          leading: BackButton(
//            color: widget.secondary,
//          ),
//        ),
      body: DraggableCard(),
    );
  }
}


class ShadowText extends StatelessWidget {
  ShadowText(this.data, { this.style }) : assert(data != null);

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




class profileCard extends StatefulWidget {
  @override
  _profileCardState createState() => _profileCardState();
}

class _profileCardState extends State<profileCard> {


  Widget _buildBackground() {
    return new PhotoBrowser(
      photoAssetPaths: [
        'images/Rory3.jpg',
        'images/Rory2.jpg',
        'images/Rory4.jpg',
      ],
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
                ]
            ),
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
                      new Icon(
                        Icons.graphic_eq,
                        color: Colors.white,
                      )
                    ],
                  )
              ),
              new ShadowText(
                'Rory',
                style: new TextStyle(
                    fontSize: 50.0,
                    color: Colors.white,
                    fontFamily: 'Gelio'
                ),
              )
            ],
          ),
        )
    );
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
        borderRadius: new BorderRadius.circular(20.0),
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
  final int visiblePhotoIndex;

  PhotoBrowser({
    this.photoAssetPaths,
    this.visiblePhotoIndex
  });
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
    if(widget.visiblePhotoIndex != oldWidget.visiblePhotoIndex) {
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
        new Image.asset(
          widget.photoAssetPaths[visiblePhotoIndex],
          fit: BoxFit.cover,
        ),
        new Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: new SelectedPhotoIndicator(
            photoCount: widget.photoAssetPaths.length,
            visiblePhotoIndex: visiblePhotoIndex,
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

  Widget _buildInactiveIndicators(){
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
        )
    );
  }

  Widget _buildActiveIndicators(){
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
                      offset: const Offset(0.0, 1.0)
                  )
                ]
            ),
          ),
        )
    );
  }
  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < photoCount; ++i){
      indicators.add(
          i == visiblePhotoIndex ? _buildActiveIndicators() : _buildInactiveIndicators());
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