import 'package:flutter/material.dart';

import 'package:grow/services/specifications.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    setup().statusBarColor();
    setup().orientation();

    return Container(
      color: Colors.green.shade300,
      child: Text(
        "Testing",
      ),
    );
  }
}