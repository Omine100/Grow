import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:grow/services/cloudFirestore.dart';

//METHOD DECLARATION: AUTHENTICATION PROCESSES
abstract class BaseAuth {
  Future<String> signIn(String email, String password);
  Future<String> signUp(String email, String password, String name);
  Future<FirebaseUser> getCurrentUser();
  Future<String> getCurrentUserId();
  Future<void> sendEmailVerification();
  Future<void> signOut();
  Future<bool> isEmailVerified();
  Future<void> sendPasswordReset(String email);
  Future<void> deleteAccount();
}

class Auth implements BaseAuth {
  //VARIABLE INITIALIZATION: FIREBASE AND FIRESTORE AUTHENTICATION
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final CloudFirestore cloudFirestore = new CloudFirestore();

  //MECHANICS: SIGNS IN USER WITH GIVEN EMAIL AND PASSWORD
  Future<String> signIn(String email, String password) async {
    AuthResult result = await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
    return user.uid;
  }

  //MECHANICS: SIGNS UP USER WITH GIVEN EMAIL AND PASSWORD
  Future<String> signUp(String email, String password, String name) async {
    AuthResult result = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    FirebaseUser user = result.user;
//    cloudFirestore.createUserData(user.uid, name);
    return user.uid;
  }

  //MECHANICS: RETURNS CURRENT USER
  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user;
  }

  //MECHANICS: RETURNS CURRENT USER ID
  Future<String> getCurrentUserId() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    String uid = user.uid;
    return uid;
  }

  //MECHANICS: SENDS EMAIL TO VERIFY USER
  Future<void> sendEmailVerification() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    user.sendEmailVerification();
  }

  //MECHANICS: SIGNS OUT USER
  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  //MECHANICS: RETURNS TRUE IF EMAIL IS VERIFIED
  Future<bool> isEmailVerified() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.isEmailVerified;
  }

  Future<void> sendPasswordReset(String email) async {
    _firebaseAuth.sendPasswordResetEmail(email: email);
    print("Password reset email sent to: " + email);
  }

  Future<void> deleteAccount() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.delete();
  }
}