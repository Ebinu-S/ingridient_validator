import 'dart:io';
import 'dart:developer'; // delete on production
import 'package:project_ing_validator/models/user.dart';
import 'package:project_ing_validator/screens/settings/settings.dart';
import 'package:project_ing_validator/services/analyzeImage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_ing_validator/services/auth.dart';
import 'package:project_ing_validator/services/firebaseDB.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

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
  bool safetoeat = true;
  bool error = false;

  @override
  Widget build(BuildContext context) {

    ProgressDialog pd = ProgressDialog(context: context);

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
                SizedBox(height: 10.0,),
                Container(
                  width: 500,
                  height: 260,
                  padding: EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    color: Color(0xffffffff),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Scan food",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                pd.show(
                                    max:10,
                                    msg: "Analyzing..",
                                    progressValueColor: Colors.deepPurple,
                                    barrierColor: Colors.black12.withOpacity(0.5)
                                );
                                await getImage(ImageSource.camera, udata, false);
                                pd.close();
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
                              onPressed: () async {
                                pd.show(
                                    max:10,
                                    msg: "Analyzing..",
                                    progressValueColor: Colors.deepPurple,
                                    barrierColor: Colors.black12.withOpacity(0.5)
                                );
                                await getImage(ImageSource.gallery, udata, false);
                                pd.close();
                              },
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
                      SizedBox(
                        height: 30.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "Scan Ingridient's",
                            style: TextStyle(
                                fontWeight: FontWeight.bold
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                        children: [
                          ElevatedButton(
                              onPressed: () async {
                                pd.show(
                                    max:10,
                                    msg: "Analyzing..",
                                    progressValueColor: Colors.deepPurple,
                                    barrierColor: Colors.black12.withOpacity(0.5)
                                );
                                await getImage(ImageSource.camera, udata, true);
                                pd.close();
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
                              onPressed: () async {
                                pd.show(
                                    max:10,
                                    msg: "Analyzing..",
                                    progressValueColor: Colors.deepPurple,
                                    barrierColor: Colors.black12.withOpacity(0.5)
                                );
                                await getImage(ImageSource.gallery, udata, true);
                                pd.close();
                              },
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
                    ]
                  ),
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
                        "Result:",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),),
                      SizedBox(height: 25),
                      if(error == true ) Text(
                        scannedText,
                        style: TextStyle(
                          fontSize: 23,
                          color: Colors.redAccent,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 25),
                      if(error == false) Text(
                        scannedText != "" ? scannedText : "Scan image to display ingredients." ,
                        style: TextStyle(
                          fontSize: 18,
                          color: safetoeat ? Colors.lightGreen : Colors.redAccent,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 05),
                      if(foundAllergens != "") Text(
                        "Allergens present:" ,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),),
                      SizedBox(height: 05),
                      Text(
                        foundAllergens != "" ? foundAllergens : "" ,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),),
                      SizedBox(height: 25),
                      if(allIngredients != "") Text(
                        "All ingredients:" ,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.normal,
                        ),),
                      SizedBox(height: 15),
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

  Future<void> getImage(ImageSource source, dynamic udata, bool isText) async {

    textScanning = true;
    scannedText = "";
    foundAllergens = "";
    allIngredients = "";
    imageFile = null;

    try{
      await PickImage(source, widget.user, isText).then((res)
      {
        print("res");
        print(res);
        if(res['success'] == true) {
          imageFile = res['image'];
          safetoeat = res['allergensFound']!.length > 0 ? false : true;
          scannedText = safetoeat ? "No allergens found\n" : "Allergens found. DONT EAT\n";
          // foundAllergens = res['allergensFound'];

          if(res['allergensFound'] != null) {
            res['allergensFound'].forEach( (element) {
              foundAllergens += element + ", ";
            });
          }

          if(res['ingredients'] != null) {
            res['ingredients'].forEach( (element) {
              allIngredients += element['name'] + ", ";
            });
          }

          textScanning =false;
          setState(() { });
        }
        else {
          textScanning =false;
          error = true;
          imageFile = null;
          print("Error");
          scannedText = "Something went wrong please try again later";
          setState(() { });
        }
      }
      );
    }
    catch (error) {
      textScanning =false;
      print("Error");
      print(error);
      scannedText = "Something went wrong please try again later";
      setState(() { });
    }

  }
}