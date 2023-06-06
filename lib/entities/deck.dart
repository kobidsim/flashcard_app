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

  List<FlashCard> cardsToStudy() {
    DateTime now = DateTime.now();
    List<FlashCard> unreviewedCards = <FlashCard>[];
    for (var card in _cards ?? <FlashCard>[]) {
      //for testing scheduling algorithm
      //if (true) {
      if (now.isAfter(card.scheduledFor)) {
        unreviewedCards.add(card);
      }
    }
    return unreviewedCards;
  }

  //counts how many cards are to be reviewed at the moment
  int get toBeReviewed {
    DateTime now = DateTime.now();
    int count = 0;
    for (var card in _cards ?? <FlashCard>[]) {
      if (now.isAfter(card.scheduledFor)) {
        count++;
      }
    }
    return count;
    //return _cards!.length; //for testing scheduling algorithm
  }

  void addCard(String front, String back) =>
      _cards!.add(FlashCard(front, back, <String>[]));

  void changeCardStatus(FlashCard card, CardStatus status) {
    for (var c in _cards ?? <FlashCard>[]) {
      if (c.front == card.front && c.back == card.back) {
        c.setStatus = status;
        c.reviewed = true;
        c.changeCardStatus(status);
      }
    }
  }

  void removeCard(String front, String back) {
    FlashCard? toRemove;
    for (var card in _cards ?? []) {
      if (front == card.front && back == card.back) {
        toRemove = card;
        break;
      }
    }
    _cards!.remove(toRemove);
  }

  String get name => _name;
  int get noOfCards => (_cards!.length);
  UnmodifiableListView<FlashCard> get cards =>
      UnmodifiableListView(_cards ?? <FlashCard>[]);
}
