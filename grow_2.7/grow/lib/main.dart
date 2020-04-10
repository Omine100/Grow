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
      home: new RootScreen(auth: new Auth(),),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.blue.shade200,
        scaffoldBackgroundColor: Colors.white,
        dialogBackgroundColor: Color.fromARGB(255, 242, 243, 248),
        accentColor: Colors.blue.shade300,
      ),
    );
  }
}