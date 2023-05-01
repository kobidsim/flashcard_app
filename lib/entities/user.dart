import 'dart:collection';

import 'package:flashcard_app/entities/deck.dart';

class User {
  String _name = "";
  final List<Deck> _decks = <Deck>[];

  User(String name) {
    _name = name;
  }

  String get name => _name;
  UnmodifiableListView<Deck> get decks => UnmodifiableListView(_decks);

  set addDeck(Deck deck) => _decks.add(deck);
}

User user = User("Kobid Simkhada");
