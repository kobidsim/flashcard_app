import 'dart:collection';
import 'dart:math';
import 'package:flashcard_app/entities/deck.dart';
import 'package:flutter/cupertino.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as sb;

import '../main.dart';

class User {
  sb.User? _user;
  sb.Session? _session;
  String _username = "";
  late String _id;
  List<Deck>? _decks;
  late int _xp;

  User(String uname, {String id = "", int xp = 0}) {
    _username = uname;
    _decks = <Deck>[];
    _id = id;
    _xp = xp;
    _user = null;
    _session = null;
  }

  String get username => _username;
  String get id => _id;
  UnmodifiableListView<Deck> get decks =>
      UnmodifiableListView(_decks ?? <Deck>[]);
  int get deckXp => (_decks!.isNotEmpty
      ? _decks!.map((deck) => deck.totalXp).reduce((a, b) => a + b)
      : 0);
  sb.User? get user => _user;
  sb.Session? get session => _session;
  int get xp {
    _xp = _xp + max(deckXp - _xp, 0);
    return _xp;
  }

  set addDeck(Deck deck) => _decks!.add(deck);

  Deck? deck(String deckName) {
    for (var deck in (_decks ?? <Deck>[])) {
      if (deck.name == deckName) return deck;
    }
    return null;
  }

  void removeDeck(String deckName) {
    debugPrint("DEBUG::DELETE:: user deleting $deckName");
    Deck? toRemove;
    for (var deck in _decks ?? []) {
      debugPrint("DEBUG::DELETE:: iterating");
      if (deck.name == deckName) {
        toRemove = deck;
        break;
      }
    }
    if (toRemove != null) {
      _decks!.remove(toRemove);
    }
  }

  Future<bool> signUp(String username, String email, String password) async {
    bool success = false;
    await supabase.auth.signUp(
        email: email,
        password: password,
        data: {"username": username, "xp": "$_xp"}).then((res) {
      _user = res.user;
      _username = username;
      //the session is null for some reason
      _session = res.session;
      _id = _user!.id;
      success = true;
    }).catchError((error) => debugPrint("$error"));

    return success;
  }

  Future<bool> signIn(String email, String password) async {
    var success = false;
    await supabase.auth
        .signInWithPassword(password: password, email: email)
        .then((res) async {
      _user = res.user;
      //this session sometimes work sometimes don't work
      _session = res.session;
      _id = res.user!.id;
      _username = res.user!.userMetadata!["username"];
      final data = await supabase.from("profiles").select("xp").eq("id", _id);
      //also need to get decks
      _xp = int.parse(data[0]["xp"]);
      debugPrint("DEBUG:: xp = $_xp");
      success = true;
    }).catchError((error) => debugPrint("$error"));

    return success;
  }

  Future<bool> signOut() async {
    bool success = false;
    await supabase.auth.signOut().then((res) {
      _username = "Default User";
      _user = null;
      _session = null;
      _id = "";
      _decks = <Deck>[];
      _xp = 0;
      success = true;
    }).catchError((error) => debugPrint("$error"));

    return success;
  }
}

User user = User("Default User");
