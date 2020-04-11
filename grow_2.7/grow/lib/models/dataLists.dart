import 'package:flutter/material.dart';

class DataLists {
  //VARIABLE DECLARATION
  List<Icon> _iconList;
  List<Color> _colorList;

  //MECHANICS: GET ICON DATA
  Icon getIconData(int position) {
    return _iconData(_iconList, position);
  }

  //MECHANICS: GET ICON LIST
  List<Icon> getIconList() {
    return _iconListData(_iconListData(_iconList));
  }

  //MECHANICS: GET COLOR DATA
  Color getColorData(int position) {
    return _colorData(_colorList, position);
  }

  //MECHANICS: GET COLOR LIST
  List<Color> getColorList() {
    return _colorListData(_colorListData(_colorList));
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
List<Color> _colorListData(List<Color> _colorList) {
  _colorList = new List<Color>();
  _colorList.add(Colors.blue);
  _colorList.add(Colors.black);

  return _colorList;
}

//MECHANICS: GET COLOR DATA RETURN
Color _colorData(List<Color> _colorList, int position) {
  _colorList = _colorListData(_colorList);
  return _colorList[position];
}