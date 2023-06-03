import 'dart:math';

import 'package:flutter/material.dart';

enum CardStatus { red, yellow, green, new_ }

class Performance {
  int streak = 0;
  double eFactor = 2.5;
  double interval = 0.0;
  Performance(this.streak, this.eFactor, this.interval);
}

class FlashCard {
  String _front = "";
  String _back = "";
  CardStatus _status = CardStatus.new_;
  //_reviewed is True for cards that don't need to be currently reviewed
  //it is not the same as CardStatus.new_
  bool? _reviewed;
  List<String> _tags = [];
  Performance _performance = Performance(0, 2.5, 0.5);
  DateTime _scheduledFor = DateTime.now();

  //constructor
  FlashCard(String front, String back, List<String> tags) {
    _front = front;
    _back = back;
    _tags = tags;
    _status = CardStatus.new_;
    _reviewed = false;
    _scheduledFor = DateTime.now();
  }

  //getters
  String get front => _front;
  String get back => _back;
  CardStatus get status => _status;
  bool get reviewed => _reviewed!;
  DateTime get scheduledFor => _scheduledFor;

  //setters
  set setFront(String front) => _front = front;
  set setBack(String back) => _back = back;
  set setStatus(CardStatus status) => _status = status;
  set reviewed(bool review) => _reviewed = review;

  //methods
  bool hasTag(String tag) => _tags.contains(tag);

  //the SR algorithm that updates the Performance object of the card
  Performance updatePerformance(int score, double lateness) {
    Performance previous = _performance;
    int streak;
    double eFactor, interval;

    lateness = (lateness < 0)
        ? 0
        : lateness; //if lateness is -ve it means we are early which means not late at all
    double normScore = score - 1; //normalizing from -1 to 1
    double latenessPercent = min(lateness, previous.interval) /
        previous
            .interval; //calculating how late the user is based on the given interval of the card
    double normLateness = 2 * (latenessPercent) - 1;
    //currently this form of efactor calculation treats Easy and Medium score as the same thing when scheduled
    eFactor = min(max(1.3, previous.eFactor + (normLateness + normScore)), 2.5);
    /* debugPrint("DEBUG::SCHEDULING:: lateness = $lateness");
    debugPrint("DEBUG::SCHEDULING:: latenessPercent = $latenessPercent");
    debugPrint("DEBUG::SCHEDULING:: Prev Interval = $normLateness"); */
    debugPrint(
        "DEBUG::SCHEDULING:: previous efactor of $_status = ${previous.eFactor}");
    debugPrint("DEBUG::SCHEDULING:: normLateness = $normLateness");
    debugPrint("DEBUG::SCHEDULING:: normScore = $normScore");
    debugPrint("DEBUG::SCHEDULING:: efactor of $_status = $eFactor");

    if (score < 1) {
      //this has an issue, if a card is hard but it was easy before,
      // the algorithm doesen't account for the fact that it was easy before
      streak = 0;
      interval = 0.5;
    } else {
      streak = previous.streak + 1;
      interval = previous.interval * eFactor;
    }

    return Performance(streak, eFactor, interval);
  }

  void changeCardStatus(CardStatus status) {
    DateTime reviewTime = DateTime.now();
    Duration lateness = reviewTime.difference(_scheduledFor);
    _performance =
        updatePerformance(status.index, (lateness.inHours.toDouble() / 24.0));
    Duration intervalDuration = Duration(days: _performance.interval.toInt());
    _scheduledFor = _scheduledFor.add(intervalDuration);
    /* debugPrint(
        "DEBUG::SCHEDULING:: Current Date = ${DateTime.now().year}/${DateTime.now().month}/${DateTime.now().day}"); */
    debugPrint(
        "DEBUG::SCHEDULING:: Card Scheduled For = ${_scheduledFor.year}/${_scheduledFor.month}/${_scheduledFor.day}");
  }
}
