import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:grow/services/authentication.dart';

import 'package:grow/widgets/neumorphicContainer.dart';

import 'package:grow/pages/intro.dart';
import 'package:grow/pages/signup.dart';
import 'package:grow/pages/forgotPassword.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({this.auth, this.loginCallback});

  final BaseAuth auth;
  final VoidCallback loginCallback;

  @override
  State<StatefulWidget> createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final formKey = GlobalKey<FormState>();

  String _email;
  String _password;
  String _errorMessage;

  bool _isLoading;

  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    super.initState();
  }

  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void validateAndSubmit() async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });

    if (validateAndSave()) {
      String userId = "";
      
      try {
        userId = await widget.auth.signIn(_email, _password);
        print("Signed in: $userId");

        setState(() {
          _isLoading = false;
        });

        if (userId.length > 0 && userId != null) {
          widget.loginCallback();
        }
      } catch (e) {
        print("Error: $e");
        setState(() {
          _isLoading = false;
          _errorMessage = e;
          formKey.currentState.reset();
        });
      }
    }
  }

  void resetForm() {
    formKey.currentState.reset();
    _errorMessage = "";
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: Container(
        child: SafeArea( 
          child: Stack(
            children: <Widget>[
              Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 350.0),
                      child: showEmailInput(context, _email),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
                      child: showPasswordInput(context, _password),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 5,
                top: MediaQuery.of(context).size.height * 0.63,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => IntroScreen())
                    );
                  },
                  child: showLoginButton()
                ),
              ),
              Positioned(
                right: MediaQuery.of(context).size.width / 5,
                top: MediaQuery.of(context).size.height * 0.63,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => SignupScreen())
                    );
                  },
                  child: showSignupButton()
                ),
              ),
              Positioned(
                left: MediaQuery.of(context).size.width / 2.80,
                top: MediaQuery.of(context).size.height * 0.73,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ForgotPasswordScreen())
                    );
                  },
                  child: showForgotPasswordButton()
                ),
              ),
              showProgress(_isLoading)
            ],
          ),
        ),
      ),
    );
  }
}

Widget showLogo() {
  return Container(
    child: Text(
      "Testing",
    ),
  );
}

Widget showLoginButton() {
  return new NeumorphicContainer(
    child: Padding(
      padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 15.0, bottom: 15.0),
      child: Text(
        "Login",
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
      ),
    )
  );
}

Widget showSignupButton() {
  return new NeumorphicContainer(
    child: Padding(
      padding: EdgeInsets.only(left: 24.0, right: 24.0, top: 15.0, bottom: 15.0),
      child: Text(
        "Signup",
        style: TextStyle(
          color: Colors.grey.shade700,
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
      ),
    )
  );
}

Widget showForgotPasswordButton() {
  return new GestureDetector(
    child: Text(
      "Forgot Password?",
      style: TextStyle(
        color: Colors.grey.shade700,
        fontWeight: FontWeight.w400,
        fontSize: 15.0
      ),
    ),
  );
}

Widget showEmailInput(BuildContext context, String _email) {
  return new TextFormField(
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(
      color: Theme.of(context).dialogBackgroundColor,
      fontSize: 22.0
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.email,
        color: Theme.of(context).dialogBackgroundColor,
      ),
      hintText: "Email",
      labelStyle: TextStyle(
        color: Theme.of(context).dialogBackgroundColor,
      ),
      hintStyle: TextStyle(
        color: Theme.of(context).dialogBackgroundColor,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).dialogBackgroundColor,
        ),
      ),
    ),
    validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
    onSaved: (value) => _email = value.trim(),
    maxLines: 1,
    maxLength: 25,
  );
}

Widget showPasswordInput(BuildContext context, String _password) {
  return new TextFormField(
    keyboardType: TextInputType.text,
    style: TextStyle(
      color: Theme.of(context).dialogBackgroundColor,
      fontSize: 22.0
    ),
    decoration: InputDecoration(
      prefixIcon: Icon(
        Icons.lock,
        color: Theme.of(context).dialogBackgroundColor,
      ),
      hintText: "Password",
      labelStyle: TextStyle(
        color: Theme.of(context).dialogBackgroundColor,
      ),
      hintStyle: TextStyle(
        color: Theme.of(context).dialogBackgroundColor,
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Theme.of(context).dialogBackgroundColor,
        ),
      ),
    ),
    validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
    onSaved: (value) => _password = value.trim(),
    obscureText: true,
  );
}

Widget showErrorMessage(String _errorMessage) {
    if (_errorMessage.length > 0 && _errorMessage != null) {
      return new Text(
        _errorMessage,
        style: TextStyle(
            fontSize: 13.0,
            color: Colors.red,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

Widget showProgress(bool _isLoading) {
  if (_isLoading) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
  return Container(
    height: 0.0,
    width: 0.0,
  );
}