import 'package:flashcard_app/providers/deck_data.dart';
import 'package:flashcard_app/providers/user_data.dart';
import 'package:flashcard_app/screens/deck_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/deck_list_data.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text(
          'My Decks',
        ),
        actions: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: GestureDetector(
                  onTap: () {
                    showUserInfo(context);
                  },
                  child: const Icon(Icons.supervised_user_circle)))
        ],
      ),
      body: const DeckList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: AddDeckButton(),
    );
  }
}

class DeckList extends StatelessWidget {
  const DeckList({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final cardsForToday =
        Provider.of<DeckData>(context, listen: true).toBeReviewed;

    return Consumer<DeckListData>(builder: (context, decks, child) {
      return ListView.builder(
          itemCount: decks.noOfDecks,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: theme.colorScheme.surface,
              child: ListTile(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => DeckPage(
                            deckName: decks.items[index].name,
                          )));
                },
                leading: const Icon(Icons.book),
                title: Text(
                  decks.deckNames[index],
                  style: TextStyle(
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                subtitle: Text("Cards for today: $cardsForToday"),
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () =>
                      decks.removeFromDeckList(decks.items[index].name),
                ),
              ),
            );
          });
    });
  }
}

class AddDeckButton extends StatelessWidget {
  AddDeckButton({super.key});
  final inputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showDialog(
            barrierDismissible: true,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Name:"),
                content: TextField(
                  autofocus: true,
                  controller: inputController,
                  decoration: const InputDecoration(
                      hintText: 'Enter name of your Deck'),
                ),
                actions: [
                  TextButton(
                      onPressed: () {
                        if (inputController.text != "") {
                          Provider.of<DeckListData>(context, listen: false)
                              .addToDeckList(inputController.text);
                          inputController.text = "";
                        }
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"))
                ],
              );
            });
      },
      tooltip: 'Add Deck',
      child: const Icon(Icons.add),
    );
  }
}

void showUserInfo(BuildContext context) {
  showDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      final username = Provider.of<UserData>(context, listen: true).name;
      final xp = Provider.of<UserData>(context, listen: true).xp;
      return AlertDialog(
        title: const Text("User Info"),
        content: Center(child: Text("Username: $username\nXP: $xp")),
      );
    },
  );
}
