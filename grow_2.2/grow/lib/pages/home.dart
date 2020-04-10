import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        color: Colors.green.shade200,
        child: Text(
          "Testing",
          style: TextStyle(
            color: Colors.white,
          )
        ),
      ),
    );
  }
}