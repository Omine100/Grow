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
    String uid = user.uid;

    DocumentSnapshot snapshot = await db.collection(uid).document(id).get();
    print(snapshot.data["name"]);
  }

  Future<String> createData(String title) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String uid = user.uid;

    DocumentReference ref = await db.collection(uid).add({"title": title});
    print(ref.documentID);
    return ref.documentID;
  }

  void updateData(DocumentSnapshot doc) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String uid = user.uid;

    await db.collection(uid).document(doc.documentID).updateData({"todo": "Test"});
  }

  void deleteData(DocumentSnapshot doc) async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String uid = user.uid;

    await db.collection(uid).document(doc.documentID).delete();
  }
}

CloudFirestore db = CloudFirestore();