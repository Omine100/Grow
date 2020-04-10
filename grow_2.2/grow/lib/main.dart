import 'package:flutter/material.dart';

import 'package:grow/pages/intro.dart';

void main() => runApp(new Grow());

class Grow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: IntroScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}