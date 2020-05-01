import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/cloudFirestore.dart';
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

class _UserGoalState extends State<UserGoal> {
  //VARIABLE DECLARATION
  CloudFirestore cloudFirestore = new CloudFirestore();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  DataLists dataLists = new DataLists();
  Stopwatch stopwatch = new Stopwatch();
  String title;
  String date;
  String goal;
  List _selectedEvents;
  DateTime _selectedDay;
  String startButtonText;

  //VARIABLE INITIALIZATION: USER GOAL SCREEN
  @override
  void initState() {
    super.initState();
    getData();
    _selectedEvents = dataLists.getCalendarMap()[_selectedDay] ?? [];
    startButtonText = "Start";
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
      _selectedEvents = dataLists.getCalendarMap()[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  //USER INTERFACE: SHOW CALENDAR
  Widget showCalendar() {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Calendar(
            events: dataLists.getCalendarMap(),
            onRangeSelected: (range) => print(range),
            onDateSelected: (date) => handleNewDate(date),
            isExpanded: false,
            showTodayIcon: false,
            eventColor: Colors.blue,
            eventDoneColor: Colors.black,
            showArrows: true,
            isExpandable: false,
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) => Container(
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.5, color: Colors.black12),
                  ),
                ),
                padding:
                const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
                child: ListTile(
                  title: Text(_selectedEvents[index]['name'].toString()),
                  onTap: () {},
                ),
              ),
              itemCount: _selectedEvents.length,
            ),
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

              int currentTotal = (stopwatch.elapsedMilliseconds / 1000).toInt();

              DateTime now = new DateTime.now();
              DateTime currentDate = new DateTime(now.year, now.month, now.day);

              cloudFirestore.updateTimeData(widget.documentSnapshot, currentTotal, currentDate);

              stopwatch.reset();
              setState(() {
                startButtonText = "Start";
              });
            } else {
              stopwatch.start();
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