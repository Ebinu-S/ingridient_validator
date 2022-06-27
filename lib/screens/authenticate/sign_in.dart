import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_ing_validator/models/user.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';
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
  bool loading = false;

  String validationErrorText = "";

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);

    return Scaffold(
      appBar: AppBar(
        title: Text("Sign In"),
        backgroundColor: Color(0xff533E85),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Container(
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
                        validator: (val) =>
                            val!.isEmpty ? "Enter a valid email." : null,
                        onChanged: (val) {
                          setState(() => email = val);
                        },
                      ),
                      SizedBox(height: 20.0),
                      TextFormField(
                        obscureText: true,
                        decoration: InputDecoration(hintText: "Password"),
                        validator: (val) => val!.length < 6
                            ? "Password must be 6 lengths long"
                            : null,
                        onChanged: (val) {
                          setState(() => password = val);
                        },
                      ),
                      SizedBox(height: 30.0),
                      if (validationErrorText != "")
                        Text(
                          validationErrorText,
                          style: TextStyle(color: Colors.redAccent),
                        ),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            pd.show(
                                max: 10,
                                msg: "Signing in..",
                                progressValueColor: Colors.deepPurple,
                                barrierColor: Colors.black12.withOpacity(0.5));
                            dynamic result =
                                await _auth.SignInWithEmailAndPassword(
                                    email, password);
                            if (result is AppUser) {
                              pd.close();
                              setState(() {

                              });
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => Home(user: result)));
                            } else {
                              validationErrorText =
                                  result['message'].substring(30);
                              print("No user, user error");
                              pd.close();
                              setState(() {});
                            }
                          }
                        },
                        child: Text("Sign In"),
                      )
                    ],
                  ),
                ),
                SizedBox(
                  height: 40.0,
                ),
                Text("OR"),
                SizedBox(
                  height: 40.0,
                ),
                ElevatedButton(
                  onPressed: () => widget.toggleView(),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.person_add),
                        SizedBox(
                          width: 10,
                        ),
                        Text("Don't have an account?"),
                      ],
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                      primary: Colors.transparent,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      onPrimary: Colors.grey[800],
                      padding: const EdgeInsets.symmetric(horizontal: 30.0)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
