import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/widgets/neumorphicContainer.dart';
import 'package:grow/models/plant.dart';
import 'package:grow/pages/home.dart';

class AddPlantScreen extends StatefulWidget {
  AddPlantScreen({this.auth, this.logoutCallback, this.userId, this.list});

  //VARIABLE REFERENCE: NEEDED TO LOAD ADD PLANT SCREEN
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final List<Plant> list;

  @override
  State<StatefulWidget> createState() => new _AddPlantScreenState();
}

class _AddPlantScreenState extends State<AddPlantScreen> {
  //VARIABLE DECLARATION: ADD PLANT PROPERTIES
  final DatabaseReference = Firestore.instance;
  String _name, _type, _birthDate;
  final _nameTextEditingController = TextEditingController();
  final _birthDateTextEditingController = TextEditingController();
  String typeController;
  int show = 0;

  //MECHANICS: ADD PLANT
  void addNewPlant(String name, String type, String birthDate) async {
    DocumentReference ref = await DatabaseReference.collection(widget.userId)
      .add({
        'name': name.toString(),
        'type': type.toString(),
        'birthDate': birthDate.toString(),
      });
      print(ref.documentID);
  }

  //USER INTERFACE: SHOW SELECTION
  Widget buildShow() {
    if (show == 0) {
      return Padding(
        padding: const EdgeInsets.only(left: 60, right: 60, top: 250.0),
        child: Column(
          children: <Widget>[
            Text(
              "NAME",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 35.0
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: showAddPlantName(context, _name),
            ),
          ],
        ),
      ); 
    } else if (show == 1) {
      return Padding(
        padding: const EdgeInsets.only(top: 125.0),
        child: Column(
          children: <Widget>[
            Text(
              "TYPE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 35.0
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: showAddPlantType(context, _type, typeController),
            ),
          ],
        ),
      ); 
    } else if (show == 2) {
      return Padding(
        padding: const EdgeInsets.only(left: 60, right: 60, top: 250.0),
        child: Column(
          children: <Widget>[
            Text(
              "BIRTH DATE",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 35.0
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: showAddPlantBirthDate(context, _birthDate),
            ),
          ],
        ),
      ); 
    } else {
      return Container(
        height: 0.0,
        width: 0.0,
        color: Colors.transparent,
      );
    }
  }

  //USER INTERFACE: SHOW TEXT FIELD FOR PLANT NAME
  Widget showAddPlantName(BuildContext context, _name) {
    return new TextFormField(
      controller: _nameTextEditingController,
      keyboardType: TextInputType.text,
      style: TextStyle(
        color: Theme.of(context).dialogBackgroundColor,
        fontSize: 22.0,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.supervised_user_circle,
          color: Theme.of(context).dialogBackgroundColor,
        ),
        hintText: "Name",
        hintStyle: TextStyle(
          color: Theme.of(context).dialogBackgroundColor,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).dialogBackgroundColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).dialogBackgroundColor,
          )
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).dialogBackgroundColor,
          ),
        ),
      ),
    );
  }

  //USER INTERFACE: SHOW DATE SELECTION FOR PLANT BIRTH DATE
  Widget showAddPlantBirthDate(BuildContext context, _birthDate) {
    return new TextFormField(
      controller: _birthDateTextEditingController,
      keyboardType: TextInputType.text,
      style: TextStyle(
        color: Theme.of(context).dialogBackgroundColor,
        fontSize: 22.0,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          Icons.supervised_user_circle,
          color: Theme.of(context).dialogBackgroundColor,
        ),
        hintText: "Birth Date",
        hintStyle: TextStyle(
          color: Theme.of(context).dialogBackgroundColor,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).dialogBackgroundColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).dialogBackgroundColor,
          )
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).dialogBackgroundColor,
          ),
        ),
      ),
    );
  }

  //USER INTERFACE: ADD PLANT SCREEN
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: new Container(
          color: Theme.of(context).backgroundColor,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                buildShow(),
                Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: GestureDetector(
                    onTap: () {
                      if (show != 2) {
                        setState(() {
                          show = show + 1;
                          buildShow();
                        });
                      } else {
                        addNewPlant(_nameTextEditingController.text.toString(), typeController, _birthDateTextEditingController.text.toString());
                        Navigator.pop(context);
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 17.0),
                      child: showContinueButton(show)
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//USER INTERFACE: SHOW BUTTON LIST FOR PLANT TYPE
Widget showAddPlantType(BuildContext context, _type, String typeController) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.5,
    child: new Swiper(
      scrollDirection: Axis.horizontal,
      itemCount: 3,
      itemBuilder: (BuildContext context, int type) {
        return buildAddPlantType(context, type, typeController);
      },
      viewportFraction: 0.90,
      scale: 0.75,
      autoplay: false,
      loop: false,
    ),
  );
}

//USER INTERFACE: BUILDS ADD PLANT TYPE STRUCTURE
Widget buildAddPlantType(BuildContext context, int category, String typeController) {
  List<String> list = new List();
  
  if (category == 0) {
    list.clear();
    list.add("succulent 1");
    list.add("succulent 2");
    list.add("succulent 3");
    list.add("succulent 4");
    list.add("succulent 5");
    list.add("succulent 6");
    list.add("succulent 7");
    list.add("succulent 8");
    list.add("succulent 9");
  } else if (category == 1) {
    list.clear();
    list.add("plant 1");
    list.add("plant 2");
    list.add("plant 3");
    list.add("plant 4");
    list.add("plant 5");
    list.add("plant 6");
    list.add("plant 7");
    list.add("plant 8");
    list.add("plant 9");
  } else if (category == 2) {
    list.clear();
    list.add("Carrot");
    list.add("Avocado");
    list.add("Basil");
    list.add("Potatoes");
    list.add("Tomatoes");
    list.add("Peppers");
    list.add("Lettuce");
    list.add("Cucumbers");
    list.add("Beets");
  }

  return new GridView.count(
    primary: false,
    padding: const EdgeInsets.all(20),
    crossAxisSpacing: 20,
    mainAxisSpacing: 20,
    crossAxisCount: 3,

    children: <Widget>[
      buildTypeButton(context, list, 0, typeController),
      buildTypeButton(context, list, 1, typeController),
      buildTypeButton(context, list, 2, typeController),
      buildTypeButton(context, list, 3, typeController),
      buildTypeButton(context, list, 4, typeController),
      buildTypeButton(context, list, 5, typeController),
      buildTypeButton(context, list, 6, typeController),
      buildTypeButton(context, list, 7, typeController),
      buildTypeButton(context, list, 8, typeController),
    ],
  );
}

//USER INTERFACE: BUILD ADD PLANT TYPE BUTTON
Widget buildTypeButton(BuildContext context, List<String> list, int position, String typeController) {
  return GestureDetector(
    onTap: () {
      typeController = "Type";
    },
    child: NeumorphicContainer(
      radius: 15.0,
      clickable: true,
      height: 55.0,
      width: 55.0,
      padding: 0.0,

      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            list[position],
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
            ),
          ),
          Icon(
            Icons.add_box,
            color: Colors.white,
            size: 35.0,
          ),
        ],
      ),
    ),
  );
}

//USER INTERFACE: SHOW BUTTON FOR PROGRESSION
Widget showContinueButton(int show) {
  return new NeumorphicContainer(
    radius: 360,
    clickable: true,
    height: 55,
    width: 55,
    padding: 1.0,

    child: Icon(
      show != 2 ? Icons.navigate_next : Icons.check,
      color: Colors.white,
      size: 35.0,
    ),
  );
}