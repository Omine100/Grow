import 'package:flutter/material.dart';

import 'package:grow/models/Plant.dart';

class PlantScreen extends StatelessWidget {
  final String name;
  final String type;
  final String birthdate;
  final String imageURL;

  PlantScreen({Key key, @required this.name, this.type, this.birthdate, this.imageURL}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green.shade300,
      child: Column(
        children: <Widget>[
          Text(
            name,
          ),
          Text(
            type,
          ),
          Text(
            birthdate,
          ),
          Text(
            imageURL,
          ),
        ],
      ),
    );
  }
}