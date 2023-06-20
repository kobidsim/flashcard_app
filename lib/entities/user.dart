import 'dart:collection';

import 'package:flashcard_app/entities/deck.dart';
import 'package:flutter/cupertino.dart';

class User {
  String _name = "";
  List<Deck>? _decks;

  User(String name) {
    _name = name;
    _decks = <Deck>[];
  }

  String get name => _name;
  UnmodifiableListView<Deck> get decks =>
      UnmodifiableListView(_decks ?? <Deck>[]);
  int get xp => (_decks!.isNotEmpty
      ? _decks!.map((deck) => deck.totalXp).reduce((a, b) => a + b)
      : 0);

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
