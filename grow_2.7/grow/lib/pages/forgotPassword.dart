import 'dart:wasm';
import 'package:flutter/material.dart';

import 'package:grow/services/authentication.dart';

class ForgotPasswordScreen extends StatefulWidget {
  ForgotPasswordScreen({this.auth, this.loginCallback});

  //VARIABLE REFERENCE: NEEDED TO LOAD FORGOT PASSWORD SCREEN
  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  //VARIABLE DECLARATION
  String _email;
  final formKey = GlobalKey<FormState>();

  //USER INTERFACE: SHOW EMAIL INPUT
  Widget showEmailInput() {
    return new TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(
        color: Theme.of(context).secondaryHeaderColor,
        fontSize: 22.0,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.email,
          color: Theme.of(context).secondaryHeaderColor,
        ),
        hintText: "Email",
        hintStyle: TextStyle(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      validator: (value) => value.isEmpty ?"Email can\'t be empty" : null,
      onSaved: (value) => _email = value.trim(),
      obscureText: false,
      maxLines: 1,
    );
  }

  //USER INTERFACE: FORGOT PASSWORD SCREEN
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              tileMode: TileMode.mirror,
              colors: [
                Theme.of(context).highlightColor,
                Theme.of(context).backgroundColor,
              ]
          ),
        ),
        child: Stack(
          children: <Widget>[
            Positioned(
              top: MediaQuery.of(context).size.height * 0.35,
              left: MediaQuery.of(context).size.width * 0.15,
              child: Text(
                "Forgot Password",
                style: TextStyle(
                  color: Theme.of(context).secondaryHeaderColor,
                  fontSize: 37.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ), //Forgot Password text
            Form(
              key: formKey,
              child: Padding(
                padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 400.0),
                child: showEmailInput(),
              ),
            ), //showEmailInput()
            Positioned(
                top: MediaQuery.of(context).size.height * 0.91,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                    child: GestureDetector(
                      onTap: () {
                        widget.auth.sendPasswordReset("matthewrhb12321@gmail.com");
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Reset Password",
                        style: TextStyle(
                          color: Theme.of(context).secondaryHeaderColor,
                          fontSize: 15.0
                        ),
                      ),
                    ),
                  ),
                ),
            ), //Reset Password button
          ],
        ),
      ),
    );
  }
}