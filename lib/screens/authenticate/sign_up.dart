import 'package:flutter/material.dart';
import 'package:project_ing_validator/services/auth.dart';
import 'package:project_ing_validator/screens/initialScreens/selectAllergies.dart';
import 'package:project_ing_validator/services/firebaseDB.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class SignUp extends StatefulWidget {
  final Function toggleView;
  const SignUp({required this.toggleView});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final AuthService _auth = AuthService();
  final databaseService _db = databaseService();
  final _formKey = GlobalKey<FormState>();

  bool loading = false;
  String email = '';
  String password = '';
  String username = '';

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign Up"),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xff533E85),
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
                      "Create an account",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    SizedBox(height: 30.0),
                    TextFormField(
                      decoration: InputDecoration(hintText: "Username"),
                      validator: (val) => val!.isEmpty ? "Enter username" : null,
                      onChanged: (val) {
                        setState( () => username = val);
                      },
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
                      onPressed: () async {
                        pd.show(
                            max:10,
                            msg: "Loading..",
                            progressValueColor: Colors.deepPurple,
                            barrierColor: Colors.black12.withOpacity(0.5)
                        );
                        dynamic result = await _auth.SignUpWithEmailAndPassword(email, password);
                        if(result == null) {
                          pd.close();
                          print("No user, user error");
                        }
                        else {
                          await _db.initialiseUser(username, result);
                          pd.close();
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectAllergies(user: result, username: username)));
                        }
                      },
                      child: Text("Next"),
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
                      Icon(Icons.login),
                      SizedBox(width: 10,),
                      Text("Already have an account"),
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
    );;
  }
}
