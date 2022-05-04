import 'package:flutter/material.dart';
import 'package:project_ing_validator/services/auth.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        backgroundColor: Color(0xff533E85),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Center(
          child: ElevatedButton(
            child: Text("Sign in as Guest"),
            onPressed: () async {
              dynamic result = await _auth.signInAnon();
              if(result == null) {
                print("Error sign in");
              }
              else {
                print('sing in');
                print(result);
              }
            },
          ),
        ),
      ),
    );
  }
}
