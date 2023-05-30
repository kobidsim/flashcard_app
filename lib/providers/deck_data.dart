import 'dart:collection';

import 'package:flashcard_app/entities/flash_card.dart';
import 'package:flutter/material.dart';
import 'package:flashcard_app/entities/user.dart';
import 'package:flashcard_app/entities/deck.dart';

//provides a particular deck's data
class DeckData extends ChangeNotifier {
  Deck? _deck;

  Deck? get deck => _deck;
  int get totalCards => (_deck!.noOfCards);
  int get redCards => _deck!.findCardsOfType(CardStatus.red);
  int get yellowCards => _deck!.findCardsOfType(CardStatus.yellow);
  int get greenCards => _deck!.findCardsOfType(CardStatus.green);
  int get freshNewCards => (_deck!.findCardsOfType(CardStatus.new_));
  int get toBeReviewed => (_deck!.toBeReviewed());
  UnmodifiableListView<FlashCard> get cards => _deck!.cards;

  //set which deck's data we need provided
  set initDeck(String deckName) => _deck = user.deck(deckName);

  void addCard(String front, String back) {
    _deck!.addCard(front, back);
    notifyListeners();
  }
}
