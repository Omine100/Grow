import 'package:flutter/material.dart';

import 'package:grow/widgets/neumorphicContainer.dart';

import 'package:grow/pages/intro.dart';
import 'package:grow/pages/login.dart';

class SignupScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: SafeArea(
          child: Stack(
            children: <Widget>[
              Form( //Finish form
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 350.0),
                      child: showEmailInput(context),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
                      child: showPasswordInput(context),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 2.55,
                top: MediaQuery.of(context).size.height / 7,
                child: showUserIcon(context),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 2.60,
                top: MediaQuery.of(context).size.height * 0.63,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => IntroScreen())
                    );
                  },
                  child: showSignupButton()
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 3.15,
                top: MediaQuery.of(context).size.height * 0.73,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen())
                    );
                  },
                  child: showAlreadyUserButton()
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget showUserIcon(BuildContext context) {
  return new NeumorphicContainer(
    child: Padding(
      padding: EdgeInsets.all(12.5),
      child: Stack(
        children: <Widget>[
          Icon(
            Icons.person,
            color: Theme.of(context).dialogBackgroundColor,
            size: 85.0,
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue.shade400
            ),
            child: Icon(
              Icons.add,
              color: Colors.white,
              size: 35.0,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget showSignupButton() {
  return new NeumorphicContainer(
    child: Padding(
      padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 15.0, bottom: 15.0),
      child: Text(
        "Signup",
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
      ),
    )
  );
}

Widget showAlreadyUserButton() {
  return new GestureDetector(
    child: Text(
      "Already have an Account?",
      style: TextStyle(
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w400,
        fontSize: 15.0
      ),
    ),
  );
}

Widget showEmailInput(BuildContext context) {
  return new TextFormField(
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(
      color: Theme.of(context).dialogBackgroundColor,
      fontSize: 22.0
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.email,
        color: Theme.of(context).dialogBackgroundColor,
      ),
      hintText: "Email",
      labelStyle: TextStyle(
        color: Theme.of(context).dialogBackgroundColor,
      ),
      hintStyle: TextStyle(
        color: Theme.of(context).dialogBackgroundColor,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).dialogBackgroundColor,
        ),
      ),
    ),
  );
}

Widget showPasswordInput(BuildContext context) {
  return new TextFormField(
    keyboardType: TextInputType.text,
    style: TextStyle(
      color: Theme.of(context).dialogBackgroundColor,
      fontSize: 22.0
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.lock,
        color: Theme.of(context).dialogBackgroundColor,
      ),
      hintText: "Password",
      labelStyle: TextStyle(
        color: Theme.of(context).dialogBackgroundColor,
      ),
      hintStyle: TextStyle(
        color: Theme.of(context).dialogBackgroundColor,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).dialogBackgroundColor,
        ),
      ),
    ),
    obscureText: true,
  );
}