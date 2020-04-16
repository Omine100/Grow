import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:grow/pages/login.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/cloudFirestore.dart';
import 'package:grow/widgets/interfaceStandards.dart';
import 'package:grow/widgets/neumorphicContainer.dart';
import 'package:grow/pages/root.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.auth, this.logoutCallback, this.userId});

  //VARIABLE REFERENCE: NEEDED TO LOAD HOME SCREEN
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //VARIABLE DECLARATION
  CloudFirestore cloudFirestore = new CloudFirestore();
  InterfaceStandards interfaceStandards = new InterfaceStandards();

  //USER INTERFACE: PROFILE SCREEN
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
              top: MediaQuery.of(context).size.height * 0.065,
              child: interfaceStandards.parentCenter(context,
                Text(
                  "Settings",
                  style: TextStyle(
                    color: Theme.of(context).scaffoldBackgroundColor,
                    fontSize: 45.0,
                  ),),
              )
            ), //Profile text
            Positioned(
              top: MediaQuery.of(context).size.height * 0.0775,
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
                child: showSettings(context),
              ),
            ), //showSettings()
            Positioned(
              top: MediaQuery.of(context).size.height * 0.825,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: interfaceStandards.parentCenter(context,
                    NeumorphicContainer(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.30,
                      radius: 40.0,
                      clickable: true,
                      padding: 0.0,
                      color: Theme.of(context).dialogBackgroundColor,
                      child: GestureDetector(
                        onTap: (){
                          widget.auth.signOut();
                          Navigator.of(context)
                              .pushNamedAndRemoveUntil('/RootScreen', (Route<dynamic> route) => false);
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          child: Center(
                            child: Text(
                              "Logout",
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
                    ),),
              ),
            ), //signOut
            Positioned(
              top: MediaQuery.of(context).size.height * 0.925,
              child: interfaceStandards.parentCenter(context,
                GestureDetector(
                  onTap: (){
                    String uid = widget.userId;
                    widget.auth.deleteAccount();
                    cloudFirestore.deleteAccountData(uid);
                  },
                  child: Text(
                    "DELETE ACCOUNT",
                    style: TextStyle(
                      color: Colors.red,
                      fontSize: 15.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ), //Delete account
          ],
        ),
      ),
    );
  }
}

//USER INTERFACE: SHOW SETTINGS
Widget showSettings(BuildContext context) {
}