import 'package:flutter/material.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/cloudFirestore.dart';
import 'package:grow/services/themes.dart';
import 'package:grow/models/dataLists.dart';
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
  Themes themes = new Themes();
  DataLists dataLists = new DataLists();
  final _titleTextEditingController = TextEditingController();
  String iconPositionController, colorPositionController;
  String title;
  int iconPosition, colorPosition;
  Icon icon;

  //USER INTERFACE: SHOW TEXT FIELD FOR TITLE
  Widget showAddGoalTitle() {
    return new TextFormField(
      controller: _titleTextEditingController,
      keyboardType: TextInputType.text,
      style: TextStyle(
        color: Theme.of(context).accentColor,
        fontSize: 22.0,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.border_color,
          color: Theme.of(context).accentColor,
        ),
        hintText: "Title",
        hintStyle: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).accentColor,
        ),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).accentColor,
            )
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).accentColor,
          ),
        ),
      ),
    );
  }

  //USER INTERFACE: SHOW ICONS FOR ICON
  Widget showIcons() {
    return new ListView.builder(
      itemCount: dataLists.getIconList().length,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.only(top: 15.0, bottom: 15.0, left: 15.0, right: 15.0),
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
    );
  }

  //USER INTERFACE: SHOW COLORS FOR COLOR
  Widget showColors() {
    return new ListView.builder(
      itemCount: dataLists.getColorList(themes.checkDarkTheme(context)).length,
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
                color: dataLists.getColorData(index, themes.checkDarkTheme(context)),
              ),
              child: null,
            ),
          ),
        );
      },
    );
  }

  //USER INTERFACE: ADD GOAL SCREEN
  @override
  Widget build(BuildContext context) {
    return Scaffold (
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      body: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: MediaQuery.of(context).size.width * 0.25,
            child: Container(
              height: 50,
              width: MediaQuery.of(context).size.width * 0.5,
              child: showAddGoalTitle(),
            ),
          ), //showAddGoalTitle()
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: MediaQuery.of(context).size.width * 0.3,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.30,
              child: showIcons(),
            ),
          ), //showIcons()
          Positioned(
            top: MediaQuery.of(context).size.height * 0.55,
            left: MediaQuery.of(context).size.width * 0.3,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.3,
              width: MediaQuery.of(context).size.width * 0.30,
              child: showColors(),
            ),
          ), //showColors()
          Positioned(
            top: MediaQuery.of(context).size.height * 0.8,
            left: MediaQuery.of(context).size.width * 0.3,
            child: GestureDetector(
              onTap: () {
                cloudFirestore.createData(_titleTextEditingController.text.toString(), iconPosition, colorPosition);
              },
              child: showFinishButton(),
            ),
          ), //showFinishButton()
        ],
      ),
    );
  }
}

//USER INTERFACE: SHOW FINISH BUTTON
Widget showFinishButton() {
  return new NeumorphicContainer(
    radius: 360,
    clickable: true,
    height: 55,
    width: 55,
    padding: 1.0,

    child: Icon(
      Icons.check,
      color: Colors.black,
      size: 35.0,
    ),
  );
}