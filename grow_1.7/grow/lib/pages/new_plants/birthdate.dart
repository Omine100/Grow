import 'package:flutter/material.dart';

import 'package:grow/models/Plant.dart';

import 'package:grow/pages/new_plants/image.dart';

class NewPlantBirthdateScreen extends StatelessWidget {
  final Plant plant;
  NewPlantBirthdateScreen({Key, key, @required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _birthdateController = new TextEditingController();
    _birthdateController.text = plant.birthdate;

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
                    "BIRTHDATE",
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
                          controller: _birthdateController,
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
                      plant.birthdate= _birthdateController.text;
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewPlantImageScreen(plant: plant)),
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