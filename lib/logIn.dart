import 'package:Tuter/backend/auth.dart';
import 'package:Tuter/loading.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:Tuter/customTextField.dart';
import 'package:Tuter/login-buttons.dart';
import 'package:Tuter/signup.dart';
import 'package:Tuter/forgot-password.dart';

class Validators {
  static String generic(String input, String response) {
    return input.isEmpty ? response : null;
  }

  static String password(String input) {
    return input.length < 6 ? "Please provide a password" : null;
  }

  static String validateEmail(String input) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);

    if (regex.hasMatch(input)) {
      return null;
    } else {
      return 'Please enter a valid email address';
    }
  }
}

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

// goes to a given page with a given direction
Future navigateToPage(context, direction, page) async {
  Navigator.of(context).push(_createRoute(direction, page));
}

Route _createRoute(direction, page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      double xOffset = direction == Direction.left ? -1.0 : 1.0;
      Offset begin = Offset(xOffset, 0.0);
      Offset end = Offset.zero;
      Curve curve = Curves.ease;

      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

enum Direction { left, right }

// where the log in page starts
class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();


  final Auth _auth = Auth();
  String _email, _password;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            body: Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 30.0),
                    Row(
                      children: <Widget>[
                        Image(
                          // Tutor Logo
                          image: AssetImage('lib/images/tuterLogo.png'),
                          height: 130.0,
                          width: 350.0,
                        ),
                      ],
                    ),
                    SizedBox(height: 30.0),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: <Widget>[
                          CustomTextField(
                            // email text box
                            hint: 'Email',
                            validator: Validators.validateEmail,
                            onSaved: (value) =>
                                _email = value.trim().toLowerCase(),
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          CustomTextField(
                            // password text box
                            hint: 'Password',
                            password: true,
                            validator: Validators.password,
                            onSaved: (value) => _password = value.trim(),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 25.0),
                    LoginButton(
                        // log in button
                        text: 'Login',
                        onPressed: () async {
                          final form = _formKey.currentState;
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            form.save();
                            dynamic result =
                                await _auth.logIn(_email, _password);
                            if (result == null) {
                              setState(() {
                                print('Email or password is incorrect');
                                loading = false;
                              });
                            }
                          }
                        }),
                    FlatButton(
                      // forgot password button
                      onPressed: () =>
                          navigateToPage(context, Direction.left, ForgotPage()),
                      child: Text(
                        'Forgot Password?',
                      ),
                    ),
                    SizedBox(height: 50.0),
                    Text(
                      'New to Tüter?',
                      style: TextStyle(
                        fontSize: 17.0,
                      ),
                    ),
                    LoginButton(
                        // sign up button
                        text: 'Sign Up',
                        padding: 110.0,
                        onPressed: () => navigateToPage(
                            context, Direction.right, SignupPage())),
                    SizedBox(height: 10.0),
                  ],
                ),
              ),
            ),
            backgroundColor: Theme.of(context).primaryColor,
          );
  }
}
