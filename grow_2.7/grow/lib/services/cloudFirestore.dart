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

  Future<String> createData(String title, int iconPosition, int colorPosition) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    DocumentReference ref = await db.collection(user.uid.toString()).add({
      "title": title,
      "icon": iconPosition,
      "color": colorPosition,
    });
    print("Created: " + ref.documentID);
    return ref.documentID;
  }

  void updateData(DocumentSnapshot doc) async {
    FirebaseUser user = await _firebaseAuth.currentUser();

    await db.collection(user.uid.toString()).document(doc.documentID).updateData({"todo": "Test"});
    print("Updated: " + doc.documentID);
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