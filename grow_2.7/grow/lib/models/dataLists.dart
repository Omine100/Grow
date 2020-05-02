import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:grow/pages/home.dart';

class DataLists {
  //VARIABLE DECLARATION
  List<Icon> _iconList;
  List<Color> _colorList;
  HomeScreen homeScreen = new HomeScreen();

  //MECHANICS: GET ICON DATA
  Icon getIconData(int position) {
    return _iconData(_iconList, position);
  }

  //MECHANICS: GET ICON LIST
  List<Icon> getIconList() {
    return _iconListData(_iconListData(_iconList));
  }

  //MECHANICS: GET COLOR DATA
  Color getColorData(int position, bool darkTheme, bool first) {
    return _colorData(position, getColorList(darkTheme, first),  darkTheme, first);
  }

  //MECHANICS: GET COLOR LIST
  List<Color> getColorList(bool darkTheme, bool first) {
    return _colorListData(_colorList, darkTheme, first);
  }

  //MECHANICS: GET CALENDAR MAP DATA
  Map getCalendarMap(DocumentSnapshot doc) {
    return _calendarMapData(doc);
  }
}

//MECHANICS: ICON DATA INITIALIZATION
List<Icon> _iconListData(List<Icon> _iconList) {
  _iconList = new List<Icon>();
  _iconList.add(Icon(Icons.add, size: 25.0, color: Colors.white,));
  _iconList.add(Icon(Icons.delete, size: 25.0, color: Colors.white,));
  return _iconList;
}

//MECHANICS: ICON DATA RETURN
Icon _iconData(List<Icon> _iconList, int position) {
  _iconList = _iconListData(_iconList);
  return _iconList[position];
}

//MECHANICS: COLOR DATA INITIALIZATION
List<Color> _colorListData(List<Color> _colorList, bool darkTheme, bool first) {
  _colorList = new List<Color>();
  _colorList.add(first ? !darkTheme ? Colors.lightBlueAccent.shade400 : Colors.blue.shade700 : Colors.blue.shade900);
  _colorList.add(first ? !darkTheme ? Colors.grey.shade500 : Colors.black : Colors.grey.shade800);
  return _colorList;
}

//MECHANICS: GET COLOR DATA RETURN
Color _colorData(int position, List<Color> _colorList, bool darkTheme, bool first) {
  return _colorList[position];
}

//MECHANICS: CHECK DAY DONE
bool checkDayDone(DocumentSnapshot doc, DateTime currentDate) {
  Map datesCompleted = doc.data["datesCompleted"];
  int current = datesCompleted[currentDate.toString()];
  if (current > doc.data["goalTotal"]) {
    return true;
  }
  return false;
}

//MECHANICS: GET CALENDAR MAP DATA RETURN
Map _calendarMapData(DocumentSnapshot doc) {
  Map datesCompleted = doc.data["datesCompleted"];
  List keys = datesCompleted.keys.toList();
  Map days;
  for (int i = 0; i < keys.length; i++) {
    days[i] = {
      "currentTime": 0,
      "isDone": checkDayDone(doc, keys[i]),
    };
  }
  return days;
}