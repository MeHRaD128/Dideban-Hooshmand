import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Peyda',
      scaffoldBackgroundColor: const Color.fromARGB(255, 242, 242, 247),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 40),
        bodyMedium: TextStyle(fontSize: 20),
        bodySmall: TextStyle(fontSize: 10),
      ),
    );
  }
}
