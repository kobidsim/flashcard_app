import 'package:flashcard_app/entities/user.dart';
import 'package:flutter/material.dart';

class UserData extends ChangeNotifier {
  final User _user = user;

  int get xp => _user.xp;
  String get name => _user.name;
}
