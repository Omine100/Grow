import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).backgroundColor,
      child: Stack(
        children: <Widget>[
          Positioned(
            left: MediaQuery.of(context).size.width * 0.175,
            top: MediaQuery.of(context).size.height * 0.2,
            child: Text(
              "Forgot Password",
              style: TextStyle(
                color: Theme.of(context).secondaryHeaderColor,
                fontSize: 30.0,
              ),
            ),
          ),
          Positioned(
            child: Container()
          ),
        ],
      ),
    );
  }
}