import 'package:flutter/material.dart';
import 'package:project_ing_validator/screens/home/home.dart';
import 'package:project_ing_validator/screens/initialScreens/selectAllergies.dart';
import 'package:project_ing_validator/services/auth.dart';
import 'package:project_ing_validator/screens/authenticate/authenticate.dart';
import 'package:provider/provider.dart';
import 'package:project_ing_validator/models/user.dart';
import 'package:project_ing_validator/services/firebaseDB.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class Settings extends StatefulWidget {
  AppUser? user;
  Settings({this.user});

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {

  final AuthService _auth = AuthService();
  final databaseService db = databaseService();

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    final user = Provider.of<AppUser?>(context);
    String myAllegies = "";
    dynamic udata;
    getData() async {
      if(myAllegies == "") {
        udata = await db.getData(user);
        for(var element in udata['allergies']){
          myAllegies += " $element,";
        }
      }
    }
    getData();

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
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(user: widget.user)));
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
          mainAxisSize: MainAxisSize.max,
          children: [
            Text(
              "User Settings",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20,),
            Text(myAllegies),
            ElevatedButton.icon(
              onPressed: () async{
              showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return SizedBox(
                    height: 200,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            "My Allergies",
                            style: TextStyle(
                              fontWeight: FontWeight.bold
                            ),
                          ),
                          SizedBox(height: 10.0,),
                          Text(myAllegies),
                          ],
                        ),
                      ),
                    );
                  },
              );},
              icon: Icon(Icons.list),
              label: Text("Selected Allergies"),
            ),
            ElevatedButton.icon(
              onPressed: () async{
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => SelectAllergies(user: user)));
              },
              icon: Icon(Icons.list),
              label: Text("Update Allergies"),
            ),
            ElevatedButton.icon(
              onPressed: () async{
                await _auth.signOut();
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Authenticate()));
              },
              icon: Icon(Icons.person),
              label: Text("LogOut"),
            ),
          ],
        ),
        ),
      )
    );
  }
}
