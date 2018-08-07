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
    return new Scaffold(
      backgroundColor: Colors.white,
//      appBar: AppBar(
//        backgroundColor: widget.primary,
//        title: new Text(
//          'Stone Logo',
//          style: new TextStyle(
//              color: widget.secondary
//          ),
//        ),
//        actions: <Widget>[
//          IconButton(
//              icon: Icon(Icons.list,
//                color: widget.secondary,),
//              onPressed: null)
//        ],
//        leading: BackButton(
//          color: widget.secondary,
//        ),
//      ),
      body: profileCard(),
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
        'images/Rory1.jpg',
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
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      new Text(
                        'Rory',
                        style: new TextStyle(
                            fontSize: 50.0,
                            color: Colors.white,
                            fontFamily: 'Gelio'
                        ),
                      )
                    ],
                  )
              ),
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
        borderRadius: new BorderRadius.circular(0.0),
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
                borderRadius: new BorderRadius.circular(2.5)
            ),
          ),
        )
    );
  }
  List<Widget> _buildIndicators() {
    List<Widget> indicators = [];
    for (int i = 0; i < photoCount; ++i){
      indicators.add(_buildInactiveIndicators());
    }
    return indicators;
  }

  @override
  Widget build(BuildContext context) {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Row(
        children: _buildIndicators(),
      ),
    );
  }
}