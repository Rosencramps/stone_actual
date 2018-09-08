import 'package:flutter/material.dart';
import './SignUp.dart';

class StoneLogin extends StatefulWidget {
  @override
  _StoneLoginState createState() => _StoneLoginState();
}

class _StoneLoginState extends State<StoneLogin> {
  String happy;
  Color primarySchoolColor;
  Color secondarySchoolColor;
  @override
  Widget build(BuildContext context) {
    Widget _dropDown() {
      return new Container(
          alignment: Alignment.center,
          child: new DropdownButton<String>(
              hint: new Text('College/University',
                style: new TextStyle(
                    color: Colors.black
                ),),
              items: <String>[
                'Arizona State University',
                'Auburn University',
                'Bloomsburg University of Pennsylvania',
                'California State University - Chico',
                'Central Michigan University',
                'Clark Atlanta University',
                'Clemson University',
                'Colgate University',
                'Columbia College Chicago',
                'College of Charleston',
                'Colorado State University',
                'DePaul University',
                'East Carolina University',
                'Florida A&M University',
                'Florida State University',
                'Georgia Southern University',
                'Georgia State University',
                'George Washington University',
                'Howard University',
                'Indiana University - Bloomington',
                'Indiana University of Pennsylvania',
                'Iowa State University',
                'Kansas State University',
                'Lehigh University',
                'Louisiana State University',
                'Loyola University New Orleans',
                'Massachustts Institute of Technology',
                'Miami University',
                'Michigan State University',
                'Missouri State University',
                'Morehouse College',
                'The New School',
                'New York University',
                'The Ohio State University',
                'Ohio University',
                'Parson School Design - The New School',
                'Penn State',
                'Providence College',
                'Rollins College',
                'Rutgers University - New Brunswick',
                'San Diego State University',
                'Stevens Institute of Technology',
                'Southern Illinois University Carbondale',
                'Southern Methodist University',
                'Spelman College',
                'Suny College at Oneonta',
                'Suny Cortland',
                'Suny Oswego',
                'Syracuse University',
                'Temple University',
                'Texas A&M University',
                'Texas Christian University',
                'Texas State University',
                'Texas Tech University',
                'Tulane University',
                'University at Buffalo',
                'University of Alabama',
                'University of Arizona',
                'University of Arkansas',
                'University of The Arts',
                'University of California - Los Angeles',
                'University of California - Santa Barbara',
                'University of Central Flordia',
                'University of Colorado - Boulder',
                'University of Dayton',
                'University of Delaware',
                'University of Denver',
                'University of Florida',
                'University of Georgia',
                'University of Illinois at Urbana - Champaign',
                'University of Iowa',
                'University of Kansas',
                'University of Louisiana - Lafayette',
                'University of Maryland - College Park',
                'University of Massachusetts - Amherst',
                'University of Miami',
                'University of Michigan - Ann Arbor',
                'University of Minnesota - Twin Cities',
                'University of Mississippi',
                'University of Missouri',
                'University of Nebraska - Lincoln',
                'University of North Carolina at Chapel Hill',
                'University of Oklahoma',
                'University of Oregon',
                'University of Pennsylvania',
                'University of Pittsburgh',
                'University of South Carolina',
                'University of Southern California',
                'University of Tennessee',
                'University of Texas - Austin',
                'University of Virginia',
                'University of Washington',
                'University of Wisconsin',
                'University of Wisconsin - Oshkosh',
                'Vanderbilt University',
                'Virginia Tech',
                'Washington State University',
                'West Virginia University',
                'Western Illionis University',
                'Western Michigan University'].map((String happy){
                return DropdownMenuItem<String>(
                  value: happy,
                  child: new Text(happy,
                    style: new TextStyle(
                        fontSize: 14.5
                    ),),
                );
              }).toList(),
              onChanged: (String value) {
                switch(value){
                  case 'Arizona State University':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'Auburn University':
                    primarySchoolColor =  Colors.blue[900];
                    secondarySchoolColor = Colors.deepOrange;
                    break;
                  case 'Bloomsburg University of Pennsylvania':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'California State University - Chico':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Central Michigan University' :
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'Clark Atlanta University':
                    primarySchoolColor =  Colors.black;
                    secondarySchoolColor = Colors.red[900];
                    break;
                  case 'Clemson University':
                    primarySchoolColor = Colors.deepOrange;
                    secondarySchoolColor = Colors.purple;
                    break;
                  case 'Colgate University':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.grey;
                    break;
                  case 'Columbia College Chicago':
                    primarySchoolColor = Colors.black;
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'College of Charleston':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Colorado State University':
                    primarySchoolColor =  Colors.green[900];
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'DePaul University':
                    primarySchoolColor = Colors.blue[900];
                    secondarySchoolColor = Colors.redAccent[700];
                    break;
                  case  'East Carolina University':
                    primarySchoolColor =  Colors.deepPurple;
                    secondarySchoolColor = Colors.yellowAccent;
                    break;
                  case 'Florida A&M University':
                    primarySchoolColor = Colors.green;
                    secondarySchoolColor = Colors.orange;
                    break;
                  case 'Florida State University':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.yellowAccent[100];
                    break;
                  case 'Georgia Southern University':
                    primarySchoolColor = Colors.lightBlue[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Georgia State University':
                    primarySchoolColor = Colors.lightBlue[700];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'George Washington University':
                    primarySchoolColor = Colors.yellow[100];
                    secondarySchoolColor = Colors.blue[900];
                    break;
                  case 'Howard University':
                    primarySchoolColor =  Colors.blue[900];
                    secondarySchoolColor = Colors.red[900];
                    break;
                  case 'Indiana University - Bloomington':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Indiana University of Pennsylvania':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.blueGrey;
                    break;
                  case 'Iowa State University' :
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'Kansas State University':
                    primarySchoolColor =  Colors.purple;
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Lehigh University':
                    primarySchoolColor = Colors.brown;
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Louisiana State University':
                    primarySchoolColor =  Colors.purple;
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'Loyola University New Orleans':
                    primarySchoolColor = Colors.red;
                    secondarySchoolColor = Colors.yellowAccent;
                    break;
                  case 'Massachustts Institute of Technology':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.grey;
                    break;
                  case 'Miami University':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Michigan State University':
                    primarySchoolColor = Colors.green[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Missouri State University':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Morehouse College':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'The New School':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'New York University':
                    primarySchoolColor = Colors.purple;
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'The Ohio State University':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.grey;
                    break;
                  case 'Ohio University':
                    primarySchoolColor = Colors.green[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Parson School Design - The New School':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.black;
                    break;
                  case 'University of Illinois at Urbana - Champaign':
                    primarySchoolColor = Colors.deepOrange;
                    secondarySchoolColor = Colors.blue[900];
                    break;
                  case 'Providence College':
                    primarySchoolColor =  Colors.black;
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Rollins College':
                    primarySchoolColor = Colors.yellowAccent;
                    secondarySchoolColor = Colors.blue[900];
                    break;
                  case 'Rutgers University - New Brunswick':
                    primarySchoolColor =  Colors.black;
                    secondarySchoolColor = Colors.red[900];
                    break;
                  case 'San Diego State University':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.black;
                    break;
                  case 'Stevens Institute of Technology':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.grey;
                    break;
                  case 'Southern Illinois University Carbondale':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.black;
                    break;
                  case 'Southern Methodist University':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.blue[900];
                    break;
                  case 'Spelman College':
                    primarySchoolColor =  Colors.lightBlue;
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Suny College at Oneonta':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case  'Suny Cortland':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Suny Oswego':
                    primarySchoolColor = Colors.green[700];
                    secondarySchoolColor = Colors.yellowAccent;
                    break;
                  case 'Syracuse University':
                    primarySchoolColor =  Colors.deepOrange;
                    secondarySchoolColor = Colors.blue[900];
                    break;
                  case 'Temple University':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Texas A&M University':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Texas Christian University':
                    primarySchoolColor = Colors.purple;
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Texas State University':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.yellowAccent;
                    break;
                  case 'Texas Tech University':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.black;
                    break;
                  case 'Tulane University':
                    primarySchoolColor =  Colors.green;
                    secondarySchoolColor = Colors.lightBlueAccent;
                    break;
                  case 'University at Buffalo':
                    primarySchoolColor = Colors.blue[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'University of Alabama':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'University of Arizona':
                    primarySchoolColor = Colors.blue[900];
                    secondarySchoolColor = Colors.red[900];
                    break;
                  case 'University of Arkansas':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'University of The Arts':
                    primarySchoolColor = Colors.black;
                    secondarySchoolColor = Colors.red;
                    break;
                  case 'University of California - Los Angeles':
                    primarySchoolColor =  Colors.blue[900];
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'University of California - Santa Barbara':
                    primarySchoolColor =  Colors.blue[900];
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'University of Central Flordia':
                    primarySchoolColor = Colors.black;
                    secondarySchoolColor = Colors.yellowAccent[700];
                    break;
                  case  'University of Colorado - Boulder':
                    primarySchoolColor =  Colors.yellow[100];
                    secondarySchoolColor = Colors.black;
                    break;
                  case 'University of Dayton':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.blue[900];
                    break;
                  case 'University of Delaware':
                    primarySchoolColor =  Colors.lightBlue;
                    secondarySchoolColor = Colors.yellowAccent[100];
                    break;
                  case 'University of Denver':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.yellowAccent;
                    break;
                  case 'University of Florida':
                    primarySchoolColor = Colors.blue[900];
                    secondarySchoolColor = Colors.deepOrange;
                    break;
                  case 'University of Georgia':
                    primarySchoolColor = Colors.black;
                    secondarySchoolColor = Colors.red[900];
                    break;
                  case 'University of Iowa':
                    primarySchoolColor =  Colors.black;
                    secondarySchoolColor = Colors.yellowAccent;
                    break;
                  case 'University of Kansas':
                    primarySchoolColor = Colors.blue;
                    secondarySchoolColor = Colors.red[900];
                    break;
                  case 'University of Louisiana - Lafayette':
                    primarySchoolColor =  Colors.red;
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'University of Maryland - College Park':
                    primarySchoolColor = Colors.black;
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'University of Massachusetts - Amherst':
                    primarySchoolColor =  Colors.black;
                    secondarySchoolColor = Colors.red[900];
                    break;
                  case 'University of Miami':
                    primarySchoolColor = Colors.deepOrange;
                    secondarySchoolColor = Colors.green[700];
                    break;
                  case 'University of Michigan - Ann Arbor':
                    primarySchoolColor =  Colors.blue[900];
                    secondarySchoolColor = Colors.yellowAccent;
                    break;
                  case 'University of Minnesota - Twin Cities':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.yellowAccent;
                    break;
                  case 'University of Mississippi':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.blue[900];
                    break;
                  case 'University of Missouri':
                    primarySchoolColor =  Colors.black;
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'University of Nebraska - Lincoln':
                    primarySchoolColor = Colors.red[700];
                    secondarySchoolColor = Colors.white;
                    break;
                  case  'University of North Carolina at Chapel Hill':
                    primarySchoolColor =  Colors.lightBlue;
                    secondarySchoolColor = Colors.blue[900];
                    break;
                  case 'University of Oklahoma':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'University of Oregon':
                    primarySchoolColor =  Colors.green[900];
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'University of Pennsylvania':
                    primarySchoolColor = Colors.blue[900];
                    secondarySchoolColor = Colors.redAccent[700];
                    break;
                  case 'University of Pittsburgh':
                    primarySchoolColor = Colors.blue[700];
                    secondarySchoolColor = Colors.yellow[100];
                    break;
                  case 'University of South Carolina':
                    primarySchoolColor = Colors.red[900];
                    secondarySchoolColor = Colors.black;
                    break;
                  case 'University of Tennessee':
                    primarySchoolColor =  Colors.deepOrange;
                    secondarySchoolColor = Colors.grey;
                    break;
                  case 'University of Texas - Austin':
                    primarySchoolColor = Colors.deepOrange;
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'University of Virginia':
                    primarySchoolColor =  Colors.blue[900];
                    secondarySchoolColor = Colors.deepOrange;
                    break;
                  case 'University of Washington':
                    primarySchoolColor = Colors.purple;
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'University of Wisconsin':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'University of Wisconsin - Oshkosh':
                    primarySchoolColor = Colors.black;
                    secondarySchoolColor = Colors.yellowAccent[400];
                    break;
                  case 'Vanderbilt University':
                    primarySchoolColor =  Colors.yellowAccent[400];
                    secondarySchoolColor = Colors.black;
                    break;
                  case 'Virginia Tech':
                    primarySchoolColor = Colors.deepOrange[400];
                    secondarySchoolColor = Colors.redAccent[400];
                    break;
                  case 'Washington State University':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.grey;
                    break;
                  case 'West Virginia University':
                    primarySchoolColor =  Colors.yellowAccent;
                    secondarySchoolColor = Colors.blue[900];
                    break;
                  case 'Western Illionis University':
                    primarySchoolColor = Colors.purple;
                    secondarySchoolColor = Colors.yellowAccent[700];
                    break;
                  case 'Western Michigan University':
                    primarySchoolColor =  Colors.brown;
                    secondarySchoolColor = Colors.yellowAccent;
                    break;
                  case 'Florida A&M University':
                    primarySchoolColor = Colors.green;
                    secondarySchoolColor = Colors.orange;
                    break;
                  case 'Florida State University':
                    primarySchoolColor =  Colors.red[900];
                    secondarySchoolColor = Colors.yellowAccent[100];
                    break;
                  case 'Georgia Southern University':
                    primarySchoolColor = Colors.lightBlue[900];
                    secondarySchoolColor = Colors.white;
                    break;
                  case 'Georgia State University':
                    primarySchoolColor = Colors.lightBlue[700];
                    secondarySchoolColor = Colors.white;
                    break;
                  default:
                    primarySchoolColor = Colors.black;
                    secondarySchoolColor = Colors.yellowAccent[400];
                }
                happy = value;
                var route = new MaterialPageRoute(
                    builder: (BuildContext context) =>
                    new SignUp(value: happy, primary: primarySchoolColor, secondary: secondarySchoolColor,)
                );
                Navigator.of(context).push(route);
              }
          ));}
//
    Widget _stoneName() {
      return new Container(
        padding: EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
        alignment: Alignment.topCenter,
        child:  new Text(
          'Stone',
          style: new TextStyle(
              fontSize: 130.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.w800,
              fontFamily: 'Gelio',
              color: Colors.black
          ),
        ),
      );
////      return new Container(
////      alignment: Alignment.topCenter,
////      constraints: BoxConstraints(
////        maxHeight: 100.0,
////        minHeight: 100.0,
////      ),
////      padding: EdgeInsets.only(bottom: 150.0),
//      child: new Text(
//        'Stone',
//        style: new TextStyle(
//            fontSize: 130.0,
//            fontStyle: FontStyle.normal,
//            fontWeight: FontWeight.w800,
//            fontFamily: 'Gelio',
//            color: Colors.black
//        ),
//      ),
////      );
    }
    Widget _theStone() {
      return new Container(
          alignment: Alignment.bottomCenter,
          child:  new Image.asset(
              'images/StoneHand.png'
          )
      );
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: new Container(
          child: new Center(
            child: new Stack(
              fit: StackFit.expand,
              children: <Widget>[
                _stoneName(),
                _theStone(),
                _dropDown(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}