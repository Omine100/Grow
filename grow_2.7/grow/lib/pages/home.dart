import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:bubble_bottom_bar/bubble_bottom_bar.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/cloudFirestore.dart';
import 'package:grow/services/themes.dart';
import 'package:grow/widgets/interfaceStandards.dart';
import 'package:grow/widgets/neumorphicContainer.dart';
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
      currentIndex = index;
    });
  }

  //USER INTERFACE: SHOW TITLE
  Widget showTitle() {
    return new Container(
      decoration: BoxDecoration(
        gradient: interfaceStandards.bodyLinearGradient(context, false, true),
        borderRadius: BorderRadius.circular(50.0),
        boxShadow: [new BoxShadow(
          color: themes.checkDarkTheme(context) ? Colors.grey.shade900 : Colors.grey.shade400,
          offset: new Offset(7.5, 7.5),
          blurRadius: 15.0,
        ),]
      ),
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.width * 0.7,

      child: Padding(
        padding: EdgeInsets.only(left: 52.0, top: 12.0),
        child: Text(
          "Hi, " + "Matthew",
          style: TextStyle(
            color: Theme.of(context).splashColor,
            fontSize: 40.0,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  //USER INTERFACE: PROGRESS CARD CONTAINER
  Widget showProgressCardContainer() {
    return Padding(
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
        padding: 0.0,
        color: Theme.of(context).dialogBackgroundColor,
        child: Padding(
          padding: EdgeInsets.only(left: 5.0, right: 15.0, top: 15.0, bottom: 5.0),
          child: lineChart(),
        ),
      ),
    );
  }

  //USER INTERFACE: PROGRESS CARD - LINE CHART
  LineChart lineChart() {
    return LineChart(getLineChartData());
  }

  //MECHANICS: GET LINE CHART DATA
  LineChartData getLineChartData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: Colors.blue,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: Colors.blue,
            strokeWidth: 1,
          );
        }
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: SideTitles(
          showTitles: true,
          reservedSize: 22,
          textStyle:
          const TextStyle(color: Color(0xff68737d), fontWeight: FontWeight.bold, fontSize: 16),
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
          showTitles: true,
          textStyle: const TextStyle(
            color: Color(0xff67727d),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
          getTitles: (value) {
            switch (value.toInt()) {
              case 1:
                return '10k';
              case 3:
                return '30k';
              case 5:
                return '50k';
            }
            return '';
          },
          reservedSize: 28,
          margin: 12,
        ),
      ),
      borderData:
      FlBorderData(show: true, border: Border.all(color: const Color(0xff37434d), width: 1)),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          colors: interfaceStandards.colorsBodyGradient(context, false),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            colors: interfaceStandards.colorsBodyGradient(context, false).map((color) => color.withOpacity(0.3)).toList(),
          ),
        ),
      ],
    );
  }

  //USER INTERFACE: GOAL CARD CONTAINER
  Widget showGoalCardContainer() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.285,
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
              return buildGoalCard(document);
            }).toList(),
          );
        },
      ),
    );
  }

  //USER INTERFACE: GOAL CARD
  Widget buildGoalCard(DocumentSnapshot document) {
    return new Padding(
      padding: EdgeInsets.only(left: 7.5, right: 7.5, top: 5.0, bottom: 25.0),
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
          height: MediaQuery.of(context).size.height,
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
    return new Scaffold(
      backgroundColor: Theme.of(context).dialogBackgroundColor,
      body: SafeArea(
        child: Container(
          child: Stack(
            children: <Widget>[
              Positioned(
                top: MediaQuery.of(context).size.height * 0.04,
                right: MediaQuery.of(context).size.width * 0.4,
                child: showTitle(),
              ), //showTitle()
              Positioned(
                top: MediaQuery.of(context).size.height * 0.02,
                left: MediaQuery.of(context).size.width * 0.775,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProfileScreen(
                          auth: widget.auth,
                          logoutCallback: widget.logoutCallback,
                          userId: widget.userId,
                        ))
                    );
                  },
                  child: showUserButton(context),
                ),
              ), //showUserButton()
              Positioned(
                top: MediaQuery.of(context).size.height * 0.155,
                left: MediaQuery.of(context).size.width * 0.05,
                child: showSectionText(context, true),
              ), //Progress text
              Positioned(
                top: MediaQuery.of(context).size.height * 0.1875,
                left: MediaQuery.of(context).size.width * 0.05,
                child: showProgressCardContainer(),
              ), //Progress box
              Positioned(
                top: MediaQuery.of(context).size.height * 0.515,
                left: MediaQuery.of(context).size.width * 0.05,
                child: showSectionText(context, false),
              ), //Goals text
              Positioned(
                top: MediaQuery.of(context).size.height * 0.5625,
                left: MediaQuery.of(context).size.width * -0.01,
                right: MediaQuery.of(context).size.width * -0.01,
                child: showGoalCardContainer(),
              ), //Goals boxes
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
          BubbleBottomBarItem(
              backgroundColor: Colors.white,
              icon: Icon(
                Icons.menu,
                color: Colors.grey.shade200,
              ),
              activeIcon: Icon(
                Icons.menu,
                color: Colors.white,
              ),
              title: Text("Menu"))
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

//USER INTERFACE: SHOW SECTION TEXT
Widget showSectionText(BuildContext context, bool isProgress) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.end,
    children: <Widget>[
      Text(
        isProgress ? "Progress" : "Goals",
        style: TextStyle(
            color: Theme.of(context).textSelectionColor,
            fontSize: 22.5,
            fontWeight: FontWeight.w500
        ),
      ),
      SizedBox(
        width: MediaQuery.of(context).size.width * 0.45,
      ),
      Text(
        isProgress ? "Details" : "Customize",
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
        size: 50.0,
        color: Colors.white,
      ),
    ),
  );
}