import 'package:flutter/foundation.dart';

class Goal {
  Goal({
    @required this.title,
    @required this.userId,
    @required this.color,
    @required this.icon,
    @required this.goalHours,
    @required this.goalMinutes,
    @required this.goalSeconds,
    @required this.currentHours,
    @required this.currentMinutes,
    @required this.currentSeconds,
  });

  //VARIABLE REFERENCE: NEEDED TO LOAD GOAL MODEL
  final String title;
  final String userId;
  final String color;
  final String icon;
  final int goalHours;
  final int goalMinutes;
  final int goalSeconds;
  final int currentHours;
  final int currentMinutes;
  final int currentSeconds;

  //MECHANICS: GOAL TO MAP
  Map<String, dynamic> toMap() {
    return {
      "title": title,
      "userId": userId,
      "color": color,
      "icon": icon,
      "goalHours": goalHours,
      "goalMinutes": goalMinutes,
      "goalSeconds": goalSeconds,
      "currentHours": currentHours,
      "currentMinutes": currentMinutes,
      "currentSeconds": currentSeconds,
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
      goalHours: map['goalHours'],
      goalMinutes: map['goalMinutes'],
      goalSeconds: map['goalSeconds'],
      currentHours: map['currentHours'],
      currentMinutes: map['currentMinutes'],
      currentSeconds: map['currentSeconds'],
    );
  }
}