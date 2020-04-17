import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/widgets/interfaceStandards.dart';

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
  InterfaceStandards interfaceStandards = new InterfaceStandards();
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
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: interfaceStandards.bodyLinearGradient(context, true, false),
        ),
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.02,
              ),
              child: interfaceStandards.backButton(context),
            ),
            interfaceStandards.parentCenter(context,
              Padding(
                padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
                child: Text(
                  title,
                  style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      fontSize: 45.0
                  ),
                ),
              )),
            Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
                color: Theme.of(context).dialogBackgroundColor,
              ),
              child: Stack(
                children: <Widget>[
                  Text(
                    date
                  ),
                  Text(
                    goal
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}