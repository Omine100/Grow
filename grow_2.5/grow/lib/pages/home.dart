import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:async';

import 'package:grow/services/authentication.dart';
import 'package:grow/widgets/neumorphicContainer.dart';
import 'package:grow/models/plant.dart';
import 'package:grow/pages/userPlant.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.auth, this.userId, this.logoutCallback}) : super(key: key);

  //VARIABLE REFERENCE: NEEDED TO LOAD HOME SCREEN
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //AUTHENTICATION: SIGNOUT
  signOut() async {
    try {
      await widget.auth.signOut();
      widget.logoutCallback();
    } catch (e) {
      print(e);
    }
  }

  //VARIABLE DECLARATION: RTDB FORMATTING
  List<Plant> _plantList;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final _nameTextEditingController = TextEditingController();
  final _typeTextEditingController = TextEditingController();
  final _birthDateTextEditingController = TextEditingController();
  StreamSubscription<Event> _onPlantAddedSubscription;
  StreamSubscription<Event> _onPlantChangedSubscription;
  Query _plantQuery;
  String name, type, birthDate; 

  //VARIABLE INITITALIZATION: RTDB VALUES
  @override
  void initState() {
    super.initState();

    _plantList = new List();
    _plantQuery = _database
        .reference()
        .child("plant")
        .orderByChild("userId")
        .equalTo(widget.userId);
    _onPlantAddedSubscription = _plantQuery.onChildAdded.listen(onEntryAdded);
    _onPlantChangedSubscription = _plantQuery.onChildChanged.listen(onEntryChanged);
  }

  //MECHANICS: DISPOSE ENTRY
  @override
  void dispose() {
    _onPlantAddedSubscription.cancel();
    _onPlantChangedSubscription.cancel();
    super.dispose();
  }

  //MECHANICS: ENTRY ADDED
  onEntryAdded(Event event) {
    setState(() {
      _plantList.add(Plant.fromSnapshot(event.snapshot));
    });
  }

  //MECHANICS: ENTRY CHANGED
  onEntryChanged(Event event) {
    var oldEntry = _plantList.singleWhere((entry) {
      return entry.key == event.snapshot.key;
    });

    setState(() {
      _plantList[_plantList.indexOf(oldEntry)] = Plant.fromSnapshot(event.snapshot);
    });
  }

  //JSON: ADD PLANT
  addNewPlant(String plantName, String plantType, String plantBirthDate) {
    if (plantName.length > 0 && plantType.length > 0 && plantBirthDate.length > 0) {
      Plant plant = new Plant(widget.userId, plantName.toString(), plantType.toString(), plantBirthDate.toString());
      _database.reference().child("plant").push().set(plant.toJson());
    }
  }

  //JSON: UPDATE PLANT
  updatePlant(Plant plant, String plantName, String plantType, String plantBirthDate) {
    plant.name = plantName.toString();
    plant.type = plantType.toString();
    plant.birthDate = plantBirthDate.toString();
    
    if (plant != null) {
      _database.reference().child("plant").child(plant.key).set(plant.toJson());
    }
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

  //USER INTERFACE: ADD PLANT
  showAddPlantDialog(BuildContext context) async {
    _nameTextEditingController.clear();
    _typeTextEditingController.clear();
    _birthDateTextEditingController.clear();
    await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new Column(
            children: <Widget>[
              TextField(
                controller: _nameTextEditingController,
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: "Plant name",
                )
              ),
              TextField(
                controller: _typeTextEditingController,
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: "Plant type",
                )
              ),
              TextField(
                controller: _birthDateTextEditingController,
                autofocus: true,
                decoration: new InputDecoration(
                  labelText: "Plant birthdate",
                )
              ),
            ],
          ),
          actions: <Widget>[
            new FlatButton(
              child: const Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            new FlatButton(
              child: const Text("Save"),
              onPressed: () {
                addNewPlant(_nameTextEditingController.text.toString(), _typeTextEditingController.text.toString(), _birthDateTextEditingController.text.toString());
                Navigator.pop(context);
              },
            ),
          ],
        );
      }
    );
  }

  //USER INTERFACE: SHOW PLANT LIST
  Widget showPlantList() {
    if (_plantList.length > 0) {
      return Swiper(
        scrollDirection: Axis.horizontal,
        itemCount: _plantList.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildPlantItem(context, index);
        },
        viewportFraction: 0.8,
        scale: 0.9,
        autoplay: false,
        loop: false,
      );
    } else {
      return Center(
        child: Column(
          children: <Widget>[
            Text(
              "Add a plant",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            GestureDetector(
              child: NeumorphicContainer(
                child: Text(
                  "Add a plant",
                ),
              ),
            ),
          ],
        ),
      );
    }
  }

  //USER INTERFACE: BUILD LIST ITEM
  Widget _buildPlantItem(BuildContext context, int itemIndex) {
    String plantKey = _plantList[itemIndex].key;
    String plantName = _plantList[itemIndex].name;          
    String plantType = _plantList[itemIndex].type;
    String plantBirthDate = _plantList[itemIndex].birthDate;
    String userId = _plantList[itemIndex].userId;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => UserPlantScreen(plantList: _plantList, index: itemIndex, auth: widget.auth, logoutCallback: widget.logoutCallback,))
        );
      },
      onLongPress: () {
        deletePlant(plantKey, itemIndex);
      },
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: NeumorphicContainer(
          child: Column(
            children: <Widget>[
              Text(
                userId,
                style: TextStyle(
                  fontSize: 10.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              Text(
                plantName,
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Text(
                plantType,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
              Text(
                plantBirthDate,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  //USER INTERFACE: HOME SCREEN
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            verticalDirection: VerticalDirection.down,
            children: <Widget>[
              FlatButton(
                child: Text(
                  "Logout",
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black,
                  ),
                ),
                onPressed: signOut,
              ),
              showPlantList(),
              GestureDetector(
                child: showAddPlantButton(context),
                onTap: () {
                  showAddPlantDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//USER INTERFACE: SHOW ADD PLANT BUTTON
Widget showAddPlantButton(BuildContext context) {
  return new NeumorphicContainer(
    child: Padding(
      padding: EdgeInsets.all(12.5),
      child: Stack(
        children: <Widget>[
          Icon(
            Icons.add,
            color: Theme.of(context).dialogBackgroundColor,
            size: 40.0,
          ),
        ],
      ),
    ),
  );
}