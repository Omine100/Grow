import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:grow/services/cloudFirestore.dart';

class MethodStandards {
  //VARIABLE DECLARATION
  CloudFirestore cloudFirestore = new CloudFirestore();

  //MECHANICS: TIMER
  void timer(Stopwatch stopwatch, DocumentSnapshot documentSnapshot) {
    int currentTotal = (stopwatch.elapsedMilliseconds / 1000).toInt();
    print("Seconds: " + (currentTotal).toString());

    DateTime now  = new DateTime.now();
    DateTime currentDate = new DateTime(now.year, now.month, now.day);
    cloudFirestore.updateTimeData(documentSnapshot, currentTotal, currentDate);
  }
}