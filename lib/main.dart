import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => DeckData(), child: const MyApp()));
}

//user data provider
class DeckData extends ChangeNotifier {
  final List<String> _decks = <String>[];

  UnmodifiableListView<String> get items => UnmodifiableListView(_decks);

  int get noOfDecks => _decks.length;

  void addToDeck(String deck) {
    _decks.add(deck);
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FlashCard App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Text('My Decks'),
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

    return Consumer<DeckData>(builder: (context, decks, child) {
      return ListView.builder(
          itemCount: decks.noOfDecks,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              color: theme.colorScheme.surface,
              child: ListTile(
                leading: const Icon(Icons.book),
                title: Text(
                  decks.items[index],
                  style: TextStyle(color: theme.colorScheme.onSurface),
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
                          Provider.of<DeckData>(context, listen: false)
                              .addToDeck(inputController.text);
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
