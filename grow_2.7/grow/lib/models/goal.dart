import 'package:flutter/foundation.dart';

class Goal {
  Goal({
    @required this.title,
    @required this.userId,
    @required this.color,
    @required this.icon,
    @required this.goalTotal,
    @required this.total,
    @required this.datesCompleted,
  });

  //VARIABLE REFERENCE: NEEDED TO LOAD GOAL MODEL
  final String title;
  final String userId;
  final String color;
  final String icon;
  final int goalTotal;
  final int total;
  final Map datesCompleted;

  //MECHANICS: GOAL TO MAP
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "userId": userId,
      "color": color,
      "icon": icon,
      "goalTotal": goalTotal,
      "total": total,
      "datesCompleted": datesCompleted,
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
      goalTotal: map['goalTotal'],
      total: map['total'],
      datesCompleted: map['datesCompleted'],
    );
  }
}