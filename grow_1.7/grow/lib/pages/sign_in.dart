import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/provider.dart';

import 'package:grow/pages/sign_up.dart';
import 'package:grow/pages/forgot_password.dart';

class SignInScreen extends StatefulWidget {
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final formKey = GlobalKey<FormState>();
  String _email, _password, _warning;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark.copyWith(
      statusBarColor: Colors.green.shade600,
    ));

    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        color: Colors.white,
        height: _height,
        width: _width,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomRight: Radius.circular(100),
                    ),
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade500,
                        Colors.green.shade200,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  height: MediaQuery.of(context).size.height / 2.3,
                  width: MediaQuery.of(context).size.width,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.height / 40,
                      bottom: MediaQuery.of(context).size.height / 40,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        "Grow",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 85,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                        textDirection: TextDirection.ltr,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: _height * 0.02),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: buildInputs() + buildButtons(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  bool validate() {
    final form = formKey.currentState;
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;
        await auth.signInWithEmailAndPassword(_email, _password);
        Navigator.of(context).pushReplacementNamed('/home');
      } catch (e) {
        print(e);
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.green.shade300,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: Text(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(
      height: 0,
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textFields = [];

    textFields.add(
      TextFormField(
        validator: EmailValidator.validate,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: 22.0,
          color: Colors.green,
        ),
        decoration: buildSignInInputDecoration("Email"),
        onSaved: (value) => _email = value,
      ),
    );
    textFields.add(
        SizedBox(
          height: 20.0,
        )
    );
    textFields.add(
      TextFormField(
        validator: PasswordValidator.validate,
        style: TextStyle(
          fontSize: 22.0,
          color: Colors.green,
        ),
        obscureText: true,
        decoration: buildSignInInputDecoration("Password"),
        onSaved: (value) => _password = value,
      ),
    );
    textFields.add(
      SizedBox(
        height: 20
      )
    );

    return textFields;
  }

  InputDecoration buildSignInInputDecoration(String hint) {
    return InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 5.0),
        child: Icon(
          Icons.email,
          color: Colors.green.shade300,
        ),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(32.0),
      ),
      hintText: hint,
      filled: true,
      fillColor: Colors.white,
      contentPadding:
      const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0),
    );
  }

  List<Widget> buildButtons() {
    return [
      Column(
        children: <Widget>[
          Container (
            width: MediaQuery.of(context).size.width * 0.7,
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
              color: Colors.white,
              textColor: Colors.green.shade300,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
              onPressed: submit,
            ),
          ),
          showForgotPassword(true),
          buildSocialIcons(true),
          buildSignUp(true),
        ],
      )
    ];
  }

  Widget buildSignUp(bool visible) {
    return Visibility(
      child: FlatButton(
        child: RichText(
          text: TextSpan(
              text: "Don't have an account?",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 15.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: " Sign Up.",
                  style: TextStyle(
                    color: Colors.green.shade300,
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ]
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SignUpScreen()),
          );
        },
      ),
      visible: visible,
    );
  }

  Widget showForgotPassword(bool visible) {
    return Visibility(
      child: FlatButton(
        child: RichText(
          text: TextSpan(
              text: "Forgot your password?",
              style: TextStyle(
                color: Colors.black54,
                fontSize: 13.0,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: " Help me.",
                  style: TextStyle(
                    color: Colors.green.shade300,
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                  ),
                )
              ]
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ForgotPasswordScreen()),
          );
        },
      ),
      visible: visible,
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: <Widget>[
          GoogleSignInButton(
            onPressed: () async {
              try {
                await _auth.convertWithGoogle();
                Navigator.of(context).pushReplacementNamed('/home');
              } catch (e) {
                setState(() {
                  print(e);
                  _warning = e.message;
                });
              }
            },
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              horizontalLine(context),
              Text(
                "OR",
                style: TextStyle(
                  color: Colors.green.shade300,
                  fontSize: 18.0,
                ),
              ),
              horizontalLine(context),
            ],
          ),
        ],
      ),
      visible: visible,
    );
  }
}

Widget horizontalLine(BuildContext context) {
  return new Padding(
    padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Container(
      width: MediaQuery.of(context).size.width / 3,
      height: 1.0,
      color: Colors.green.shade300,
    ),
  );
}