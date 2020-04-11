import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grow/services/authentication.dart';

class UserGoal extends StatefulWidget {
  UserGoal({Key key, this.auth, this.logoutCallback, this.userId, this.documentSnapshot});

  //VARIABLE REFERENCE: NEEDED TO LOAD USER GOAL SCREEN
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final DocumentSnapshot documentSnapshot;

  @override
  State<StatefulWidget> createState() => new _UserGoalState();
}

class _UserGoalState extends State<UserGoal> {
  //VARIABLE DECLARATION
  String title;
  String date;
  String goal;

  @override
  void initState() {
    super.initState();
    getData();
  }

  //MECHANICS: READ DOCUMENTSNAPSHOT AND INITIALIZE DATA
  void getData() {
    title = getDocumentSnapshot(widget.documentSnapshot)['title'];
    date = "Date.";
    goal = "Goal.";
  }

  //MECHANICS: GET DOCUMENTSNAPSHOT STATIC
  DocumentSnapshot getDocumentSnapshot(DocumentSnapshot documentSnapshot) {
    return documentSnapshot;
  }

  //USER INTERFACE: USER GOAL SCREEN
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
            ),
          ),
          Text(
            date,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20.0,
            ),
          ),
          Text(
            goal,
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20.0,
            ),
          ),
        ],
      )
    );
  }
}