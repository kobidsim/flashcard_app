enum CardStatus { red, yellow, green, new_ }

class FlashCard {
  String front = "";
  String back = "";
  CardStatus status = CardStatus.new_;
  bool studied = false;
  List<String> tags = [];

  //constructor
  FlashCard(this.front, this.back, this.tags);

  //getters
  String get getFront => front;
  String get getBack => back;
  CardStatus get getStatus => status;
  bool get hasBeenStudied => studied;

  //setters
  set setFront(String front) => this.front = front;
  set setBack(String back) => this.back = back;

  //methods
  bool hasTag(String tag) => tags.contains(tag);
}
