import 'dart:collection';

import 'package:flashcard_app/entities/deck.dart';

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

  set addDeck(Deck deck) => _decks!.add(deck);

  Deck? deck(String deckName) {
    for (var deck in (_decks ?? <Deck>[])) {
      if (deck.name == deckName) return deck;
    }
    return null;
  }
}

User user = User("Kobid Simkhada");
