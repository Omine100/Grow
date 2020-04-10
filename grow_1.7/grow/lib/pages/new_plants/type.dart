import 'package:flutter/material.dart';

import 'package:grow/models/Plant.dart';

import 'package:grow/pages/new_plants/birthdate.dart';

class NewPlantTypeScreen extends StatelessWidget {
  final Plant plant;
  NewPlantTypeScreen({Key, key, @required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _typeController = new TextEditingController();
    _typeController.text = plant.type;

    return new Container(
      color: Colors.green.shade300,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
              top: MediaQuery.of(context).size.height / 3,
              child: Column(
                children: <Widget>[
                  Text(
                    "TYPE",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 50,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(30.0),
                    child: Material(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: TextField(
                          controller: _typeController,
                          autofocus: true,
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      plant.type = _typeController.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewPlantBirthdateScreen(plant: plant)),
                      );
                    },
                  ),
                ],
              )
          ),
        ],
      ),
    );
  }
}