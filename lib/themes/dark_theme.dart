import 'package:flutter/material.dart';

ThemeData darkTheme = ThemeData(
  appBarTheme: const AppBarTheme(
    //in appbar theme, we describeed background, icon, titletext color
    backgroundColor: Colors.black,
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    titleTextStyle: TextStyle(color: Colors.white)
  ),
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    //in colorScheme
    background: Colors.black,
    primary: Colors.grey[900]!,
    secondary: Colors.grey[800]!,
    inversePrimary: Colors.white,
  ),
);
