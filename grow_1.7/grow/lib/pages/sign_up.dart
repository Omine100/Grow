import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/services/provider.dart';

import 'package:grow/pages/sign_in.dart';

class SignUpScreen extends StatefulWidget {
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning;

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.green.shade300,
      body: Container(
        height: _height,
        width: _width,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: _height * 0.1),
                showAlert(),
                SizedBox(height: _height * 0.05),
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
        await auth.createUserWithEmailAndPassword(_email, _password, _name);
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
        color: Colors.amberAccent,
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
        validator: NameValidator.validate,
        keyboardType: TextInputType.text,
        style: TextStyle(
          fontSize: 22.0,
          color: Colors.white,
        ),
        decoration: buildSignUpInputDecoration("Name"),
        onSaved: (value) => _name = value,
      ),
    );
    textFields.add(
        SizedBox(
          height: 20.0,
        )
    );
    textFields.add(
      TextFormField(
        validator: EmailValidator.validate,
        keyboardType: TextInputType.emailAddress,
        style: TextStyle(
          fontSize: 22.0,
          color: Colors.white,
        ),
        decoration: buildSignUpInputDecoration("Email"),
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
        obscureText: true,
        style: TextStyle(
          fontSize: 22.0,
          color: Colors.white,
        ),
        decoration: buildSignUpInputDecoration("Password"),
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

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 5.0),
        child: Icon(
          Icons.email,
          color: Colors.white,
        ),
      ),
      focusColor: Colors.white,
      hoverColor: Colors.white,
      hintText: hint,
      filled: false,
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
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w300
                  ),
                ),
              ),
              onPressed: submit,
            ),
          ),
          buildSocialIcons(true),
          FlatButton(
            child: RichText(
              text: TextSpan(
                text: "Have an Account?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: " Sign In",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      ),
                    )
                  ] 
                ),
              ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ],
      )
    ];
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: <Widget>[
          SizedBox(height: 10),
          GoogleSignInButton(
            onPressed: () async {
              try {
                await _auth.convertWithGoogle();
                Navigator.of(context).pop();
              } catch (e) {
                setState(() {
                  print(e);
                  _warning = e.message;
                });
              }
            },
          ),
          SizedBox(height: 10),
          Divider(
            color: Colors.white,
          ),
        ],
      ),
      visible: visible,
    );
  }
}