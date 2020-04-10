import 'package:flutter/material.dart';

import 'package:grow/services/authentication.dart';

import 'package:grow/services/rootPage.dart';

void main() => runApp(new Grow());

class Grow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        backgroundColor: Colors.blueGrey.shade200,
        scaffoldBackgroundColor: Colors.blueGrey.shade200,
        dialogBackgroundColor: Colors.grey.shade600,
      ),
      home: new RootPage(auth: new Auth()),
      debugShowCheckedModeBanner: false,
    );
  }
}