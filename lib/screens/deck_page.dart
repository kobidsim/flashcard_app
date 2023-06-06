import 'package:flashcard_app/providers/deck_data.dart';
import 'package:flashcard_app/screens/study_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math' as math;
import 'package:sticky_headers/sticky_headers.dart';

class DeckPage extends StatefulWidget {
  const DeckPage({required this.deckName, super.key});
  final String deckName;

  @override
  State<DeckPage> createState() => _DeckPageState();
}

class _DeckPageState extends State<DeckPage> {
  @override
  Widget build(BuildContext context) {
    //figure out why deckName is not defined
    Provider.of<DeckData>(context, listen: false).initDeck = widget.deckName;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.deckName),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
        child: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            //total cards on deck and progress bar
            const Padding(
                padding: EdgeInsets.fromLTRB(0, 20, 0, 20),
                child: TotalCards()),
            const SizedBox(
              height: 25,
            ),
            //information box
            const DeckSummary(),
            //study button navigates to study page
            const SizedBox(
              height: 5,
            ),
            SizedBox(
              height: 80,
              width: 343,
              child: ElevatedButton(
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0))),
                  ),
                  onPressed: () => {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => StudyPage(
                                flashCards: Provider.of<DeckData>(context,
                                        listen: false)
                                    .cardsToStudy)))
                      },
                  child: const Text("Study Cards")),
            ),
            const SizedBox(
              height: 25,
            ),
            //Cards Search section heading(text and add button)
            CardList(),
          ]),
        ),
      ),
    );
  }
}

//The whole Card List, Add and Search part of the page
class CardList extends StatelessWidget {
  CardList({super.key});
  final cardFrontText = TextEditingController();
  final cardBackText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return StickyHeader(
        header: CardListHeader(
            cardFrontText: cardFrontText, cardBackText: cardBackText),

        //listview for all the available cards
        content: Consumer<DeckData>(builder: (context, deck, child) {
          return ListView.builder(
              //the 2 lines below, I don't really understand
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              primary: false,
              itemCount: deck.totalCards,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.card_giftcard),
                  //currently only showing the front text of the card but
                  //need to make this better somehow
                  title: Text(deck.cards[index].front),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => deck.removeCard(
                        deck.cards[index].front, deck.cards[index].back),
                  ),
                );
              });
        }));
  }
}

class CardListHeader extends StatelessWidget {
  const CardListHeader({
    super.key,
    required this.cardFrontText,
    required this.cardBackText,
  });

  final TextEditingController cardFrontText;
  final TextEditingController cardBackText;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 120,
      decoration: const BoxDecoration(color: Colors.white),
      child: Column(
        children: [
          Row(
            children: [
              const Text("Cards"),
              ElevatedButton.icon(
                  onPressed: () => {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Card Info"),
                                content: Column(
                                  children: [
                                    const Text("Front:"),
                                    TextField(
                                      autofocus: true,
                                      controller: cardFrontText,
                                      decoration: const InputDecoration(
                                          hintText: 'Front of the card...'),
                                    ),
                                    const Text("Back:"),
                                    TextField(
                                      autofocus: false,
                                      controller: cardBackText,
                                      decoration: const InputDecoration(
                                          hintText: 'Back of the card...'),
                                    ),
                                  ],
                                ),
                                actions: [
                                  TextButton(
                                      //submitting the user's input to controller
                                      //to add a card to deck
                                      onPressed: () {
                                        if (cardFrontText.text != "" &&
                                            cardBackText.text != "") {
                                          Provider.of<DeckData>(context,
                                                  listen: false)
                                              .addCard(cardFrontText.text,
                                                  cardBackText.text);
                                          cardFrontText.text = "";
                                          cardBackText.text = "";
                                        }
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text("OK"))
                                ],
                              );
                            })
                      },
                  icon: const Icon(Icons.add),
                  label: const Text("Add")),
            ],
          ),

          //search field for searching cards
          const TextField(
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: "Search by tags...",
            ),
          ),
        ],
      ),
    );
  }
}

class DeckSummary extends StatelessWidget {
  const DeckSummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Card(
        color: Theme.of(context).colorScheme.secondary,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        child: Consumer<DeckData>(builder: (context, deck, child) {
          int newCards = deck.freshNewCards;
          int toReview = deck.toBeReviewed;
          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //not studied
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("$newCards"), const Text("Not Studied")],
              ),
              //To Review
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [Text("$toReview"), const Text("To Review")],
              )
            ],
          );
        }),
      ),
    );
  }
}

class TotalCards extends StatelessWidget {
  const TotalCards({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DeckData>(builder: (context, deck, child) {
      int? totalCards = deck.totalCards;
      return Stack(children: [
        SizedBox(
            height: 200,
            width: 200,
            child: CustomPaint(
              painter: CircularProgressBar(
                total: (deck.totalCards.toDouble() == 0
                    ? 1
                    : deck.totalCards.toDouble()),
                red: deck.redCards.toDouble(),
                yellow: deck.yellowCards.toDouble(),
                green: deck.greenCards.toDouble(),
              ),
            )),
        SizedBox(
          height: 200,
          width: 200,
          child: Center(
              child: Text(
            "$totalCards",
            style: Theme.of(context).textTheme.displayMedium,
          )),
        )
      ]);
    });
  }
}

class CircularProgressBar extends CustomPainter {
  CircularProgressBar({
    required this.total,
    required this.red,
    required this.yellow,
    required this.green,
  });

  final double total;
  final double red;
  final double yellow;
  final double green;

  @override
  void paint(Canvas canvas, Size size) {
    double redRatio = red / total;
    double yellowRatio = yellow / total;
    double greenRatio = green / total;
    double greyRatio = 1 - redRatio - yellowRatio - greenRatio;

    double redStart = math.pi / 2;
    double redSweep = (math.pi * 2) * redRatio;
    double yellowStart = redStart + redSweep;
    double yellowSweep = (math.pi * 2) * yellowRatio;
    double greenStart = yellowStart + yellowSweep;
    double greenSweep = (math.pi * 2) * greenRatio;
    double greyStart = greenStart + greenSweep;
    double greySweep = (math.pi * 2) * greyRatio;

    var rect = Rect.fromLTWH(0, 0, size.width, size.height);
    var greyPaint = Paint()
      ..color = Colors.grey
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;
    var redPaint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;
    var yellowPaint = Paint()
      ..color = Colors.yellow
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;
    var greenPaint = Paint()
      ..color = Colors.green
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    //debugPrint(
    //    "DEBUG::\nred ratio: $redStart\nyellow ratio: $yellowStart\ngreen ratio: $greenStart\ngrey ratio: $greyStart");

    arc(canvas, redStart, redSweep, redPaint, rect);
    arc(canvas, yellowStart, yellowSweep, yellowPaint, rect);
    arc(canvas, greenStart, greenSweep, greenPaint, rect);
    arc(canvas, greyStart, greySweep, greyPaint, rect);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    return false;
  }
}

void arc(Canvas canvas, double start, double sweep, Paint paint, Rect rect) {
  canvas.drawArc(rect, start, sweep, false, paint);
}
