import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';
import 'package:animations/animations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/cloudFirestore.dart';
import 'package:grow/services/methodStandards.dart';
import 'package:grow/services/animationStandards.dart';
import 'package:grow/services/themes.dart';
import 'package:grow/widgets/interfaceStandards.dart';
import 'package:grow/models/dataLists.dart';
import 'package:grow/pages/profile.dart';
import 'package:grow/pages/userGoal.dart';
import 'package:grow/pages/addGoal.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key, this.auth, this.logoutCallback, this.userId, this.streamSnapshot});

  //VARIABLE REFERENCE: NEEDED TO LOAD HOME SCREEN
  final BaseAuth auth;
  final VoidCallback logoutCallback;
  final String userId;
  final Stream<QuerySnapshot> streamSnapshot;

  @override
  State<StatefulWidget> createState() => new _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //VARIABLE DECLARATION
  CloudFirestore cloudFirestore = new CloudFirestore();
  MethodStandards methodStandards = new MethodStandards();
  AnimationStandards animationStandards = new AnimationStandards();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  Themes themes = new Themes();
  DataLists dataLists = new DataLists();
  Stopwatch stopwatch = new Stopwatch();
  final db = Firestore.instance;
  ContainerTransitionType transitionType = ContainerTransitionType.fade;
  int currentIndex;

  //VARIABLE INITIALIZATION: BOTTOM NAVIGATION BAR
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
    getGreeting();
  }

  //MECHANICS: BOTTOM NAVIGATION BAR CHANGE PAGE
  void changePage(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  //MECHANICS: GET GREETING
  String getGreeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return "Good Morning";
    } else if (hour < 17) {
      return "Good Afternoon";
    }
    return "Good Evening";
  }


  //USER INTERFACE: SHOW TITLE
  Container showTitle() {
    setState(() {
      getGreeting();
    });
    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      color: Colors.transparent,
      child: Text(
        getGreeting(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 42.5,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  //USER INTERFACE: SHOW USER BUTTON
  Container showUserButton() {
    return Container(
      width: 50.0,
      height: 50.0,
      child: animationStandards.showContainerTransitionAnimation(
        context, 
        3, 
        widget.auth, 
        widget.logoutCallback, 
        widget.userId, 
        null, 
        null
      ),
    );
  }

  //USER INTERFACE: LINE CHART
  Widget lineChart() {
    return interfaceStandards.parentCenter(context,
        Container(
          height: MediaQuery.of(context).size.height * 0.295,
          width: MediaQuery.of(context).size.width,
          child: LineChart(
            LineChartData(
              gridData: FlGridData(
                show: false,
              ),
              titlesData: FlTitlesData(
                  show: false,
                  bottomTitles: SideTitles(
                    showTitles: true,
                    reservedSize: 22,
                    textStyle:
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
                    getTitles: (value) {
                      switch (value.toInt()) {
                        case 2:
                          return 'MAR';
                        case 5:
                          return 'JUN';
                        case 8:
                          return 'SEP';
                      }
                      return '';
                    },
                    margin: 8,
                  ),
                  leftTitles: SideTitles(
                    showTitles: false,
                  ),
                  rightTitles: SideTitles(
                    showTitles: false,
                  )
              ),
              borderData:
              FlBorderData(show: false, border: Border.all(color: const Color(0xff37434d), width: 1)),
              minX: 0,
              maxX: 11,
              minY: 0,
              maxY: 6,
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    FlSpot(0, 2),
                    FlSpot(2.6, 1),
                    FlSpot(4.9, 5),
                    FlSpot(6.8, 3.1),
                    FlSpot(8, 4),
                    FlSpot(9.5, 3),
                    FlSpot(11, 4),
                  ],
                  isCurved: true,
                  colors: [
                    Colors.grey.shade300,
                    Colors.white,
                  ],
                  barWidth: 5,
                  isStrokeCapRound: true,
                  dotData: FlDotData(
                    show: false,
                  ),
                  curveSmoothness: 0.25,
                  belowBarData: BarAreaData(
                    show: false,
                    colors: interfaceStandards.colorsBodyGradient(context, false).map((color) => color.withOpacity(0.3)).toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  //USER INTERFACE: SHOW SECTION TEXT
  Widget showSectionText(bool isFavorite) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: EdgeInsets.only(
          top: isFavorite ? MediaQuery.of(context).size.height * 0.025 : MediaQuery.of(context).size.height * 0.009,
          left: MediaQuery.of(context).size.width * 0.05,
        ),
        child: Text(
          isFavorite ? "Favorites" : "Goals",
          style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 22.5,
            fontWeight: FontWeight.w500
          ),
        ),
      ),
    );
  }

  //USER INTERFACE: FAVORITE CARD STREAM BUILDER
  Widget showFavoriteCardStreamBuilder() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.13,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: db.collection(widget.userId).document("Favorites").collection("Goals").snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if(snapshot.data.documents.isEmpty) {
              return interfaceStandards.parentCenter(context, 
                Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.09,
                      width: MediaQuery.of(context).size.height * 0.09,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hoverColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: interfaceStandards.parentCenter(context, 
                        Icon(
                          Icons.favorite_border,
                          size: MediaQuery.of(context).size.height * 0.05,
                          color: Theme.of(context).canvasColor,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 9.0,
                    ),
                    Text(
                      "No Favorites",
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return new ListView(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                scrollDirection: Axis.horizontal,
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return buildFavoriteCard(document);
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }

  //USER INTERFACE: FAVORITE CARD
  Widget buildFavoriteCard(DocumentSnapshot doc) {
    DocumentSnapshot documentSnapshot;
    var documentReference = db.collection(widget.userId).document(doc['documentId']);
    documentReference.get().then((DocumentSnapshot) {
      documentSnapshot = DocumentSnapshot;
    });
    bool individualFavoritePosition = stopwatch.isRunning ? true : false;

    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        children: <Widget>[
          new NeumorphicButton(
            onClick: () {
              if (stopwatch.isRunning) {
                stopwatch.stop();
                methodStandards.timer(stopwatch, documentSnapshot);
                stopwatch.reset();
                setState(() {
                  individualFavoritePosition = false;
                  print("Favorite timer ended: " + doc['documentId']);
                });
              } else {
                setState(() {
                  individualFavoritePosition = true;
                  stopwatch.start();
                });
                print("Favorite timer started: " + doc['documentId']);
              }
            },
            boxShape: NeumorphicBoxShape.circle(),
            style: NeumorphicStyle(
              shape: individualFavoritePosition ? NeumorphicShape.concave : NeumorphicShape.flat,
              depth: individualFavoritePosition ? -15.0 : 8.0,
              lightSource: LightSource.topLeft,
              color: dataLists.getColorData(1, themes.checkDarkTheme(context), true),
              intensity: individualFavoritePosition ? 1.0 : null,
            ),
            child: interfaceStandards.parentCenter(context, 
              dataLists.getIconData(documentSnapshot['icon']),
            ),
          ),
          Text(
            documentSnapshot["title"],
            style: TextStyle(
              color: Theme.of(context).splashColor,
            ),
          ),
        ],
      ),
    );
  }

  //USER INTERFACE: GOAL CARD STREAM BUILDER
  Widget showGoalCardStreamBuilder() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.28,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: widget.streamSnapshot,
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data.documents.isEmpty) {
              return interfaceStandards.parentCenter(context, 
                Column(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.175,
                      width: MediaQuery.of(context).size.height * 0.175,
                      decoration: BoxDecoration(
                        color: Theme.of(context).hoverColor,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: interfaceStandards.parentCenter(context, 
                        Icon(
                          Icons.equalizer,
                          size: MediaQuery.of(context).size.height * 0.125,
                          color: Theme.of(context).canvasColor,
                        ),
                      )
                    ),
                    SizedBox(
                      height: 9.0,
                    ),
                    Text(
                      "No Goals Yet",
                      style: TextStyle(
                        color: Theme.of(context).textSelectionColor,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Text(
                      "Start goals to knock 'em out!",
                      style: TextStyle(
                        color: Theme.of(context).textSelectionHandleColor,
                        fontSize: 12.5,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return new ListView(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.1,
                  right: MediaQuery.of(context).size.width * 0.1,
                ),
                scrollDirection: Axis.horizontal,
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return buildGoalCard(document);
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }

  //USER INTERFACE: GOAL CARD
  Widget buildGoalCard(DocumentSnapshot document) {
    return new Padding(
      padding: EdgeInsets.only(left: 10, right: 10, bottom: 50.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context, 
            MaterialPageRoute(builder: (context) => UserGoal(
              auth: widget.auth, 
              logoutCallback: widget.logoutCallback, 
              userId: widget.userId, 
              documentSnapshot: document,
            )
          ));
        },
        onLongPress: () {
          cloudFirestore.deleteData(document);
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.01,
          width: MediaQuery.of(context).size.width * 0.32,
          decoration: BoxDecoration(
            gradient: interfaceStandards.cardLinearGradient(context, document),
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(62.0),
              topLeft: Radius.circular(15.0),
              bottomRight: Radius.circular(15.0),
              bottomLeft: Radius.circular(15.0), 
            ),
            boxShadow: [new BoxShadow(
              color: themes.checkDarkTheme(context) ? Colors.grey.shade900 : Colors.grey.shade400,
              blurRadius: 15,
              offset: new Offset(7.5, 7.5)
            )]
          ),
          child: buildGoalCardStack(document),
        )
      ),
    );
  }

  //USER INTERFACE: BUILD GOAL CARD STACK
  Stack buildGoalCardStack(DocumentSnapshot document) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: MediaQuery.of(context).size.height * 0.1,
          left: MediaQuery.of(context).size.width * 0.1,
          child: Text(
            document['title'],
            style: TextStyle(
              color: Theme.of(context).secondaryHeaderColor,
              fontSize: 20.0,
            ),
          ),
        ), //Title
        Positioned(
          top: MediaQuery.of(context).size.height * 0.13,
          left: MediaQuery.of(context).size.width * 0.12,
          child: dataLists.getIconData(document['icon']),
        ), //Icon
      ],
    );
  }

  //USER INTERFACE: HOME SCREEN
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: themes.checkDarkTheme(context) ? Colors.grey.shade700 : Colors.blue));
    return new Scaffold(
      body: SafeArea(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
              gradient: interfaceStandards.bodyLinearGradient(context, false, false)
          ),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height * 0.025,
                left: MediaQuery.of(context).size.width * 0.05,
                child: showTitle(),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.019,
                left: MediaQuery.of(context).size.width * 0.825,
                child: showUserButton(),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.075,
                child: lineChart(),
              ),
              Positioned(
                top: MediaQuery.of(context).size.height * 0.375,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dialogBackgroundColor,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50.0),
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      showSectionText(true),
                      showFavoriteCardStreamBuilder(),
                      showSectionText(false),
                      showGoalCardStreamBuilder(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BubbleBottomBar(
        opacity: .2,
        currentIndex: currentIndex,
        fabLocation: BubbleBottomBarFabLocation.end,
        onTap: changePage,
        hasNotch: true,
        borderRadius: BorderRadius.circular(100.0),
        elevation: 8.0,
        backgroundColor: Theme.of(context).dividerColor,
        items: <BubbleBottomBarItem>[
          BubbleBottomBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.dashboard,
                color: Colors.grey.shade200,
              ),
              activeIcon: Icon(
                Icons.dashboard,
                color: Colors.white,
              ),
              title: Text("Home")),
          BubbleBottomBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.access_time,
                color: Colors.grey.shade200,
              ),
              activeIcon: Icon(
                Icons.access_time,
                color: Colors.white,
              ),
              title: Text("Logs")),
          BubbleBottomBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.folder_open,
                color: Colors.grey.shade200,
              ),
              activeIcon: Icon(
                Icons.folder_open,
                color: Colors.white,
              ),
              title: Text("Folders")),
        ],
      ),
      floatingActionButton: animationStandards.showContainerTransitionAnimation(
        context, 
        1, 
        widget.auth, 
        widget.logoutCallback, 
        widget.userId, 
        null, 
        null
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}