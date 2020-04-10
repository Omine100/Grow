import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/provider.dart';

import 'package:grow/models/Plant.dart';

import 'package:grow/pages/home.dart';
import 'package:grow/pages/user.dart';
import 'package:grow/pages/test.dart';
import 'package:grow/pages/new_plants/name.dart';

class NavigationScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _NavigationScreenState();

}

class _NavigationScreenState extends State<NavigationScreen> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.transparent,
    ));

    final newPlant = new Plant(null, null, null, null);

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) => Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Positioned(
              top: MediaQuery.of(context).size.height / 10.0,
              left: MediaQuery.of(context).size.width / 10.0,
              child: navigationTitleBar(),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 4.7,
              left: MediaQuery.of(context).size.width / 10.0,
              child: navigationTabBar(context),
            ),
            Positioned(
              top: MediaQuery.of(context).size.height / 3.0,
              left: MediaQuery.of(context).size.width / 20.0,
              child: Container(
                height: MediaQuery.of(context).size.height / 2.0,
                width: MediaQuery.of(context).size.width / 1.10,
                child: HomeScreen(),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green.shade200,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserScreen()),
          );
        },
        child: Icon(
          Icons.person_outline,
          color: Colors.white,
          size: 44.0,
        ),
        elevation: 4.0,
      ),
      bottomNavigationBar: BottomAppBar(
<<<<<<< HEAD
        shape: CircularNotchedRectangle(),
        color: Colors.green.shade300,
        child: Container(
          height: 60.0,
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Positioned(
                left: 10,
                bottom: 4,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TestScreen()),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Icon(
                        Icons.info_outline,
                        color: Colors.white,
                        size: 48.0,
                      ),
                      Text(
                        " Glossary",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 10,
                bottom: 4,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewPlantNameScreen(plant: newPlant)),
                    );
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        "Add Plant",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 25.0
                        ),
                      ),
                      Icon(
                        Icons.add,
                        color: Colors.white,
                        size: 48.0,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
=======
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 6.0, bottom: 6.0, left: 10.0),
              child: GestureDetector(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserScreen()),
                  );
                },
                child: Icon(
                  Icons.account_circle,
                  size: 48.0,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
        shape: CircularNotchedRectangle(),
        color: Colors.green.shade300,
>>>>>>> parent of 2dc18f1... I don't know what I am doing here.
      ),
    );
  }
}

Widget navigationTitleBar() {
  return Text(
    "Grow",
    style: TextStyle(
      color: Colors.green.shade300,
      fontSize: 80,
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget navigationTabBar(BuildContext context) {
  return Container(
    alignment: Alignment.center,
    color: Colors.transparent,
    height: MediaQuery.of(context).size.height / 13,
    width: MediaQuery.of(context).size.width / 1.3,
    child: DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          backgroundColor: Colors.transparent,
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(20),
            child: Container(
              alignment: Alignment.center,
              color: Colors.transparent,
              child: SafeArea(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    TabBar(
                      isScrollable: true,
                      labelColor: Colors.green.shade500,
                      labelPadding: EdgeInsets.only(left: 11, right: 11),
                      indicatorColor: Colors.transparent,
                      labelStyle: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w600
                      ),
                      unselectedLabelColor: Colors.green.shade400,
                      unselectedLabelStyle: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w300
                      ),
                      tabs: <Widget>[
                        Container(
                          child: Text(
                              "Succulent",
                              style: TextStyle(
                                color: Colors.green.shade500,
                              ),
                          ),
                        ),
                        Container(
                          child: Text(
                              "Produce",
                              style: TextStyle(
                                color: Colors.red.shade300,
                              ),
                          ),
                        ),
                        Container(
                          child: Text(
                              "Flowers",
                              style: TextStyle(
                                color: Colors.orange.shade300,
                              ),
                          ),
                        ),
                        Container(
                          child: Text(
                            "Shrub",
                            style: TextStyle(
                              color: Colors.blue.shade800,
                            ),
                          ),
                        ),
                        Container(
                          child: Text(
                              "Other",
                              style: TextStyle(
                                color: Colors.black38,
                              ),
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: <Widget>[
            Center(
              child: Text(
                "Succulents Tab",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Center(
              child: Text(
                "Produce Tab",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Center(
              child: Text(
                "Flowers Tab",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Center(
              child: Text(
                "Shrubs Tab",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
            Center(
              child: Text(
                "Other Tab",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget navigationUserBar() {
  return Icon(
    Icons.account_circle,
    color: Colors.green.shade400,
    size: 60,
  );
}

Widget navigationAddBar() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: <Widget>[
      Container(
        height: 60,
        width: 225,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.green.shade300,
          borderRadius: BorderRadius.only(topLeft: Radius.circular(35)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Icon(
              Icons.add,
              color: Colors.white,
            ),
            Text(
              "Add Plant",
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}