import 'package:flutter/material.dart';
import 'dart:collection';
import 'package:flashcard_app/entities/user.dart';
import 'package:flashcard_app/entities/deck.dart';

class DeckData extends ChangeNotifier {
  final UnmodifiableListView<Deck> _decks = user.decks;

  UnmodifiableListView<Deck> get items => _decks;
  int get noOfDecks => _decks.length;
  List<String> get deckNames => _decks.map((deck) => deck.name).toList();

  void addToDeck(String deck) {
    user.addDeck = Deck(deck);
    notifyListeners();
  }
}
