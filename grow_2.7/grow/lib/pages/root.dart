import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/cloudFirestore.dart';
import 'package:grow/pages/intro.dart';
import 'package:grow/pages/login.dart';
import 'package:grow/pages/home.dart';

//STATUS DECLARATION: AUTHENTICATION STATUS
enum AuthStatus {
  NOT_DETERMINED,
  NOT_SEEN,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class RootScreen extends StatefulWidget {
  RootScreen({this.auth});

  //VARIABLE REFERENCE: NEEDED TO ROOT SCREEN
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  //VARIABLE INITIALIZATION: AUTHENTICATION VALUES
  CloudFirestore cloudFirestore = new CloudFirestore();
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  //MECHANICS: CHECKS FOR FILE ON VIEWING INTRO
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSeen = (prefs.getBool("seen") ?? false);

    if (!isSeen) {
      await prefs.setBool("seen", true);
      authStatus = AuthStatus.NOT_SEEN;
    }
  }

  //MECHANICS: SEES IF THERE IS A USER LOGGED IN ON THE DEVICE
  @override
  void initState() {
    super.initState();
    new Timer(new Duration(milliseconds: 200), () {
      checkFirstSeen();
    });

    if (authStatus != AuthStatus.NOT_SEEN) {
      widget.auth.getCurrentUser().then((user) {
        setState(() {
          if (user != null) {
            _userId = user?.uid;
          }
          authStatus =
          user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
        });
      });
    }
  }

  //MECHANICS: SETS STATUS TO LOGGED IN WITH CURRENT USER
  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  //MECHANICS: SETS STATUS TO LOGGED OUT
  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
  }

  //USER INTERFACE: BUILDS CIRCULAR PROGRESS INDICATOR WITH ANIMATION
  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  //USER ROUTING: ROUTES USER THROUGH APP BASED ON STATUS
  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_SEEN:
        return new IntroScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginScreen(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new HomeScreen(
            auth: widget.auth,
            logoutCallback: logoutCallback,
            userId: _userId,
          );
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}