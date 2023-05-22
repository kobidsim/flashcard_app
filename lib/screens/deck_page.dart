import 'package:flashcard_app/providers/deck_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
      body: Center(
        child: Column(children: [
          //total cards on deck and progress bar
          const TotalCards(),
          //information box
          const DeckSummary(),
          //study button navigates to study page
          ElevatedButton(onPressed: () => {}, child: const Text("Study Cards")),
          //Cards Search section heading(text and add button)
          CardSearch(),
        ]),
      ),
    );
  }
}

//The whole Card List, Add and Search part of the page
class CardSearch extends StatelessWidget {
  CardSearch({super.key});
  final cardFrontText = TextEditingController();
  final cardBackText = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
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

        //listview for all the available cards
        Consumer<DeckData>(builder: (context, deck, child) {
          return ListView.builder(
              //the 2 lines below, I don't really understand
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: deck.totalCards,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  onTap: () {},
                  leading: const Icon(Icons.card_giftcard),
                  //currently only showing the front text of the card but
                  //need to make this better somehow
                  title: Text(deck.cards[index].front),
                );
              });
        })
      ],
    );
  }
}

class DeckSummary extends StatelessWidget {
  const DeckSummary({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DeckData>(builder: (context, deck, child) {
      int newCards = deck.freshNewCards;
      int toReview = deck.toBeReviewed;
      return Row(
        children: [
          //not studied
          Column(
            children: [Text("$newCards"), const Text("Not Studied")],
          ),
          //To Review
          Column(
            children: [Text("$toReview"), const Text("To Review")],
          )
        ],
      );
    });
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
      return Center(child: Text("$totalCards"));
    });
  }
}
