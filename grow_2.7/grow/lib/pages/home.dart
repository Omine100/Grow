import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/services.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/cloudFirestore.dart';
import 'package:grow/services/themes.dart';
import 'package:grow/widgets/interfaceStandards.dart';
import 'package:grow/models/dataLists.dart';
import 'package:grow/pages/profile.dart';
import 'package:grow/pages/userGoal.dart';
import 'package:grow/pages/addGoal.dart';

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
  CloudFirestore cloudFirestore = new CloudFirestore();
  InterfaceStandards interfaceStandards = new InterfaceStandards();
  Themes themes = new Themes();
  DataLists dataLists = new DataLists();
  final db = Firestore.instance;
  int currentIndex;

  //VARIABLE INITIALIZATION: BOTTOM NAVIGATION BAR
  @override
  void initState() {
    super.initState();
    currentIndex = 0;
  }

  //MECHANICS: BOTTOM NAVIGATION BAR CHANGE PAGE
  void changePage(int index) {
    setState(() {
      currentIndex = index;});
  }

  //USER INTERFACE: SHOW TITLE
  Container showTitle() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.075,
      color: Colors.transparent,
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(
                left: MediaQuery.of(context).size.width * 0.05,
                top: MediaQuery.of(context).size.height * 0.025
            ),
            child: Text(
              "Hi, Matthew",
              style: TextStyle(
                color: Colors.white,
                fontSize: 35.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).size.height * 0.013,
              left: MediaQuery.of(context).size.width * 0.3,
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen(
                  auth: widget.auth, logoutCallback: widget.logoutCallback, userId: widget.userId,
                )));
              },
              child: Icon(
                Icons.person,
                size: 50.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
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
    return Padding(
      padding: EdgeInsets.only(
        top: isFavorite ? MediaQuery.of(context).size.height * 0.03 : 0,
        left: MediaQuery.of(context).size.width * 0.05,
        right: MediaQuery.of(context).size.width * 0.05,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            isFavorite ? "Favorites" : "Goals",
            style: TextStyle(
                color: Theme.of(context).textSelectionColor,
                fontSize: 22.5,
                fontWeight: FontWeight.w500
            ),
          ),
          SizedBox(
            width: isFavorite ? MediaQuery.of(context).size.width * 0.45 : MediaQuery.of(context).size.width * 0.53,
          ),
          Text(
            "Details",
            style: TextStyle(
                color: Theme.of(context).textSelectionHandleColor,
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
    );
  }

  //USER INTERFACE: FAVORITE CARD STREAM BUILDER
  Widget showFavoriteCardStreamBuilder() {
    return Padding(
      padding: EdgeInsets.only(
        left: MediaQuery.of(context).size.width * 0.1,
        right: MediaQuery.of(context).size.width * 0.1,
        top: MediaQuery.of(context).size.height * 0.01,
        bottom: MediaQuery.of(context).size.height * 0.01
      ),
      child: buildFavoriteCard(),
    );
  }

  //USER INTERFACE: FAVORITE CARD
  Widget buildFavoriteCard() {
    return new GestureDetector(
      onTap: () {
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade800,
          borderRadius: BorderRadius.circular(25),
        ),
        height: 55,
        width: 55,
        child: Icon(
          Icons.border_color,
          size: 25.0,
          color: Colors.white,
        ),
      ),
    );
  }

  //USER INTERFACE: GOAL CARD STREAM BUILDER
  Widget showGoalCardStreamBuilder() {
    return Padding(
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.02),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.30,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder(
          stream: db.collection(widget.userId).snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.data.documents.isEmpty) {
              return Container();
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
      padding: EdgeInsets.only(left: 7.5, right: 7.5, bottom: 50.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UserGoal(
                auth: widget.auth,
                logoutCallback: widget.logoutCallback,
                userId: widget.userId,
                documentSnapshot: document,
              ))
          );
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
                  bottomLeft: Radius.circular(15.0)
              ),
              boxShadow: [new BoxShadow(
                color: themes.checkDarkTheme(context) ? Colors.grey.shade900 : Colors.grey.shade400,
                offset: new Offset(7.5, 7.5),
                blurRadius: 15.0,
              ),]
          ),
          child: Stack(
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
          ),
        ),
      ),
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
              showTitle(),
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
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddGoalScreen(
              auth: widget.auth,
              logoutCallback: widget.logoutCallback,
              userId: widget.userId,
            ))
          );
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