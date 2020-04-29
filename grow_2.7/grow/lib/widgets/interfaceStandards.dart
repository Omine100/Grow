import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';

import 'package:grow/services/themes.dart';
import 'package:grow/models/dataLists.dart';

class InterfaceStandards {
  DataLists dataLists = new DataLists();
  Themes themes = new Themes();

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

  List<Color> colorsBodyGradient(BuildContext context, bool isTitle) {
    List<Color> gradientColors = [
      Theme.of(context).highlightColor,
      isTitle ? Theme.of(context).dividerColor : Theme.of(context).backgroundColor,
    ];
    return gradientColors;
  }

  //USER INTERFACE: BODY LINEAR GRADIENT
  LinearGradient bodyLinearGradient(BuildContext context, bool isSmall, bool isTitle) {
    final LinearGradient linearGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: isSmall ? Alignment.centerRight : Alignment.bottomRight,
      tileMode: TileMode.mirror,
      colors: colorsBodyGradient(context, isTitle),
    );
    return linearGradient;
  }

  //USER INTERFACE: CARD LINEAR GRADIENT
  LinearGradient cardLinearGradient(BuildContext context, DocumentSnapshot document) {
    final LinearGradient linearGradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        dataLists.getColorData(document['color'], themes.checkDarkTheme(context), true),
        dataLists.getColorData(document['color'], themes.checkDarkTheme(context), false),
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

  //USER INTERFACE: CLEAN CALENDAR
  Calendar cleanCalendar() {
    return Calendar(
      events: dataLists.getCleanCalendarMap(),
      onRangeSelected: (range) =>
        print(range),
      isExpandable: true,
      showTodayIcon: true,
      eventDoneColor: Colors.blue,
      eventColor: Colors.black,
    );
  }
}