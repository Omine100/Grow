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
  Color getColorData(int position, bool darkTheme) {
    return _colorData(_colorList, position, darkTheme);
  }

  //MECHANICS: GET COLOR LIST
  List<Color> getColorList(bool darkTheme) {
    return _colorListData(_colorList, darkTheme);
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
List<Color> _colorListData(List<Color> _colorList, bool darkTheme) {
  _colorList = new List<Color>();
  _colorList.add(!darkTheme ? Colors.blue.shade400 : Colors.blue.shade600);
  _colorList.add(!darkTheme ? Colors.black : Colors.grey.shade700);

  return _colorList;
}

//MECHANICS: GET COLOR DATA RETURN
Color _colorData(List<Color> _colorList, int position, bool darkTheme) {
  _colorList = _colorListData(_colorList, darkTheme);
  return _colorList[position];
}