import 'package:project_ing_validator/screens/authenticate/sign_in.dart';
import 'package:project_ing_validator/screens/authenticate/sign_up.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {

  bool showSignIn = true;

  toggleView() {
    setState( () => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if(showSignIn) {
      return SignIn(toggleView : toggleView);
    }
    else {
      return SignUp(toggleView : toggleView);
    }
  }
}