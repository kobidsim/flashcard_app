import 'dart:collection';

import 'package:flashcard_app/entities/flash_card.dart';

class Deck {
  final String _name;
  List<FlashCard>? _cards;

  Deck(this._name) {
    _cards = <FlashCard>[];
  }

  //counts how many fresh new cards exist and returns the count
  int freshNewCards() {
    int count = 0;
    _cards!.map((card) => (card.status == CardStatus.new_ ? count++ : count));
    return count;
  }

  //counts how many cards are to be reviewed at the moment
  int toBeReviewed() {
    int count = 0;
    _cards!.map((card) => (!card.reviewed ? count++ : count));
    return count;
  }

  void addCard(String front, String back) =>
      _cards!.add(FlashCard(front, back, <String>[]));

  String get name => _name;
  int get noOfCards => (_cards!.length);
  UnmodifiableListView<FlashCard> get cards =>
      UnmodifiableListView(_cards ?? <FlashCard>[]);
}
