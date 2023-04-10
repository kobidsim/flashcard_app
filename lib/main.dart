import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

//user data
List<String> decks = <String>["hyatteri 1", "Deck 2", "Deck 3"];

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
        backgroundColor: theme.colorScheme.secondary,
        appBar: AppBar(
          title: const Text('My Decks'),
        ),
        body: DeckList(decks: decks),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {},
          tooltip: 'Add Deck',
          child: const Icon(Icons.add),
        ));
  }
}

class DeckList extends StatelessWidget {
  const DeckList({required this.decks, super.key});

  final List<String> decks;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return GridView.builder(
        itemCount: decks.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 2, crossAxisSpacing: 2, crossAxisCount: 2),
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: theme.colorScheme.onSecondary,
            child: Center(
              child: Text(
                decks[index],
                style: theme.textTheme.headlineSmall,
              ),
            ),
          );
        });
  }
}
