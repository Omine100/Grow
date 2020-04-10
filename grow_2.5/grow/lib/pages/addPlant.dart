import 'package:flutter/material.dart';

import 'package:grow/widgets/neumorphicContainer.dart';

class AddPlantScreen extends StatefulWidget {
  @override
  _AddPlantScreenState createState() => _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  //VARIABLE DECLARATION: ADD PLANT PROPERTIES
  String _name, _type, _birthDate;
  final _nameTextEditingController = TextEditingController();
  bool isName = true, isType, isBirthDate;

  //USER INTERFACE: ADD PLANT SCREEN
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(
        "Testing",
      ),
    );
  }

  //USER INTERFACE: SHOW TEXT FIELD FOR PLANT NAME
  Widget showAddPlantName(BuildContext context) {
    return new TextFormField(
      controller: _nameTextEditingController,
      autofocus: true,
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.ac_unit, // Change icon
          color: Colors.white,
        ),
        hintText: "Name",
        hintStyle: TextStyle(
          color: Colors.white,
        )
      ),
      onSaved: (value) => _name  = value.trim(),
      obscureText: false,
      maxLines: 1,
      maxLength: null,
    );
  }

  //USER INTERFACE: SHOW BUTTON LIST FOR PLANT TYPE
  Widget showAddPlantType() {
    return new Column(
      children: <Widget>[
        Row(),
        Row(),
        Row(),
      ],
    );
  }

  //USER INTERFACE: SHOW DATE SELECTION FOR PLANT BIRTHDATE
  String showAddPlantBirthDate() {
    String test = "3";
    return test;
  }
}

//USER INTERFACE: SHOW BUTTON FOR PROGRESS
Widget showProgressButton(bool isLast) {
  return NeumorphicContainer(
    child: Padding(
      padding: EdgeInsets.all(10.0),
      child: Icon(
        isLast ? Icons.check_circle : Icons.navigate_next,
        color: Colors.white,
        size: 45.0,
      ),
    ),
  );
}