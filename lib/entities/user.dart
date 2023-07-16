import 'dart:collection';
import 'dart:math';
import 'package:flashcard_app/entities/deck.dart';
import 'package:flutter/cupertino.dart';

class User {
  String _username = "";
  late int _id;
  List<Deck>? _decks;
  late int _xp;

  User(String uname) {
    _username = uname;
    _decks = <Deck>[];
    _id = _xp = 0;
  }

  String get name => _username;
  UnmodifiableListView<Deck> get decks =>
      UnmodifiableListView(_decks ?? <Deck>[]);
  int get deckXp => (_decks!.isNotEmpty
      ? _decks!.map((deck) => deck.totalXp).reduce((a, b) => a + b)
      : 0);

  int get xp {
    _xp = _xp + max(deckXp - _xp, 0);
    return _xp;
  }

  set addDeck(Deck deck) => _decks!.add(deck);

  Deck? deck(String deckName) {
    for (var deck in (_decks ?? <Deck>[])) {
      if (deck.name == deckName) return deck;
    }
    return null;
  }

  void removeDeck(String deckName) {
    debugPrint("DEBUG::DELETE:: user deleting $deckName");
    Deck? toRemove;
    for (var deck in _decks ?? []) {
      debugPrint("DEBUG::DELETE:: iterating");
      if (deck.name == deckName) {
        toRemove = deck;
        break;
      }
    }
    if (toRemove != null) {
      _decks!.remove(toRemove);
    }
  }
}

User user = User("Kobid Simkhada");
