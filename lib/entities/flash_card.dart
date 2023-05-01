enum CardStatus { red, yellow, green, new_ }

class FlashCard {
  String _front = "";
  String _back = "";
  CardStatus _status = CardStatus.new_;
  bool? _studied;
  List<String> _tags = [];

  //constructor
  FlashCard(String front, String back, List<String> tags) {
    _front = front;
    _back = back;
    _tags = tags;
    _status = CardStatus.new_;
    _studied = false;
  }

  //getters
  String get getFront => _front;
  String get getBack => _back;
  CardStatus get getStatus => _status;

  //setters
  set setFront(String front) => _front = front;
  set setBack(String back) => _back = back;

  //methods
  bool hasTag(String tag) => _tags.contains(tag);
}
