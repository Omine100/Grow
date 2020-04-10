import 'package:flutter/material.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/provider.dart';

import 'package:grow/pages/sign_in.dart';

class UserScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => UserScreenState();
}

class UserScreenState extends State<UserScreen> {
  AuthService auth;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Material(
        child: IconButton(
            icon: Icon(
              Icons.lock_outline,
              size: 48.0,
            ),
            color: Colors.red.shade300,
            onPressed: () async {
              try {
                AuthService auth = Provider.of(context).auth;
                Navigator.pushNamed(context, '/home');
                await auth.signOut();
                print("Signed out");
              } catch (e) {
                print (e);
              }
            }
        ),
      ),
    );
  }
}