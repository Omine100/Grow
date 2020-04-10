import 'package:flutter/material.dart';

import 'package:grow/services/authentication.dart';

class AddGoalScreen extends StatefulWidget {
  AddGoalScreen({Key key, this.auth, this.logoutCallback, this.userId});

  //VARIABLE REFERENCE: NEEDED TO LOAD ADD GOAL SCREEN
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _AddGoalScreenState();
}

class _AddGoalScreenState extends State<AddGoalScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Testing",
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
        ),
      ),
    );
  }
}