import 'package:flutter/material.dart';

import 'package:grow/services/authentication.dart';
import 'package:grow/pages/forgotPassword.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({this.auth, this.loginCallback, this.signUpCallback});

  //VARIABLE REFERENCE: NEEDED TO LOAD LOGIN SCREEN
  final BaseAuth auth;
  final VoidCallback loginCallback;
  final VoidCallback signUpCallback;

  @override
  State<StatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  //VARIABLE DECLARATION: AUTHENTICATION AND LOADING
  final formKey = GlobalKey<FormState>();
  String _name, _email, _password, _errorMessage;
  bool _isLoading;
  bool _isSignIn;

  //VARIABLE INITIALIZATION: ERROR MESSAGE AND LOADING VALUES
  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
    _isSignIn = true;
    super.initState();
  }

  //MECHANICS: VALIDATE AND SAVE USER INFROMATION
  bool validateAndSave() {
    final form = formKey.currentState;

    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //MECHANICS: VALIDATE AND SUBMIT USER INFORMATION
  void validateAndSubmit(bool isSignIn) async {
    setState(() {
      _errorMessage = "";
      _isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (isSignIn) {
          userId = await widget.auth.signIn(_email, _password);
          setState(() {
            _isLoading = false;
          });
          if (userId.length > 0 && userId != null && isSignIn) {
            widget.loginCallback();
          }
          print("Signed in: $userId");
        } else {
          userId = await widget.auth.signUp(_email, _password, "Matthew");
          setState(() {
            _isLoading = false;
          });
          if (userId.length > 0 && userId != null && isSignIn) {
            widget.signUpCallback();
          }
          widget.auth.sendEmailVerification();
          showVerifyEmailSentDialog(context);
          print("Signed up: $userId");
        }
      } catch (e) {
        print("Error: $e");
        setState(() {
          _isLoading = false;
          _errorMessage = e.message;
          formKey.currentState.reset();
        });
      }
    } else {
      setState(() {
        _errorMessage = "";
        _isLoading = false;
      });
    }
  }

  //MECHANICS: RESET FORM
  void resetForm() {
    formKey.currentState.reset();
    _errorMessage = "";
  }

  //USER INTERFACE: SHOW SIGN IN OR SIGN UP INPUT FIELDS
  Widget showInput(BuildContext context, String text) {
    return new TextFormField(
      keyboardType: text == "Email" ? TextInputType.emailAddress : TextInputType.text,
      style: TextStyle(
        color: Theme.of(context).secondaryHeaderColor,
        fontSize: 22.0,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          text != "Email" ? text == "Password" ?
            Icons.lock :
            Icons.person :
            Icons.email,
          color: Theme.of(context).secondaryHeaderColor,
        ),
        hintText: text,
        hintStyle: TextStyle(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).secondaryHeaderColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).secondaryHeaderColor,
          ),
        ),
      ),
      validator: (value) => value.isEmpty ? "$text can\'t be empty" : null,
      onSaved: (value) => text != "Email" ? text == "Password" ?
        _password = value.trim() :
        _name = value.trim() :
        _email = value.trim(),
      obscureText: text == "Password" ? true : false,
      maxLines: 1,
    );
  }

  //USER INTERFACE: LOGIN SCREEN
  @override
  Widget build(BuildContext context) {
    final Shader linearGradient = LinearGradient(
      colors: <Color>[Theme.of(context).highlightColor, Theme.of(context).backgroundColor],
    ).createShader(Rect.fromLTWH(110.0, 100.0, 200.0, 70.0));

    return new Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            tileMode: TileMode.mirror,
            colors: [
              Theme.of(context).highlightColor,
              Theme.of(context).backgroundColor,
            ]
          ),
        ),
        child: Stack(
          children: <Widget>[
            SingleChildScrollView(
              child: Form(
                key: formKey,
                child: Column(
                  children: <Widget>[
                    Padding (
                      padding: EdgeInsets.only(
                        top: _isSignIn ? MediaQuery.of(context).size.height * 0.2875 : MediaQuery.of(context).size.height * 0.265,
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: Text(
                            _isSignIn ? "Grow" : "Create Account",
                            style: TextStyle(
                              color: Theme.of(context).secondaryHeaderColor,
                              fontSize: _isSignIn ? 65.0 : 40.0,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ), //showTitle()
                    _isSignIn ?
                      Container(
                        height: 0.0,
                        child: null,
                      )
                        :
                      Padding(
                        padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 33.0),
                        child: showInput(context, "Name"),
                      ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, top: _isSignIn ? 26.0 : 20.0),
                      child: showInput(context, "Email"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
                      child: showInput(context, "Password"),
                    ),
                    _isSignIn ?
                      Padding(
                        padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.48, top: 30.0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => ForgotPasswordScreen(
                                  auth: widget.auth,
                                  loginCallback: widget.loginCallback,
                                  signUpCallback: widget.signUpCallback,
                                ))
                            );
                          },
                          child: showForgotPasswordButton(context)
                        ),
                      ) //showForgotPasswordButton(),
                        :
                      Container(
                        height: 0.0,
                        child: null,
                      ), //Show nothing
                    Padding(
                      padding: EdgeInsets.only(top: _isSignIn ? 30.0 : 48.0),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: GestureDetector(
                            onTap: () {
                              validateAndSubmit(_isSignIn);
                            },
                            child: showSignInSignUpButton(context, _isSignIn, linearGradient),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ), //showInput() - Form
            Positioned(
              top: MediaQuery.of(context).size.height * 0.91,
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _errorMessage = "";
                        _isLoading = false;
                        _isSignIn = !_isSignIn;
                      });
                    },
                    child: showSignInSignUpAlternateText(context, _isSignIn),
                  ),
                ),
              ),
            ), //showSignInSignUpAlternateText()
            Positioned(
              top: MediaQuery.of(context).size.height * 0.8,
              left: MediaQuery.of(context).size.width * 0.445,
              child: showProgress(_isLoading),
            ), //showProgress()
          ],
        ),
      ),
    );
  }
}

