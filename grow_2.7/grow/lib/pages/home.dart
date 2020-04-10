import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/cloudFirestore.dart';
import 'package:grow/widgets/neumorphicContainer.dart';
import 'package:grow/models/goal.dart';
import 'package:grow/models/dataLists.dart';
import 'package:grow/pages/userGoal.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.auth, this.logoutCallback, this.userId});

  //VARIABLE REFERENCE: NEEDED TO LOAD HOME SCREEN
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //VARIABLE DECLARATION
  int currentIndex;
  CloudFirestore cloudFirestore = new CloudFirestore();
  DataLists _dataList = new DataLists();
  final db = Firestore.instance;

  //VARIABLE INITIALIZATION: BOTTOM NAVIGATION BAR
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  //MECHANISM: BOTTOM NAVIGATION BAR CHANGE PAGE
  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  //MECHANISM: GET SPECIFIC ICON DATA
  void _getIconData(int position) {
    _dataList.getIconData(position);
  }

  //USER INTERFACE: GOAL CARD
  Widget buildGoalCard(DocumentSnapshot document, CloudFirestore cloudFirestore) {
    String title = document['title'];

    return new Padding(
      padding: EdgeInsets.only(left: 5.0, right: 5.0, bottom: 20.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  UserGoal(
                    auth: widget.auth,
                    logoutCallback: widget.logoutCallback,
                    userId: widget.userId,
                    documentSnapshot: document,
                  )
              )
          );
        },
        onLongPress: () {
          cloudFirestore.deleteData(document);
        },
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width * 0.32,
          child: Card(
            color: Colors.blueGrey.shade300,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(62.0),
                  topLeft: Radius.circular(15.0),
                  bottomRight: Radius.circular(15.0),
                  bottomLeft: Radius.circular(15.0)
              ),
            ),
            elevation: 10.0,
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.1,
                  left: MediaQuery.of(context).size.width * 0.1,

                  child: Text(
                    title,
                    style: TextStyle(
                      color: Colors.white,
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

  //USER INTERFACE: HOME SCREEN
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      body: Container(
        child: Stack(
          children: <Widget>[
            Positioned(
              top: MediaQuery.of(context).size.height * 0.075,
              right: MediaQuery.of(context).size.width * 0.4,
              child: showTitle(context),
            ), //showTitle()
            Positioned(
              top: MediaQuery.of(context).size.height * 0.0525,
              left: MediaQuery.of(context).size.width * 0.775,
              child: GestureDetector(
                onTap: () {
                  widget.auth.signOut();
                  widget.logoutCallback();
                },
                child: showUserButton(context),
              ),
            ), //showUserButton()
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2,
              left: MediaQuery.of(context).size.width * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Progress",
                    style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 22.5,
                        fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                  ),
                  Text(
                    "Details",
                    style: TextStyle(
                        color: Colors.blueGrey.shade600,
                        fontSize: 17.5,
                        fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 22.5,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ), //Progress text
            Positioned(
              top: MediaQuery.of(context).size.height * 0.2325,
              left: MediaQuery.of(context).size.width * 0.05,
              child: Padding(
                padding: EdgeInsets.only(
                    top: 15.0,
                    right: 0.0,
                    bottom: 15.0,
                    left: 30.0
                ),
                child: NeumorphicContainer(
                  height: MediaQuery.of(context).size.height * 0.29,
                  width: MediaQuery.of(context).size.width * 0.75,
                  radius: 40.0,
                  clickable: false,
                  padding: 25.0,
                  color: Theme.of(context).dialogBackgroundColor,

                  child: Text(
                    "Test"
                  ),
                ),
              ),
            ), //Progress box
            Positioned(
              top: MediaQuery.of(context).size.height * 0.56,
              left: MediaQuery.of(context).size.width * 0.05,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  Text(
                    "Goals",
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 22.5,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.45,
                  ),
                  Text(
                    "Customize",
                    style: TextStyle(
                      color: Colors.blueGrey.shade600,
                      fontSize: 17.5,
                      fontWeight: FontWeight.w400
                    ),
                  ),
                  SizedBox(
                    width: 5.0,
                  ),
                  Icon(
                    Icons.arrow_forward,
                    size: 22.5,
                    color: Colors.grey.shade600,
                  ),
                ],
              ),
            ), //Goals text
            Positioned(
              top: MediaQuery.of(context).size.height * 0.6075,
              left: MediaQuery.of(context).size.width * -0.01,
              right: MediaQuery.of(context).size.width * -0.01,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.290,
                width: MediaQuery.of(context).size.width * 1.0,
                child: new StreamBuilder(
                  stream: db.collection(widget.userId).snapshots(),
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return new ListView(
                      padding: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width * 0.1,
                        right: MediaQuery.of(context).size.width * 0.1,
                      ),
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data.documents.map((DocumentSnapshot document) {
                        return buildGoalCard(document, cloudFirestore);
                      }).toList(),
                    );
                  },
                ),
              ),
            ), //Goal boxes
          ],
        ),
      ),
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: currentIndex,
        fabLocation: BubbleBottomBarFabLocation.end,
        onTap: changePage,
        hasNotch: true,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        elevation: 8.0,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.blueAccent,
              icon: Icon(
                Icons.dashboard,
                color: Colors.grey.shade600,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.blueAccent,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.indigo,
              icon: Icon(
                Icons.access_time,
                color: Colors.grey.shade600,
              ),
              activeIcon: Icon(
                Icons.access_time,
                color: Colors.indigo,
              ),
              title: Text("Logs")),
          BubbleBottomBarItem(
              backgroundColor: Colors.deepPurpleAccent,
              icon: Icon(
                Icons.folder_open,
                color: Colors.grey.shade600,
              ),
              activeIcon: Icon(
                Icons.folder_open,
                color: Colors.deepPurpleAccent,
              ),
              title: Text("Folders")),
          BubbleBottomBarItem(
              backgroundColor: Colors.purple,
              icon: Icon(
                Icons.menu,
                color: Colors.grey.shade600,
              ),
              activeIcon: Icon(
                Icons.menu,
                color: Colors.purple,
              ),
              title: Text("Menu"))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          cloudFirestore.createData("title");
        },
        child: Icon(
          Icons.add,
          color: Theme.of(context).scaffoldBackgroundColor,
        ),
        backgroundColor: Theme.of(context).accentColor,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}

//USER INTERFACE: SHOW TITLE
Widget showTitle(BuildContext context) {
  return new Container(
    height: MediaQuery.of(context).size.height * 0.1,
    width: MediaQuery.of(context).size.width * 0.7,

    child: Card(
      color: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.0)
      ),
      elevation: 10.0,

      child: Padding(
        padding: EdgeInsets.only(left: 60.0),
        child: Text(
          "GROW",
          style: TextStyle(
            color: Theme.of(context).scaffoldBackgroundColor,
            fontSize: 65.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    ),
  );
}

//USER INTERFACE: SHOW USER BUTTON
Widget showUserButton(BuildContext context) {
  return new Container(
    height: 75.0,
    width: 75.0,
    color: Colors.transparent,

    child: Card(
      color: Theme.of(context).accentColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(360),
      ),
      elevation: 15.0,
      child: Icon(
        Icons.person,
        size: 55.0,
        color: Colors.white,
      ),
    ),
  );
}