import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'dart:async';

import 'package:grow/services/authentication.dart';
import 'package:grow/widgets/neumorphicContainer.dart';
import 'package:grow/models/plant.dart';
import 'package:grow/pages/addPlant.dart';
import 'package:grow/pages/userPlant.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.auth, this.logoutCallback, this.userId, this.list});

  //VARIABLE REFERENCE: NEEDED TO LOAD HOME SCREEN
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final List<Plant> list;

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //VARIABLE DECLARATION: RTDB FORMATTING
  final DatabaseReference = Firestore.instance;
  String name, type, birthDate;

  //MECHANICS: REBUILD CHILDREN
  void rebuildAllChildren(BuildContext context) {
    void rebuild(Element el) {
      el.markNeedsBuild();
      el.visitChildren(rebuild);
    }
    (context as Element).visitChildren(rebuild);
  }

  //MECHANICS: READ PLANTS
  void getData() {
    DatabaseReference
      .collection(widget.userId)
      .getDocuments()
      .then((snapshot) {
        snapshot.documents.forEach((f) => print('${f.data}'));
      });
      builder(QuerySnapshot)
  }

  //MECHANICS: DELETE PLANT
  deletePlant(String userId, String plantId, int index) {
    try {
      DatabaseReference
        .collection(userId)
        .document(plantId)
        .delete();
      print("Deletion of $plantId successful");
    } catch (e) {
      print(e.toString());
    }
  }

  //USER INTERFACE: SHOW PLANT LIST
  Widget showPlantList(BuildContext context) {
    if (_plantList.length > 0) {
      return Container(
        height: MediaQuery.of(context).size.height * 0.50,
        width: MediaQuery.of(context).size.width * 1.0,
        child: new Swiper(
          scrollDirection: Axis.horizontal,
          itemCount: _plantList.length,
          itemBuilder: (BuildContext context, int index) {
            return buildPlantCard(context, index);
          },
          viewportFraction: 0.75,
          scale: 0.95,
          autoplay: false,
          loop: false,
        ),
      );
    } else {
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPlantScreen(auth: widget.auth, logoutCallback: widget.logoutCallback, userId: widget.userId, list: widget.list,))
          );
        },
        child: buildEmptyPlantCard(context, "Add a Plant"),
      );
    }
  }

  //USER INTERFACE: BUILD PLANT CARD
  Widget buildPlantCard(BuildContext context, int index) {
    String plantKey = _plantList[index].key;
    String plantName = _plantList[index].name;
    String planyType = _plantList[index].type;
    String plantBirthDate = _plantList[index].birthDate;
    String userId = _plantList[index].userId; 

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserPlantScreen())
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: NeumorphicContainer(
          radius: 50.0,
          clickable: true,
          height: null,
          width: null,
          padding: 5.0,
          color: Theme.of(context).accentColor,

          child: Padding(
            padding: EdgeInsets.only(left: 25.0, top: 20.0),
            child: Text(
              plantName,
              style: TextStyle(
                color: Theme.of(context).dialogBackgroundColor,
                fontSize: 35.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //USER INTERFACE: BUILD AN EMPTY PLANT CARD
  Widget buildEmptyPlantCard(BuildContext context, String text) {
    return NeumorphicContainer(
      radius: 50.0,
      clickable: true,
      height: MediaQuery.of(context).size.height * 0.45,
      width: MediaQuery.of(context).size.width * 0.65,
      padding: 5.0,
      color: Theme.of(context).accentColor,

      child: Center(
        child: Text(
          text,
          style: TextStyle(
            color: Theme.of(context).dialogBackgroundColor,
            fontSize: 30.0,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  //USER INTERFACE: HOME SCREEN
  @override
  Widget build(BuildContext context) {
    rebuildAllChildren(context);
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        child: new Stack (
          children: <Widget>[
            Positioned(
              left: MediaQuery.of(context).size.width * 0.79,
              top: MediaQuery.of(context).size.height * 0.0525,
              child: GestureDetector(
                onTap: () {
                  widget.auth.signOut();
                  widget.logoutCallback();
                },
                child: showUserButton(context),
              ),
            ), 
            Positioned(
              top: MediaQuery.of(context).size.height * 0.17,
              left: MediaQuery.of(context).size.width * 0.05,
              right: MediaQuery.of(context).size.width * 0.05,
              child: showTabs(context),
            ),
            Positioned(
              right: MediaQuery.of(context).size.width * 0.40,
              top: MediaQuery.of(context).size.height * 0.0875,
              child: showTitle(context)
            ),
            Positioned(
              top: MediaQuery.of(context).size.width * 0.625,
              child: showPlantList(context)
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: Colors.green.shade300,
        notchMargin: 9.0,
        clipBehavior: Clip.antiAlias,
        child: BottomNavigationBar(
          backgroundColor: Theme.of(context).accentColor,
          items: [
            BottomNavigationBarItem(
              title: Text(
                "",
                style: TextStyle(
                  color: Theme.of(context).dialogBackgroundColor,
                  fontSize: 0.0,
                ),
              ),
              icon: Icon(
                Icons.person,
                color: Colors.white,
                size: 35.0,
              ),
            ),
            BottomNavigationBarItem(
              title: Text(
                "",
                style: TextStyle(
                  color: Theme.of(context).dialogBackgroundColor,
                  fontSize: 0.0
                ),
              ),
              icon: Icon(
                Icons.play_circle_outline,
                color: Colors.white,
                size: 35.0,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddPlantScreen(auth: widget.auth, logoutCallback: widget.logoutCallback, userId: widget.userId,)),
          );
        },
        child: NeumorphicContainer(
          radius: 360,
          clickable: true,
          height: 65.0,
          width: 65.0,
          padding: 0.0,

          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 45.0,
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

//USER INTERFACE: SHOW USER BUTTON
Widget showUserButton(BuildContext context) {
  return new NeumorphicContainer(
    radius: 360,
    clickable: true,
    height: 65.0,
    width: 65.0,
    padding: 0.0,
    color: Theme.of(context).accentColor,

    child: Icon(
      Icons.person,
      size: 45.0,
      color: Colors.white,
    ),
  );
}

//USER INTERFACE: SHOW TABS
Widget showTabs(BuildContext context) {
  return Container(
    color: Colors.transparent,
    height: MediaQuery.of(context).size.height,
    width: MediaQuery.of(context).size.width * 1.0,

    child: DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: Container(
              color: Colors.transparent,
              child: SafeArea(
                child: Column(
                  children: <Widget>[
                    TabBar(
                      isScrollable: true,
                      indicatorColor: Theme.of(context).backgroundColor,
                      labelStyle: TextStyle(
                          fontSize: 35,
                          fontWeight: FontWeight.w700
                      ),
                      unselectedLabelStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w300
                      ),
                      tabs: <Widget>[
                        Container(
                          child: Text(
                              "Plants",
                              style: TextStyle(
                                color: Colors.green.shade600,
                              ),
                          ),
                        ),
                        Container(
                          child: Text(
                              "Succulents",
                              style: TextStyle(
                                color: Colors.green.shade600,
                              ),
                          ),
                        ),
                        Container(
                          child: Text(
                              "Produce",
                              style: TextStyle(
                                color: Colors.green.shade600,
                              ),
                          ),
                        ), 
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ),
  );
}

//USER INTERFACE: SHOW TITLE
Widget showTitle(BuildContext context) {
  return new NeumorphicContainer(
    radius: 50.0,
    clickable: false,
    height: 80.0,
    width: MediaQuery.of(context).size.width * 0.7,
    padding: 0.0,
    color: Theme.of(context).accentColor,

    child: Padding(
      padding: const EdgeInsets.only(top: 3.0, left: 60),
      child: Text(
        "GROW",
        style: TextStyle(
          color: Colors.white,
          fontSize: 65.0,
          fontWeight: FontWeight.w700
        ),
      ),
    ),
  );
}