import 'package:flutter/material.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/pages/root.dart';

//MECHANICS: RUN APP GROW
void main() => runApp(new Grow());

class Grow extends StatelessWidget {
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
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.blue.shade200,
        scaffoldBackgroundColor: Colors.white,
        dialogBackgroundColor: Color.fromARGB(255, 242, 243, 248),
        accentColor: Colors.blue.shade300,
        textSelectionColor: Colors.grey.shade700,
        textSelectionHandleColor: Colors.grey.shade600,
        cardColor: Colors.grey.shade300,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blue.shade400,
        textSelectionColor: Colors.grey.shade400,
        textSelectionHandleColor: Colors.grey.shade300,
      ),
    );
  }
}