//USER INTERFACE: SHOW SIGN IN OR SIGN UP BUTTON
Widget showSignInSignUpButton(BuildContext context, bool isSignIn, Shader linearGradient) {
  return new Container(
    height: 50,
    width: MediaQuery.of(context).size.width * 0.375,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(
        30.0
      ),
      color: Colors.white,
    ),
    child: Center(
      child: Text(
        isSignIn ? "LOGIN" : "SIGN UP",
        style: TextStyle(
          foreground: Paint()
            ..shader = linearGradient,
          fontWeight: FontWeight.w600,
          fontSize: 22.5,
        ),
      ),
    ),
  );
}

//USER INTERFACE: SHOW SIGN IN OR SIGN UP ALTERNATE TEXT
Widget showSignInSignUpAlternateText(BuildContext context, bool isSignIn) {
  return RichText(
    text: TextSpan(
      text: !isSignIn ? "Already have an account? " : "Don't have an account? ",
      style: TextStyle(
        color: Theme.of(context).secondaryHeaderColor,
        fontSize: 15.0,
      ),
      children: <TextSpan>[
        TextSpan(
          text: !isSignIn ? "Sign In" : "Sign Up",
          style: TextStyle(
            color: Colors.blue.shade900,
            fontWeight: FontWeight.w600,
            fontSize: 15.0,
          ),
        ),
      ],
    ),
  );
}

//USER INTERFACE: SHOW FORGOT PASSWORD BUTTON
Widget showForgotPasswordButton(BuildContext context) {
  return new Text(
    "Forgot Password?",
    style: TextStyle(
        color: Theme.of(context).secondaryHeaderColor,
        fontWeight: FontWeight.w400,
        fontSize: 15.0
    ),
  );
}

//USER INTERFACE: SHOW ERROR MESSAGE
Widget showErrorMessage(String _errorMessage) {
  if (_errorMessage.length > 0 && _errorMessage != null) {
    return new Text(
      _errorMessage,
      style: TextStyle(
        fontSize: 13.0,
        color: Colors.red,
        height: 1.0,
        fontWeight: FontWeight.w300,
      ),
    );
  } else {
    return new Container(
      height: 0.0,
    );
  }
}

//USER INTERFACE: SHOW PROGRESS
Widget showProgress(bool _isLoading) {
  if (_isLoading) {
    return new Center(
      child: CircularProgressIndicator(
        backgroundColor: Colors.grey.shade700,
      ),
    );
  }
  return Container(
    height: 0.0,
    width: 0.0,
  );
}

//USER INTERFACE: SHOW VERIFY EMAIL SENT DIALOG
void showVerifyEmailSentDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: new Text("Verify your account"),
        content: new Text(
            "Link to verify account has been sent"
        ),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.w600,
        ),
        contentTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 15.0,
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              "Dismiss",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}