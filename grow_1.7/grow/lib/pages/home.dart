import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/provider.dart';

import 'package:grow/models/Plant.dart';

import 'package:grow/pages/plant.dart';
import 'package:grow/pages/new_plants/name.dart';

class HomeScreen extends StatefulWidget {
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = Firestore.instance;

  AuthService auth;

  final newPlant = new Plant(null, null, null, null);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: getUsersPlantsStreamSnapshots(context),
        builder: (context, snapshot){
          if (snapshot.hasData == false) {
            return Container(child: Container(
              alignment: FractionalOffset.center,
              padding: const EdgeInsets.symmetric(vertical: 10.0),
              child: CircularProgressIndicator(
                  backgroundColor: Colors.green.shade100,
              ),
            ));
          };
          if (snapshot.data.documents.length == 0) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewPlantNameScreen(plant: newPlant))
                );
              },
              child: Card(
                color: Colors.green.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                elevation: 2.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Text(
                          "Add a plant!",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
          return new Swiper(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data.documents.length,
            itemBuilder: (BuildContext context, int index) =>
                buildPlantCard(context, snapshot.data.documents[index]),
            viewportFraction: 0.8,
            scale: 0.9,
            autoplay: false,
            loop: false,
          );
//          return new ListView.builder(
//            scrollDirection: Axis.horizontal,
//            itemCount: snapshot.data.documents.length,
//            itemBuilder: (BuildContext context, int index) =>
//              buildPlantCard(context, snapshot.data.documents[index]),
//          );
        },
      ),
    );
  }

  Stream<QuerySnapshot> getUsersPlantsStreamSnapshots(BuildContext context) async* {
    final uid = await Provider.of(context).auth.getCurrentUID();
    yield* Firestore.instance.collection('userData').document(uid).collection('plants').snapshots();
  }

  deleteUsersPlantsStreamSnapshots(DocumentSnapshot plant) async {
    final uid = await Provider.of(context).auth.getCurrentUID();
    await db.collection('userData').document(uid).collection('plants').document(plant.documentID).delete();
  }

  Widget buildPlantCard(BuildContext context, DocumentSnapshot plant) {
    return new GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          //move to other page somehow
          MaterialPageRoute(builder: (context) => PlantScreen(name: plant['name'], type: plant['type'], birthdate: plant['birthdate'], imageURL: plant['imageURL'],)),
        );
      },
      onLongPress: () {
        deleteUsersPlantsStreamSnapshots(plant);
      },
      child: Card(
        color: Colors.green.shade300,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32.0),
        ),
        elevation: 2.0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Align(
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.child_friendly,
                    color: Colors.white,
                    size: 48.0,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                child: Text(
                  plant['name'],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 30.0,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}

const List<Choice> choices = const <Choice>[
  const Choice(title: 'Delete', icon: Icons.delete),
];