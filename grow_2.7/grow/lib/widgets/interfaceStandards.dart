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

  //USER INTERFACE: BODY LINEAR GRADIENT
  LinearGradient bodyLinearGradient(BuildContext context, bool isSmall, bool isTitle) {
    final LinearGradient linearGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: isSmall ? Alignment.centerRight : Alignment.bottomRight,
      tileMode: TileMode.mirror,
      colors: [
        Theme.of(context).highlightColor,
        isTitle ? Theme.of(context).dividerColor : Theme.of(context).backgroundColor,
      ]
    );
    return linearGradient;
  }

  //USER INTERFACE: PARENT CENTER
  Widget parentCenter(BuildContext context, Widget child) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: child,
      ),
    );
  }
}