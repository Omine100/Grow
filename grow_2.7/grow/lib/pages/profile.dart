import 'package:flutter/material.dart';
import 'package:grow/pages/login.dart';

import 'package:grow/services/authentication.dart';
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
  //USER INTERFACE: PROFILE SCREEN
  @override
  Widget build(BuildContext context) {
    return new Container(
      color: Theme.of(context).dialogBackgroundColor,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height * 0.1,
            left: MediaQuery.of(context).size.width * 0.4,
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
            left: MediaQuery.of(context).size.width * 0.375,
            child: RaisedButton(
              color: Theme.of(context).accentColor,
              onPressed: () {
                widget.auth.signOut();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/RootScreen', (Route<dynamic> route) => false);
              },
              child: Text(
                "Sign Out",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                ),
              ),
            ),
          ), //signOut
        ],
      ),
    );
  }
}