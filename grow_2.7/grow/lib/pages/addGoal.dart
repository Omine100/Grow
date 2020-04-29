import 'package:flutter/material.dart';

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
  String iconPositionController, colorPositionController;
  String title;
  int iconPosition, colorPosition;
  Icon icon;
  String textPosition = "Title";
  int formPosition = 1;
  bool buttonPosition = false;

  Future<void> pageCounter() async {
    setState(() {
      formPosition++;
      if (formPosition == 2) {
        textPosition = "Icon";
        buttonPosition = false;
      } else if (formPosition == 3) {
        textPosition = "Color";
        buttonPosition = true;
      }
    });
  }

  //USER INTERFACE: SHOW ADD TEXT
  Widget showText(String textPosition) {
    return InterfaceStandards().parentCenter(context,
      Text(
        textPosition.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 40.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  //USER INTERFACE: SHOW FORM
  Widget showForm(int formPosition) {
    if (formPosition == 1) {
      return InterfaceStandards().parentCenter(context,
        showPickTitle(),
      );
    } else if (formPosition == 2) {
      return InterfaceStandards().parentCenter(context,
        showPickIcon(),
      );
    } else {
      return InterfaceStandards().parentCenter(context,
        showPickColor(),
      );
    }
  }

  //USER INTERFACE: SHOW BUTTON
  Widget showButton(int formPosition, bool buttonPosition) {
    return new InterfaceStandards().parentCenter(context,
        GestureDetector(
          onTap: () {
            print(formPosition);
            if(formPosition != 3) {
              pageCounter();
            } else {
              cloudFirestore.createData(_titleTextEditingController.text.toString(), iconPosition, colorPosition);
              Navigator.pop(context);
            }
          },
          child: NeumorphicContainer(
            radius: 360,
            clickable: true,
            height: 55,
            width: 55,
            padding: 1.0,
            color: Theme.of(context).highlightColor,

            child: Icon(
              buttonPosition ? Icons.check : Icons.navigate_next,
              color: Theme.of(context).splashColor,
              size: 35.0,
            ),
          ),
        ),
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
      child: ListView.builder(
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
    );
  }

  //USER INTERFACE: SHOW COLORS FOR COLOR
  Widget showPickColor() {
    return new Container(
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
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
              ), //Back button
              Positioned(
                top: MediaQuery.of(context).size.height * 0.3,
                child: showText(textPosition),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.4,
                child: showForm(formPosition),
              ),
              Positioned(
                top: formPosition == 2 ? MediaQuery.of(context).size.height * 0.7 : MediaQuery.of(context).size.height * 0.65,
                child: showButton(formPosition, buttonPosition),
              ),
            ],
          ),
        ),
      ),
    );
  }
}