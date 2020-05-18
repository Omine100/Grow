import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/cloudFirestore.dart';
import 'package:grow/services/themes.dart';
import 'package:grow/models/dataLists.dart';
import 'package:grow/widgets/interfaceStandards.dart';
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

  //USER INTERFACE: SHOW ADD TEXT
  Widget showHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white,
        fontSize: 40.0,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  //USER INTERFACE: SHOW TEXT FIELD FOR TITLE
  Widget showPickTitle() {
    return new Container(
      width: MediaQuery.of(context).size.width * 0.8,
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

  //USER INTERFACE: SHOW COLORS FOR COLOR
  Widget showPickColor() {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.format_paint,
            color: Theme.of(context).splashColor,
            size: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dataLists.getColorList(themes.checkDarkTheme(context), true).length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
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
          ),
        ],
      ),
    );
  }

  //USER INTERFACE: SHOW ICONS FOR ICON
  Widget showPickIcon() {
    return new Container(
      height: MediaQuery.of(context).size.height * 0.1,
      child: Row(
        children: <Widget>[
          Icon(
            Icons.insert_emoticon,
            color: Theme.of(context).splashColor,
            size: 30.0,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: dataLists.getIconList().length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(left: 25.0, right: 25.0),
                  child: GestureDetector(
                    onTap: () {
                      iconPosition = index;
                    },
                    child: NeumorphicButton(
                      boxShape: NeumorphicBoxShape.circle(),
                      style: NeumorphicStyle(
                        shape: NeumorphicShape.flat,
                        depth: 8.0,
                        lightSource: LightSource.topLeft,
                        color: Theme.of(context).accentColor,
                      ),
                      child: dataLists.getIconData(index),
                    ),
                  ),
                );
              },
            ),
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
        itemHeight: 35.0,
        itemWidth: 50.0,
        highlightedTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 35.0
        ),
        is24HourMode: true,
        isForce2Digits: false,
        isShowSeconds: true,
        spacing: 15.0,
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
        showPickColor(),
        showPickIcon(),
        showPickTime(),
      ],
    );
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
          child: NeumorphicButton(
            boxShape: NeumorphicBoxShape.circle(),
            style: NeumorphicStyle(
              shape: NeumorphicShape.flat,
              depth: 8.0,
              lightSource: LightSource.topLeft,
              color: Theme.of(context).highlightColor,
            ),
            child: Icon(
              Icons.check,
              color: Theme.of(context).splashColor,
              size: 35.0,
            ),
          ),
        ),
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
                left: MediaQuery.of(context).size.width * 0.1,
                child: showHeader("Add Goal"),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.25,
                left: MediaQuery.of(context).size.width * 0.05,
                child: showForm()
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.8,
                child: showCreateButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}