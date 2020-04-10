import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/provider.dart';

import 'package:grow/pages/home.dart';
import 'package:grow/pages/navigation.dart';
import 'package:grow/pages/sign_in.dart';
import 'package:grow/pages/sign_up.dart';
import 'package:grow/pages/forgot_password.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return Provider(
      auth: AuthService(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Grow',
        theme: ThemeData(
          primaryColor: Colors.green.shade300,
          cursorColor: Colors.green.shade300,
          accentColor: Colors.green,
          accentColorBrightness: Brightness.light,
        ),
        home: HomeController(),
        routes: <String, WidgetBuilder>{
          '/home': (BuildContext context) => HomeController(),
          '/signin': (context) => SignInScreen(),
          '/signup': (context) => SignUpScreen(),
          '/forgot-password': (context) => ForgotPasswordScreen(),
        },
      ),
    );
  }
}

class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final AuthService auth = Provider.of(context).auth;
    return StreamBuilder<String>(
      stream: auth.onAuthStateChanged,
      builder: (context, AsyncSnapshot<String> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final bool signedIn = snapshot.hasData;
          return signedIn ? NavigationScreen() : SignInScreen();
        }
        return CircularProgressIndicator();
      },
    );
  }
}