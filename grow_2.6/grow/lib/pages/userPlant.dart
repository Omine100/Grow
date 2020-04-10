import 'package:flutter/material.dart';

class UserPlantScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _UserPlantScreenState();
}

class _UserPlantScreenState extends State<UserPlantScreen> {
  //USER INTERFACE: SHOW USER PLANT SCREEN
  @override
  Widget build(BuildContext context) {
    return new Container(
      child: Text(
        "Testing",
        style: TextStyle(
          color: Theme.of(context).dialogBackgroundColor,
          fontSize: 35.0
        ),
      ),
    );
  }
}