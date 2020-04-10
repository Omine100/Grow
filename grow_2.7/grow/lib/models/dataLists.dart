import 'package:flutter/material.dart';

class DataLists {
  //MECHANISM: GET ICON DATA
  void getIconData(int position) {
    _iconData(position);
  }

  //MECHANISM: GET COLOR DATA
  void getColorData(int position) {
    _colorData(position);
  }
}

//MECHANISM: ICON DATA INITIALIZATION AND RETURN
IconData _iconData(int position) {
  List<IconData> _iconList = new List<IconData>();
  _iconList.add(Icons.add);
  _iconList.add(Icons.delete);

  return _iconList[position];
}

//MECHANISM: GET COLOR DATA INITIALIZATION AND RETURN
Color _colorData(int position) {
  List<Color> _colorList = new List<Color>();
  _colorList.add(Colors.blue);
  _colorList.add(Colors.black);

  return _colorList[position];
}