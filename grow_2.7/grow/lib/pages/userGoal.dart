import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/cloudFirestore.dart';
import 'package:grow/services/methodStandards.dart';
import 'package:grow/widgets/interfaceStandards.dart';
import 'package:grow/models/dataLists.dart';

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

class _UserGoalState extends State<UserGoal> with SingleTickerProviderStateMixin {
  //VARIABLE DECLARATION
  CloudFirestore cloudFirestore = new CloudFirestore();
  MethodStandards methodStandards = new MethodStandards();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  DataLists dataLists = new DataLists();
  Stopwatch stopwatch = new Stopwatch();
  AnimationController animationController;
  String title;
  String date;
  String goal;
  DateTime _selectedDay;
  String startButtonText;
  bool checked;

  //VARIABLE INITIALIZATION: USER GOAL SCREEN
  @override
  void initState() {
    super.initState();
    getData();
    startButtonText = "Start";
    checked = false;
    animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
  }

  void handleOnPressed() {
    setState(() {
      checked = !checked;
      checked ? animationController.forward() : animationController.reverse();
    });

    cloudFirestore.updateFavoriteData(widget.documentSnapshot);
  }

  //USER INTERFACE: SHOW FAVORITE BUTTON
  Widget showFavoriteButton() {
    return IconButton(
      iconSize: 50,
      icon: AnimatedIcon(
        icon: AnimatedIcons.view_list,
        color: Theme.of(context).splashColor,
        progress: animationController,
      ),
      onPressed: () => handleOnPressed(),
    );
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

  //MECHANICS: HANDLE NEW DATE
  void handleNewDate(date) {
    setState(() {
      _selectedDay = date;
    });
  }

  //USER INTERFACE: SHOW CALENDAR
  Widget showCalendar() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Calendar(
            events: dataLists.getCalendarMap(widget.documentSnapshot),
            onRangeSelected: (range) => print(range),
            onDateSelected: (date) => handleNewDate(date),
            isExpanded: false,
            eventColor: Colors.blue,
            eventDoneColor: Colors.black,
            isExpandable: false,
          ),
        ],
      ),
    );
  }

  //USER INTERFACE: SHOW START BUTTON
  Widget showStartButton() {
    return interfaceStandards.parentCenter(context,
      Container(
        child: GestureDetector(
          onTap: () {
            if (stopwatch.isRunning) {
              stopwatch.stop();
              methodStandards.timer(stopwatch, widget.documentSnapshot);
              stopwatch.reset();
              setState(() {
                print("Timer ended: " + widget.documentSnapshot.documentID);
                startButtonText = "Start";
                Navigator.pop(context);
              });
            } else {
              stopwatch.start();
              print("Timer started: " + widget.documentSnapshot.documentID);
              setState(() {
                startButtonText = "Stop";
              });
            }
          },
          child: Center(
            child: Text(
              startButtonText,
              style: TextStyle(
                foreground: Paint()
                  ..shader = interfaceStandards.textLinearGradient(context),
                fontWeight: FontWeight.w400,
                fontSize: 20.0,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //USER INTERFACE: USER GOAL SCREEN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: interfaceStandards.bodyLinearGradient(context, true, false),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: MediaQuery.of(context).size.height * 0.085,
              child: interfaceStandards.headerText(context, title),
            ), //Header text
            Positioned(
              top: MediaQuery.of(context).size.height * 0.080,
              left: MediaQuery.of(context).size.width * 0.825,
              child: showFavoriteButton(),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height * 0.1,
              left: MediaQuery.of(context).size.width * 0.06,
              child: interfaceStandards.backButton(context),
            ), //Back button
            Positioned(
              top: MediaQuery.of(context).size.height * 0.175,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.0),
                  color: Theme.of(context).dialogBackgroundColor,
                ),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Container(),
              ),
            ), //Card
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.60,
                width: MediaQuery.of(context).size.width,
                child: showCalendar(),
              ),
            ), //Calendar
            Positioned(
              top: MediaQuery.of(context).size.height * 0.9,
              child: showStartButton(),
            ), //Start button
          ],
        ),
      ),
    );
  }
}