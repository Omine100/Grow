import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:grow/services/authentication.dart';
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
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  String title;
  String date;
  String goal;
  DataLists dataLists = new DataLists();
  List _selectedEvents;
  DateTime _selectedDay;

  //VARIABLE INITIALIZATION: USER GOAL SCREEN
  @override
  void initState() {
    super.initState();
    getData();
    _selectedEvents = dataLists.getCalendarMap()[_selectedDay] ?? [];
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
            showTodayIcon: true,
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
          ],
        ),
      ),
    );
  }
}