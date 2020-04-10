import 'package:flutter/material.dart';

import 'package:grow/services/authentication.dart';

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
  String _email, _password, _errorMessage;
  bool _isLoading;

  //VARIABLE INITIALIZATION: ERROR MESSAGE AND LOADING VALUES
  @override
  void initState() {
    _errorMessage = "";
    _isLoading = false;
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
          userId = await widget.auth.signUp(_email, _password);
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
    }
  }

  //MECHANICS: RESET FORM
  void resetForm() {
    formKey.currentState.reset();
    _errorMessage = "";
  }

  //USER INTERFACE: SHOW SIGN IN OR SIGN UP INPUT FIELDS
  Widget showInput(BuildContext context, bool isEmail) {
    return new TextFormField(
      keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      style: TextStyle(
        color: Theme.of(context).dialogBackgroundColor,
        fontSize: 22.0,
      ),
      decoration: InputDecoration(
        prefixIcon: Icon(
          isEmail ? Icons.email : Icons.lock,
          color: Theme.of(context).dialogBackgroundColor,
        ),
        hintText: isEmail ? "Email" : "Password",
        hintStyle: TextStyle(
          color: Theme.of(context).dialogBackgroundColor,
        ),
        labelStyle: TextStyle(
          color: Theme.of(context).dialogBackgroundColor,
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).dialogBackgroundColor,
          ),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).dialogBackgroundColor,
          ),
        ),
      ),
      validator: (value) => value.isEmpty ? isEmail ? "Email can\'t be empty" : "Passowrd can\'t be empty" : null,
      onSaved: (value) => isEmail ? _email = value.trim() : _password = value.trim(),
      obscureText: isEmail ? false : true,
      maxLines: 1,
      maxLength: isEmail ? null : 15,
    );
  }

  //USER INTERFACE: LOGIN SCREEN
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Theme.of(context).accentColor,
      body: Container(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: <Widget>[
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 340.0),
                        child: showInput(context, true),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 50.0, right: 50.0, top: 20.0),
                        child: showInput(context, false),
                      ),
                    ],
                  ),
                ), //showInput() - Form
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.25),
                    child: showTitle(context),
                  ),
                ), //showTitle()
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.275, top: 540, bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      validateAndSubmit(true);
                    },
                    child: showSignInSignUpButton(context, true),
                  ),
                ), //showSignInSignUpButton() - SignIn
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.525, top: 540, bottom: 20),
                  child: GestureDetector(
                    onTap: () {
                      validateAndSubmit(false);
                    },
                    child: showSignInSignUpButton(context, false),
                  ),
                ), //showSignInSignUpButton() - SignUp
                Padding(
                  padding: EdgeInsets.only(left: MediaQuery.of(context).size.width * 0.35, top: MediaQuery.of(context).size.height * 0.90, bottom: 20),
                  child: GestureDetector(
                      onTap: () {
//                        Navigator.push(
//                            context,
//                            MaterialPageRoute(builder: (context) => ForgotPasswordScreen())
//                        );
                      },
                      child: showForgotPasswordButton(context)
                  ),
                ), //showForgotPasswordButton()
                Positioned(
                  top: MediaQuery.of(context).size.height * 0.8,
                  left: MediaQuery.of(context).size.width * 0.445,

                  child: showProgress(_isLoading),
                ), //showProgress()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

//USER INTERFACE: SHOW LOGO
Widget showTitle(BuildContext context) {
  return new Text(
    "Grow",
    style: TextStyle(
      color: Theme.of(context).scaffoldBackgroundColor,
      fontSize: 65.0,
      fontWeight: FontWeight.w600,
    ),
  );
}

//USER INTERFACE: SHOW SIGN IN OR SIGN UP BUTTON
Widget showSignInSignUpButton(BuildContext context, bool isSignIn) {
  return new Container(
    height: 55,
    width: isSignIn ? 100 : 110,

    child: Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Text(
        isSignIn ? "Login" : "Signup",
        style: TextStyle(
          color: Theme.of(context).scaffoldBackgroundColor,
          fontWeight: FontWeight.w500,
          fontSize: 20.0,
        ),
      ),
    ),
  );
}

//USER INTERFACE: SHOW FORGOT PASSWORD BUTTON
Widget showForgotPasswordButton(BuildContext context) {
  return new Text(
    "Forgot Password",
    style: TextStyle(
        color: Theme.of(context).dialogBackgroundColor,
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