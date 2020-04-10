import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/models/plant.dart';
import 'package:grow/pages/home.dart';
import 'package:grow/pages/root.dart';
import 'package:grow/widgets/neumorphicContainer.dart';

class UserPlantScreen extends StatefulWidget {
  UserPlantScreen({Key key, this.plantList, this.index, this.auth, this.logoutCallback}) : super(key: key);

  //VARIABLE REFERENCE: NEEDED TO LOAD USER PLANT SCREEN
  final List<Plant> plantList;
  final int index;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  @override
  _UserPlantScreenState createState() => _UserPlantScreenState();
}

class _UserPlantScreenState extends State<UserPlantScreen> {
  //VARIABLE DECLARATION: PLANT LIST VALUES
  List<Plant> _plantList = new List<Plant>();
  int index;
  String name, type, birthDate, plantId, user;

  //VARIABLE DECLARATION: RTDB FORMATTING
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  
  //VARIABLE INITIALIZATION: PLANT LIST VALUES
  @override
  void initState() {
    _plantList = widget.plantList;
    index = widget.index;
    super.initState();
  }

  //JSON: DELETE PLANT
  deletePlant(String plantId, int index) {
    _database.reference().child("plant").child(plantId).remove().then((_) {
      print("Deletion of $plantId successful");
      setState(() {
        _plantList.removeAt(index);
      });
    });
  }

  //USER INTERFACE: USER PLANT SCREEN
  @override
  Widget build(BuildContext context) {
    user = _plantList[index].userId;
    name = _plantList[index].name;
    type = _plantList[index].type;
    birthDate = _plantList[index].birthDate;
    plantId = _plantList[index].key;

    return new Container(
      child: Column(
        children: <Widget>[
          FlatButton(
            onPressed: () async {
              deletePlant(plantId, index);
              Navigator.pushReplacement(
                context, 
                MaterialPageRoute(builder: (context) => HomeScreen(auth: widget.auth, userId: user, logoutCallback: widget.logoutCallback,)),
              );
            }, 
            child: NeumorphicContainer(
              child: Text(
                "Delete plant."
              ),
            ),
          ),
          Text(
            name,
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).dialogBackgroundColor,
            ),
          ),
          Text(
            type,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).dialogBackgroundColor,
            ),
          ),
          Text(
            birthDate,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w300,
              color: Theme.of(context).dialogBackgroundColor,
            ),
          ),
        ],
      ),
    );
  }
}