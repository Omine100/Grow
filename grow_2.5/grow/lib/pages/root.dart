import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/pages/login.dart';
import 'package:grow/pages/intro.dart';
import 'package:grow/pages/home.dart';

//STATUS DECLARATION: AUTHENTICATION STATUS
enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
  SIGNED_UP,
}

class RootPage extends StatefulWidget {
  RootPage({this.auth});

  //VARIABLE REFERENCE: NEEDED TO LOAD ROOT SCREEN
  final BaseAuth auth;

  @override
  State<StatefulWidget> createState() => new _RootPageState();
}

class _RootPageState extends State<RootPage> {
  //VARIABLE INITIALIZATION: AUTHENTICATION VALUES
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  bool isSeen = false;

  //MECHANICS: CHECKS FOR FILE ON VIEWING INTRO
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool("seen") ?? false);
    isSeen = _seen;
  }

  //MECHANICS: SEES IF THERE IS A USER LOGGED IN ON DEVICE
  @override
  void initState() {
    super.initState();
    checkFirstSeen();
    if (isSeen) {
      Navigator.pushReplacement(
        context, 
        MaterialPageRoute(builder: (context) => IntroScreen())
      );
    } else {
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

  //MECHANICS: SETS STATUS TO SIGN UP
  void signUpCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.SIGNED_UP;
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
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginScreen(
          auth: widget.auth,
          loginCallback: loginCallback,
          signUpCallback: signUpCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return new HomeScreen(
            userId: _userId,
            auth: widget.auth,
            logoutCallback: logoutCallback,
          );
        } else
          return buildWaitingScreen();
        break;
      case AuthStatus.SIGNED_UP:
        if (_userId.length > 0 && _userId != null) {
          return new IntroScreen();
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }
}