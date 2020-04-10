import 'package:flutter/foundation.dart';

class Goal {
  Goal({
    @required this.title,
    @required this.userId,
    @required this.color,
    @required this.icon,
    @required this.timeDay,
    @required this.timeTotal,
  });

  //VARIABLE REFERENCE: NEEDED TO LOAD GOAL MODEL
  final String title;
  final String userId;
  final String color;
  final String icon;
  final String timeDay;
  final String timeTotal;

  //MECHANICS: GOAL TO MAP
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "userId": userId,
      "color": color,
      "icon": icon,
      "timeDay": timeDay,
      "timeTotal": timeTotal,
    };
  }

  //MECHANICS: MAP TO GOAL
  static Goal fromMap(Map<String, dynamic> map) {
    if(map == null) return null;

    return Goal(
      title: map["title"],
      userId: map["userId"],
      color: map["color"],
      icon: map["icon"],
      timeDay: map["timeDay"],
      timeTotal: map["timeTotal"],
    );
  }
}