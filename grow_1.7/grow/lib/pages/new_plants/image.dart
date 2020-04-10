import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import 'package:grow/services/provider.dart';

import 'package:grow/models/Plant.dart';

import 'package:grow/models/Plant.dart';

class NewPlantImageScreen extends StatelessWidget {
  final db = Firestore.instance;

  final Plant plant;
  NewPlantImageScreen({Key, key, @required this.plant}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController _imageController = new TextEditingController();
    _imageController.text = plant.imageURL;

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
                    "IMAGE",
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
                          controller: _imageController,
                          autofocus: true,
                        ),
                      ),
                    ),
                  ),
                  RaisedButton(
                    child: Icon(
                      Icons.check_box,
                      color: Colors.white,
                    ),
                    onPressed: () async {
                      plant.imageURL = _imageController.text;
                      final uid = await Provider.of(context).auth.getCurrentUID();
                      await db.collection('userData').document(uid).collection('plants').add(plant.toJson());
                      Navigator.of(context).popUntil((route) => route.isFirst);
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