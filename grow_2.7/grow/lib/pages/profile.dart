import 'package:flutter/material.dart';

import 'package:grow/services/authentication.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({Key key, this.auth, this.logoutCallback, this.userId});

  //VARIABLE REFERENCE: NEEDED TO LOAD ADD GOAL SCREEN
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  //USER INTERFACE: PROFILE SCREEN
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Theme.of(context).dialogBackgroundColor,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.45,
            child: Text(
              "PROFILE",
              style: TextStyle(
                color: Theme.of(context).accentColor,
                fontSize: 25.0,
              ),
            ),
          ), //Profile text
          Positioned(
            top: MediaQuery.of(context).size.height * 0.5,
            left: MediaQuery.of(context).size.width * 0.45,
            child: GestureDetector(
              onTap: () {
                widget.auth.signOut();
                widget.logoutCallback();
              },
              child: Text(
                "Sign Out",
                style: TextStyle(
                  color: Theme.of(context).accentColor,
                ),
              ),
            ),
          ), //signOut
        ],
      ),
    );
  }
}