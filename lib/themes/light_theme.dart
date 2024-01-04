import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  appBarTheme: const AppBarTheme(
      //in appbar theme, we describeed background, icon, titletext color
      backgroundColor: Colors.transparent,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      titleTextStyle: TextStyle(color: Colors.black)),
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    //in colorScheme
    background: Colors.grey[300]!,
    primary: Colors.grey[700]!,
    secondary: Colors.grey[300]!,
    inversePrimary: Colors.black,
  ),
);
