import 'package:flutter/material.dart';

class LightTheme {
  static ThemeData get theme {
    return ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Peyda',
      scaffoldBackgroundColor: const Color.fromARGB(255, 242, 242, 247),

      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 40, fontFamily: 'Peyda'),
        bodyMedium: TextStyle(fontSize: 20, fontFamily: 'Peyda'),
        bodySmall: TextStyle(fontSize: 10, fontFamily: 'Peyda'),
      ),
    );
  }
}
