import 'package:flutter/material.dart';
import 'package:project_ing_validator/screens/home/home.dart';
import 'package:project_ing_validator/screens/initialScreens/selectAllergies.dart';
import 'package:project_ing_validator/services/auth.dart';
import 'package:project_ing_validator/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:project_ing_validator/models/user.dart';


class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);

    return Scaffold(
      backgroundColor: Color(0xffF3F1F8),
      appBar: AppBar(
        title: Text("Ingridient's validator"),
        backgroundColor: Color(0xff533E85),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          ElevatedButton.icon(
              onPressed: () async{
                // await _auth.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home()));
              },
              icon: Icon(Icons.home),
              label: Text(""),
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0.0
              )
          )],
      ),
      body: SingleChildScrollView(
        child: Container(
        margin: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton.icon(
                onPressed: () async{
                  await _auth.signOut();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Authenticate()));
                },
                icon: Icon(Icons.person),
                label: Text("LogOut"),
            ),
            ElevatedButton.icon(
              onPressed: () async{
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectAllergies(user: user)));
              },
              icon: Icon(Icons.list),
              label: Text("Select Allergies"),
            ),
          ],
        ),
        ),
      )
    );
  }
}
