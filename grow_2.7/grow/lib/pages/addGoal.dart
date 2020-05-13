import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/cloudFirestore.dart';
import 'package:grow/services/themes.dart';
import 'package:grow/models/dataLists.dart';
import 'package:grow/widgets/interfaceStandards.dart';
import 'package:grow/widgets/neumorphicContainer.dart';
import 'package:grow/pages/home.dart';

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
  //VARIABLE DECLARATION
  CloudFirestore cloudFirestore = new CloudFirestore();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  Themes themes = new Themes();
  DataLists dataLists = new DataLists();
  TextEditingController _titleTextEditingController = TextEditingController();
  int iconPosition, colorPosition;
  DateTime dateTime = DateTime.now();

  //MECHANICS: CALCULATE GOAL TIME
  int goalTimeCalculator() {
    int goalTotal = (dateTime.hour * 3600) + (dateTime.minute * 60) + dateTime.second;
    return goalTotal;
  }

  //USER INTERFACE: SHOW CREATE BUTTON
  Widget showCreateButton() {
    return new InterfaceStandards().parentCenter(context,
        GestureDetector(
          onTap: () {
            cloudFirestore.createData(
              _titleTextEditingController.text.toString(),
              iconPosition,
              colorPosition,
              goalTimeCalculator(),
            );
            Navigator.pop(context);
          },
          child: NeumorphicContainer(
            radius: 360,
            clickable: true,
            height: 55,
            width: 55,
            padding: 1.0,
            color: Theme.of(context).highlightColor,

            child: Icon(
              Icons.check,
              color: Theme.of(context).splashColor,
              size: 35.0,
            ),
          ),
        ),
    );
  }

  //USER INTERFACE: SHOW ADD TEXT
  Widget showHeader(String text) {
    return Column(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.1),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 40.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        new Divider(
          color: Colors.white,
          height: MediaQuery.of(context).size.height * 1,
        ),
      ],
    );
  }

  //USER INTERFACE: SHOW TEXT FIELD FOR TITLE
  Widget showPickTitle() {
    return new Container(
      width: MediaQuery.of(context).size.width * 0.75,
      child: TextFormField(
        controller: _titleTextEditingController,
        keyboardType: TextInputType.text,
        style: TextStyle(
          color: Theme.of(context).splashColor,
          fontSize: 22.0,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            Icons.border_color,
            color: Theme.of(context).splashColor,
          ),
          hintText: "Title",
          hintStyle: TextStyle(
            color: Theme.of(context).splashColor,
          ),
          labelStyle: TextStyle(
            color: Theme.of(context).splashColor,
          ),
          enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).splashColor,
              )
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).splashColor,
            ),
          ),
        ),
      ),
    );
  }

  //USER INTERFACE: SHOW ICONS FOR ICON
  Widget showPickIcon() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.insert_emoticon,
          ),
          ListView.builder(
            itemCount: dataLists.getIconList().length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 150.0, right: 150.0),
                child: GestureDetector(
                  onTap: () {
                    iconPosition = index;
                  },
                  child: NeumorphicContainer(
                    color: Theme.of(context).dialogBackgroundColor,
                    radius: 25.0,
                    padding: 0.0,
                    height: 75.0,
                    width: 75.0,
                    clickable: true,
                    child: dataLists.getIconData(index),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  //USER INTERFACE: SHOW COLORS FOR COLOR
  Widget showPickColor() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.format_paint
          ),
          ListView.builder(
            itemCount: dataLists.getColorList(themes.checkDarkTheme(context), true).length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
                child: GestureDetector(
                  onTap: () {
                    colorPosition = index;
                  },
                  child: Container(
                    height: 50.0,
                    width: 50.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: dataLists.getColorData(index, themes.checkDarkTheme(context), true),
                    ),
                    child: null,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  //USER INTERFACE: SHOW TIME PICKER FOR TIME
  Widget showPickTime() {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.2,
      child: TimePickerSpinner(
        normalTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 25.0
        ),
        highlightedTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 35.0
        ),
        is24HourMode: true,
        isForce2Digits: false,
        isShowSeconds: true,
        time: DateTime.utc(1,1,1,0,0,0,1),
        secondsInterval: 1,
        onTimeChange: (time) {
          setState(() {
            dateTime = time;
          });
        },
      ),
    );
  }

  //USER INTERFACE: SHOW FORM
  Widget showForm() {
    return Column(
      children: <Widget>[
        showPickTitle(),
        showPickIcon(),
        showPickColor(),
        showPickTime(),
      ],
    );
  }

  //USER INTERFACE: ADD GOAL SCREEN
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            gradient: interfaceStandards.bodyLinearGradient(context, false, true),
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height * 0.03,
                left: MediaQuery.of(context).size.width * 0.06,
                child: interfaceStandards.backButton(context),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.125,
                child: showHeader("Add Goal"),
              ),
              // Positioned(
              //   top: MediaQuery.of(context).size.height * 0.4,
              //   child: showForm(),
              // ),
              // Positioned(
              //   top: MediaQuery.of(context).size.height * 0.85,
              //   child: showCreateButton(),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}