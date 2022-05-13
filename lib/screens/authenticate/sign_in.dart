import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ing_validator/services/auth.dart';
import 'package:project_ing_validator/screens/home/home.dart';

class SignIn extends StatefulWidget {

  final Function toggleView;

  const SignIn({required this.toggleView});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        backgroundColor: Color(0xff533E85),
        automaticallyImplyLeading: false,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Center(
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(height: 50.0),
                    Text(
                      "Sign in to your account",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      decoration: InputDecoration(hintText: "Email"),
                      validator: (val) => val!.isEmpty ? "Enter an email" : null,
                      onChanged: (val) {
                        setState( () => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      obscureText: true,
                      decoration: InputDecoration(hintText: "Password"),
                      validator: (val) => val!.length < 6 ? 'Enter a password 6+ chars long' : null,
                      onChanged: (val) {
                        setState( () => password = val);
                      },
                    ),
                    SizedBox(height: 30.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Text("Sign In"),
                    )
                  ],
                ),
              ),
              SizedBox(height: 40.0,),
              Text("OR"),
              SizedBox(height: 40.0,),
              ElevatedButton(
                onPressed: () => widget.toggleView(),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.person_add),
                      SizedBox(width: 10,),
                      Text("Don't have an account"),
                    ],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                    primary: Colors.transparent,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    onPrimary: Colors.grey[800],
                    padding: const EdgeInsets.symmetric(horizontal: 30.0)
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
