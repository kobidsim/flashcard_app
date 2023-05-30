import 'dart:collection';

import 'package:flashcard_app/entities/flash_card.dart';

class Deck {
  final String _name;
  List<FlashCard>? _cards;

  Deck(this._name) {
    _cards = <FlashCard>[];
  }

  //counts the cards of the specific status
  int findCardsOfType(CardStatus status) {
    int count = 0;
    for (var card in _cards ?? <FlashCard>[]) {
      if (card.status == status) {
        count++;
      }
    }
    return count;
  }

  //counts how many cards are to be reviewed at the moment
  int toBeReviewed() {
    int count = 0;
    for (var card in _cards ?? <FlashCard>[]) {
      if (!card.reviewed) {
        count++;
      }
    }
    return count;
  }

  void addCard(String front, String back) =>
      _cards!.add(FlashCard(front, back, <String>[]));

  String get name => _name;
  int get noOfCards => (_cards!.length);
  UnmodifiableListView<FlashCard> get cards =>
      UnmodifiableListView(_cards ?? <FlashCard>[]);
}
