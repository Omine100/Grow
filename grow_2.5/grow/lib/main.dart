import 'package:flutter/material.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/pages/root.dart';

//MECHANICS: RUN APP GROW
void main() => runApp(new Grow());

class Grow extends StatelessWidget {
  //USER INTERFACE: APP GROW
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Grow",
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.green.shade200,
        scaffoldBackgroundColor: Colors.green.shade200,
        dialogBackgroundColor: Colors.white,
      ),
      home: new RootPage(auth: new Auth()),
      debugShowCheckedModeBanner: false,
    );
  }
}