import 'package:flashcard_app/entities/flash_card.dart';
import 'package:flashcard_app/providers/deck_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum ReviewButtonType { easy, medium, hard }

class StudyPage extends StatefulWidget {
  const StudyPage({required this.flashCards, super.key});
  final List<FlashCard> flashCards;
  @override
  State<StudyPage> createState() => _StudyPageState();
}

class _StudyPageState extends State<StudyPage> {
  bool shown = false;
  List<MyCard> cards = <MyCard>[];

  void show() {
    setState(() {
      shown = true;
    });
  }

  void hide() {
    setState(() {
      shown = false;
    });
  }

  List<MyCard> initStackOfCards() {
    List<MyCard> cards = <MyCard>[];
    for (var flashCard in widget.flashCards) {
      cards.add(MyCard(
        flashCard: flashCard,
        shown: shown,
        show: show,
      ));
    }
    return cards;
  }

  void removeCard(CardStatus status) {
    if (widget.flashCards.isNotEmpty) {
      Provider.of<DeckData>(context, listen: false)
          .changeCardStatus(widget.flashCards.last, status);
      hide();
      setState(() {
        widget.flashCards.removeLast();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("DEBUG:: flashCards length = ${widget.flashCards.length}");
    cards = initStackOfCards();
    debugPrint("DEBUG:: cards length = ${cards.length}");

    final List<Widget> reviewButtons = [
      Expanded(
        child:
            ReviewButton(type: ReviewButtonType.easy, removeCard: removeCard),
      ),
      Expanded(
        child:
            ReviewButton(type: ReviewButtonType.medium, removeCard: removeCard),
      ),
      Expanded(
        child:
            ReviewButton(type: ReviewButtonType.hard, removeCard: removeCard),
      )
    ];
    final List<Widget> textMessage = [
      Center(
          child: SizedBox(
        height: 70,
        child: Text(
          "Tap the card to show answer",
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ))
    ];

    return Container(
      decoration:
          BoxDecoration(color: Theme.of(context).colorScheme.inversePrimary),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CardStack(cards: cards),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: shown ? reviewButtons : textMessage,
          )
        ],
      ),
    );
  }
}

class CardStack extends StatelessWidget {
  const CardStack({
    super.key,
    required this.cards,
  });

  final List<MyCard> cards;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 70, 10, 50),
        child: Stack(
          children: [
            Center(
              child: Text(
                "All done!",
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            ...cards
          ],
        ),
      ),
    );
  }
}

//buttons for user to rate their performance
class ReviewButton extends StatelessWidget {
  const ReviewButton({required this.type, required this.removeCard, super.key});
  final ReviewButtonType type;
  final Function removeCard;

  @override
  Widget build(BuildContext context) {
    String buttonText = (type == ReviewButtonType.easy
        ? "Easy"
        : (type == ReviewButtonType.medium ? "Medium" : "Hard"));
    CardStatus status = (type == ReviewButtonType.easy
        ? CardStatus.green
        : (type == ReviewButtonType.medium
            ? CardStatus.yellow
            : CardStatus.red));
    return SizedBox(
      height: 70,
      child: TextButton(
        onPressed: () {
          removeCard(status);
        },
        style: ButtonStyle(
            backgroundColor: type == ReviewButtonType.easy
                ? MaterialStateProperty.all<Color>(Colors.green)
                : (type == ReviewButtonType.medium
                    ? MaterialStateProperty.all<Color>(Colors.yellow)
                    : MaterialStateProperty.all<Color>(Colors.red))),
        child: Text(
          buttonText,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
    );
  }
}

//flashcard
class MyCard extends StatefulWidget {
  final FlashCard flashCard;
  final bool shown;
  final void Function()? show;
  const MyCard(
      {required this.flashCard,
      required this.shown,
      required this.show,
      super.key});

  @override
  State<MyCard> createState() => _MyCardState();
}

class _MyCardState extends State<MyCard> {
  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.titleLarge;
    List<Widget> before = [
      Text(
        "Q: ${widget.flashCard.front}",
        style: textStyle,
      ),
    ];

    List<Widget> after = [
      Text(
        "Q: ${widget.flashCard.front}",
        style: textStyle,
      ),
      const Divider(),
      Text(
        "A: ${widget.flashCard.back}",
        style: textStyle,
      ),
    ];

    return SizedBox(
      width: double.infinity,
      child: GestureDetector(
        onTap: widget.show,
        child: Card(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.shown ? after : before),
        ),
      ),
    );
  }
}
