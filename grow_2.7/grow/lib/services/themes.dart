import 'package:flutter/material.dart';

class Themes {
  //THEME: LIGHT THEME
  ThemeData lightTheme() {
    return ThemeData(
      primarySwatch: Colors.blue,
      backgroundColor: Colors.blue.shade300,
      scaffoldBackgroundColor: Colors.white,
      splashColor: Colors.white,
      dialogBackgroundColor: Color.fromARGB(255, 242, 243, 248),
      accentColor: Colors.blue.shade300,
      textSelectionColor: Colors.grey.shade700,
      textSelectionHandleColor: Colors.grey.shade600,
      secondaryHeaderColor: Colors.grey.shade200,
      cardColor: Colors.grey.shade300,
    );
  }

  //THEME: DARK THEME
  ThemeData darkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      splashColor: Colors.grey.shade100,
      accentColor: Colors.blue.shade400,
      textSelectionColor: Colors.grey.shade300,
      textSelectionHandleColor: Colors.grey.shade200,
      secondaryHeaderColor: Colors.grey.shade100
    );
  }

  //MECHANICS: CHECK DARK THEME
  bool checkDarkTheme(BuildContext context) {
    var brightness = MediaQuery.of(context).platformBrightness;
    if (brightness == Brightness.dark) {
      return true;
    }
    return false;
  }
}