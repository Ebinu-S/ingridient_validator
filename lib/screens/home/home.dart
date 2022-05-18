import 'dart:io';

import 'dart:developer'; // delete on production

import 'package:project_ing_validator/models/user.dart';
import 'package:project_ing_validator/screens/settings/settings.dart';
import 'package:project_ing_validator/screens/shared/loading.dart';
import 'package:project_ing_validator/services/allergyFinder.dart';
import 'package:project_ing_validator/services/analyzeImage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_ing_validator/services/auth.dart';
import 'package:project_ing_validator/screens/authenticate/authenticate.dart';
import 'package:project_ing_validator/services/firebaseDB.dart';
import 'package:project_ing_validator/services/ingredients_extractor.dart';

class Home extends StatefulWidget {
  AppUser? user;
  Home({this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final AuthService _auth = AuthService();
  final databaseService db = databaseService();

  bool textScanning = false;
  String scannedText = "";
  String foundAllergens = "";
  String allIngredients = "";
  File? imageFile;

  @override
  Widget build(BuildContext context) {


    print("usernameusername");
    dynamic udata;
    getUserData () async {
      // udata = await db.getData(widget.user);
      print('dtats');
    }
    if(udata == null ) {
      getUserData();
    }
    print(udata);

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
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Settings(user: widget.user)));
              },
              icon: Icon(Icons.settings),
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
              children: [
                // Text(
                //     "Welcome, ${udata == Null ? udata.username + ",": "Guest,"}"
                // ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          getImage(ImageSource.camera, udata);
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100,60),
                          primary: Color(0xffffffff),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                  Icons.camera,
                                  color: Color(0xff312F2F)
                              ),
                              Text(
                                "Camera",
                                style: TextStyle(
                                    color: Color(0xff312F2F)
                                ),
                              )
                            ],
                          ),
                        )
                    ),
                    ElevatedButton(
                        onPressed: () => getImage(ImageSource.gallery, udata),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(100,60),
                          primary: Color(0xffffffff),
                        ),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(
                                  Icons.image,
                                  color: Color(0xff312F2F)
                              ),
                              Text(
                                "Gallery",
                                style: TextStyle(
                                    color: Color(0xff312F2F)
                                ),)
                            ],
                          ),
                        )
                    ),
                  ],
                ),
                SizedBox(height: 20.0), // start of image preview
                Container(
                  width: 500,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color(0xffffffff),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if(textScanning) const CircularProgressIndicator(),
                      if(!textScanning && imageFile == null)
                        Column(
                            children : [
                              Icon(
                                Icons.landscape,
                                size: 40.0,
                              ),
                              Text("Choose or take image to analyse.",
                                style: TextStyle(
                                    fontSize: 18
                                ),
                              )
                            ]
                        ),
                      if (imageFile != null && !textScanning)
                        Image.file(
                          File(imageFile!.path),
                          fit: BoxFit.contain,
                          width: 500,
                          height: 400,
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 20.0),
                Container(
                  width: 500,
                  padding: EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color(0xffffffff),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ingredients:",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),),
                      SizedBox(height: 25),
                      Text(
                        scannedText != "" ? scannedText : "Scan image to display ingridients." ,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        foundAllergens != "" ? foundAllergens : "" ,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),),
                      SizedBox(height: 25),
                      Text(
                        allIngredients != "" ? allIngredients : "" ,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),),
                    ],
                  ),
                ),
              ],
            ),
          )
      ),
    );
  }

  void getImage(ImageSource source, dynamic udata) async {

    textScanning = true;
    scannedText = "";
    foundAllergens = "";
    allIngredients = "";
    imageFile = null;

    await PickImage(source, widget.user).then((res)
    {
      if(res['success'] == true) {
        imageFile = res['image'];
        scannedText = res['allergensFound'].length > 0 ? "Allergens found. DONT EAT\n" : "No allergens found";
        // foundAllergens = res['allergensFound'];
        res['allergensFound'].forEach( (element) {
          foundAllergens += element + ", ";
        });
        res['ingredients'].forEach( (element) {
          allIngredients += element['name'] + ", ";
        });

        // print("all allregerns");
        // print(res['ingredients']);
        textScanning =false;
        setState(() { });
      }
      else {
        print("Error");
        scannedText = "Something went wrong please try again later";
      }
    }
    );
  }
}