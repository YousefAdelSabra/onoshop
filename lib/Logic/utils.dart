import 'package:flutter/material.dart';

class Utils {
  static final messengerKey = GlobalKey<ScaffoldMessengerState>();

  static showSnackBar(String? text) {
    if (text == null) return;

    final snackBar = SnackBar(content: Text(text, style: const TextStyle(color: Colors.white),), backgroundColor: Colors.red.shade900);

    messengerKey.currentState!..removeCurrentSnackBar()..showSnackBar(snackBar);
  }
}