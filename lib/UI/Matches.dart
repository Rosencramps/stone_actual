import 'package:flutter/cupertino.dart';
import './MainPage.dart';


class MatchEngine extends ChangeNotifier {
  final List<DateMatch> _matches;
  int _currentMatchIndex;
  int _nextMatchIndex;

  MatchEngine({
    List<DateMatch> matches,
  }) : _matches = matches {
    _currentMatchIndex = 0;
    _nextMatchIndex = 1;
  }

  DateMatch get currentMatch => _matches[_currentMatchIndex];
  DateMatch get nextMatch => _matches[_nextMatchIndex];

  void cycleMatch() {
    if (currentMatch.decision != Decision.undecided) {
      currentMatch.reset();

      _currentMatchIndex = _nextMatchIndex;
      _nextMatchIndex = _nextMatchIndex < _matches.length - 1 ? _nextMatchIndex + 1 : 0;
      print(_currentMatchIndex);
      print(_nextMatchIndex);

      notifyListeners();
    }
  }
}

class DateMatch extends ChangeNotifier {
  final profileCard profilecard;
  final mainPage profile;
  Decision decision = Decision.undecided;

  DateMatch({
    this.profilecard,
    this.profile
  });

  void like() {
    if (decision == Decision.undecided) {
      decision = Decision.like;
      notifyListeners();
      print(decision);
    }
  }

  void nope() {
    if (decision == Decision.undecided) {
      decision = Decision.nope;
      notifyListeners();
    }
  }
  void reset() {
    if (decision != Decision.undecided) {
      decision = Decision.undecided;
      notifyListeners();
    }
  }
}


enum Decision {
  undecided,
  nope,
  like
}









































//import 'package:flutter/cupertino.dart';
//import 'package:stone_actual/UI/profiles.dart';
//
//
//class MatchEngine extends ChangeNotifier {
//  final List<DateMatch> _matches;
//  int _currentMatchIndex;
//  int _nextMatchIndex;
//
//  MatchEngine({
//    List<DateMatch> matches,
//  }) : _matches = matches {
//    _currentMatchIndex = 0;
//    _nextMatchIndex = 1;
//  }
//
//  DateMatch get currentMatch => _matches[_currentMatchIndex];
//  DateMatch get nextMatch => _matches[_nextMatchIndex];
//
//  void cycleMatch() {
//    if (currentMatch.decision != Decision.undecided) {
//      currentMatch.reset();
//
//      _currentMatchIndex = _nextMatchIndex;
//      _nextMatchIndex = _nextMatchIndex < _matches.length - 1 ? _nextMatchIndex + 1 : 0;
//
//      notifyListeners();
//    }
//  }
//}
//
//class DateMatch extends ChangeNotifier {
//  final Profile profile;
//  Decision decision = Decision.undecided;
//
//  DateMatch({
//    this.profile,
//  });
//
//  void like() {
//    if (decision == Decision.undecided) {
//      decision = Decision.like;
//      notifyListeners();
//    }
//  }
//
//  void nope() {
//    if (decision == Decision.undecided) {
//      decision = Decision.nope;
//      notifyListeners();
//    }
//  }
//  void reset() {
//    if (decision != Decision.undecided) {
//      decision = Decision.undecided;
//      notifyListeners();
//    }
//  }
//}
//
//
//enum Decision {
//  undecided,
//  nope,
//  like
//}
