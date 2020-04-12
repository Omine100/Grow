import 'dart:wasm';

import 'package:flutter/material.dart';

import 'package:grow/services/authentication.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({this.auth, this.loginCallback, this.signUpCallback});

  //VARIABLE REFERENCE: NEEDED TO LOAD FORGOT PASSWORD SCREEN
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback signUpCallback;

  @override
  State<StatefulWidget> createState() => new _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //VARIABLE DECLARATION
  String _email;

  //USER INTERFACE: SHOW EMAIL INPUT
  Widget showEmailInput() {
    return Container(
      height: 100,
      width: 250,
      child: TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => _email = value.trim(),
      ),
    );
  }

  //USER INTERFACE: FORGOT PASSWORD SCREEN
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: MediaQuery.of(context).size.height * 0.2,
            left: MediaQuery.of(context).size.width * 0.175,
            child: Text(
              "Forgot Password",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 30.0,
              ),
            ),
          ), //Forgot Password text
          Positioned(
            top: MediaQuery.of(context).size.height * 0.3,
            left: MediaQuery.of(context).size.width * 0.15,
            child: Card(
              child: showEmailInput(),
            ),
          ), //showEmailInput()
          Positioned(
              top: MediaQuery.of(context).size.height * 0.5,
              left: MediaQuery.of(context).size.width * 0.3,
              child: RaisedButton(
                onPressed: () {
                  widget.auth.sendPasswordReset("matthewrhb12321@gmail.com");
                },
                child: Text(
                  "Reset Password",
                ),
              )
          ), //Reset Password button
        ],
      ),
    );
  }
}