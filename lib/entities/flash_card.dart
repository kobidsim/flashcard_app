enum CardStatus { red, yellow, green, new_ }

class FlashCard {
  String _front = "";
  String _back = "";
  CardStatus _status = CardStatus.new_;
  //_reviewed is True for cards that don't need to be currently reviewed
  //it is not the same as CardStatus.new_
  bool? _reviewed;
  List<String> _tags = [];

  //constructor
  FlashCard(String front, String back, List<String> tags) {
    _front = front;
    _back = back;
    _tags = tags;
    _status = CardStatus.new_;
    _reviewed = false;
  }

  //getters
  String get front => _front;
  String get back => _back;
  CardStatus get status => _status;
  bool get reviewed => _reviewed ?? false;

  //setters
  set setFront(String front) => _front = front;
  set setBack(String back) => _back = back;

  //methods
  bool hasTag(String tag) => _tags.contains(tag);
}
