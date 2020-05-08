import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CloudFirestore {
  final db = Firestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<QuerySnapshot> init() {
    return db.collection("goals").snapshots();
  }

  void readData(String id) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    DocumentSnapshot snapshot = await db.collection(user.uid.toString()).document(id).get();
    print("Read: " + snapshot.data["name"]);
  }

  Future<String> createData(String title, int iconPosition, int colorPosition, int goalTotal) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    Map datesCompleted = {};
    DocumentReference ref = await db.collection(user.uid.toString()).add({
      "title": title,
      "icon": iconPosition,
      "color": colorPosition,
      "goalTotal": goalTotal,
      "total": 0,
      "datesCompleted": datesCompleted,
    });
    print("Created: " + ref.documentID);
    return ref.documentID;
  }

  Future<String> createFavoriteData() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    db.collection(user.uid.toString()).document("Favorites").collection("Goals");
    print("Favorite data created");
  }

  Future<String> updateFavoriteData(DocumentSnapshot doc) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    db.collection(user.uid.toString()).document("Favorites").collection("Goals").add(
        {"documentID": doc.documentID});
  }

  void updateTimeData(DocumentSnapshot doc, int currentTotal, DateTime currentDate) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    Map datesCompleted = doc.data["datesCompleted"];
    if (datesCompleted[currentDate.toString()] != null) {
      int previous = datesCompleted[currentDate.toString()];
      datesCompleted[currentDate.toString()] = currentTotal + previous;
    } else {
      datesCompleted[currentDate.toString()] = currentTotal;
    }

    await db.collection(user.uid.toString()).document(doc.documentID).updateData({
      "datesCompleted": datesCompleted,
      "total": currentTotal + doc.data["total"],
    });
    print(datesCompleted);
  }

  void deleteData(DocumentSnapshot doc) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    await db.collection(user.uid.toString()).document(doc.documentID).delete();
    print("Deleted: " + doc.documentID);
  }

  void deleteAccountData(String userId) async {
    await db.collection(userId).getDocuments().then((snapshot) {
      for (DocumentSnapshot ds in snapshot.documents){
        ds.reference.delete();
      }
    });
  }
}

CloudFirestore db = CloudFirestore();