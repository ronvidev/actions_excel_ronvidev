import 'package:flutter/material.dart';

class Themes {
  static const useMaterial3 = true;
  static final primaryColor = Colors.green[600];

  static ThemeData ligthTheme = ThemeData(
    useMaterial3: useMaterial3,
    canvasColor: const Color.fromARGB(255, 244, 245, 244),
    colorScheme: const ColorScheme.light(primary: Colors.green),
  );
  static ThemeData darkTheme = ThemeData(
    useMaterial3: useMaterial3,
    brightness: Brightness.dark,
    primaryColor: const Color.fromARGB(255, 48, 48, 48),
    canvasColor: const Color.fromARGB(255, 21, 21, 21),
    cardColor: const Color.fromARGB(255, 39, 39, 39),
    hintColor: const Color.fromARGB(255, 196, 196, 196),
    colorScheme: const ColorScheme.dark(primary: Colors.green),
  );
}
