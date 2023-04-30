import 'package:flutter/material.dart';
import 'dart:collection';

class DeckData extends ChangeNotifier {
  final List<String> _decks = <String>[];

  UnmodifiableListView<String> get items => UnmodifiableListView(_decks);

  int get noOfDecks => _decks.length;

  void addToDeck(String deck) {
    _decks.add(deck);
    notifyListeners();
  }
}
