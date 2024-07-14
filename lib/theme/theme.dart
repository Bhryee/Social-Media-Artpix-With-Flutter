import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: Colors.grey.shade100,
  colorScheme: ColorScheme.light(
    surface: Colors.white,
    primary: Color(0xFF215969),
    onPrimary: Color(0xFF1C869E),
    secondary: Color(0xFF42C5DF),
    onSecondary: Colors.grey.shade100,
  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Colors.black,
    ),
  ),
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Color(0xFF171717) ,
  colorScheme: ColorScheme.dark(
      surface: Colors.grey.shade900,
      primary: Colors.grey.shade800,
      onPrimary: Colors.white,
      secondary: Colors.grey.shade700,
      onSecondary: Colors.grey.shade800,

  ),
  textTheme: TextTheme(
    bodyMedium: TextStyle(
      color: Color(0xFFD9D9D9),
    ),
  ),
);
