import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/themes.dart';
import 'package:grow/pages/root.dart';

//MECHANICS: RUN APP GROW
void main() {
  runApp(new Grow());
}

class Grow extends StatelessWidget {
  Themes themes = new Themes();

  //USER INTERFACE: GROW APP
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Grow",
      debugShowCheckedModeBanner: false,
      routes: {
        '/RootScreen': (context) => RootScreen(auth: new Auth(),),
      },
      initialRoute: '/RootScreen',
      theme: themes.lightTheme(),
      darkTheme: themes.darkTheme(),
    );
  }
}