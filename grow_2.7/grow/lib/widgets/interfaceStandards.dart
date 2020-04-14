import 'package:flutter/material.dart';

class InterfaceStandards {
  //USER INTERFACE: BACK BUTTON
  Widget backButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Icon(
        Icons.keyboard_backspace,
        color: Theme.of(context).scaffoldBackgroundColor,
        size: 35.0,
      ),
    );
  }

  //USER INTERFACE: TEXT LINEAR GRADIENT
  Shader textLinearGradient(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Theme.of(context).highlightColor, Theme.of(context).backgroundColor],
    ).createShader(Rect.fromLTWH(110.0, 100.0, 200.0, 70.0));
    return linearGradient;
  }

}