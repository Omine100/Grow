import 'package:firebase_database/firebase_database.dart';

class Plant {
  Plant(this.userId, this.name, this.type, this.birthDate);

  //VARIABLE REFERENCE: NEEDED TO LOAD PLANT MODEL (key is automatically applied in RTDB)
  String key;
  String userId;
  String name;
  String type;
  String birthDate;

  //MECHANICS: PLANT PROPERTY EVALUATION
  Plant.fromSnapshot(DataSnapshot snapshot) :
    key = snapshot.key,
    userId = snapshot.value["userId"],
    name = snapshot.value["name"],
    type = snapshot.value["type"],
    birthDate = snapshot.value["birthDate"];

    //JSON: MODEL CONFIGURATION IN JSON
    toJson() {
      return {
        "userId": userId,
        "name": name,
        "type": type,
        "birthDate": birthDate,
      };
    }
}