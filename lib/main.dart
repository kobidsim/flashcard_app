import 'package:flashcard_app/providers/deck_data.dart';
import 'package:flashcard_app/providers/deck_list_data.dart';
import 'package:flashcard_app/providers/user_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flashcard_app/keys.dart';

void main() async {
  await Supabase.initialize(url: URL, anonKey: ANON);
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (context) => DeckListData()),
    ChangeNotifierProvider(create: (context) => DeckData()),
    ChangeNotifierProvider(create: (context) => UserData())
  ], child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FlashCard App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const MyHomePage(),
    );
  }
}

var supabase = Supabase.instance.client;
