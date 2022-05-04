import 'dart:io';

import 'dart:developer'; // delete on production

import 'services/analyzeImage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      primarySwatch: Colors.deepPurple,
    ),
    home: Home(),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  bool textScanning = false;
  File? imageFile;
  String scannedText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF3F1F8),
      appBar: AppBar(
        title: Text("Ingridient's validator"),
        backgroundColor: Color(0xff533E85),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly ,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        getImage(ImageSource.camera);
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
                      onPressed: () => getImage(ImageSource.gallery),
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
                      ),),
                  ],
                ),
              ),
            ],
          ),
        )
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        child: Container(height: 50.0),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Analyze',
        child: Icon(Icons.analytics),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void getImage(ImageSource source) async {

    textScanning = true;

    await PickImage(source).then((res)
      {
        if(res['success'] == true) {
          scannedText = res['message'];
          imageFile = res['image'];
          print( " image file path");
          print(imageFile?.path);
          textScanning = false;
          setState(() {});
        }
        else {
          print("Error");
      }
    }
    );

    print("goback");
    // print(result);
    // scannedText = result.data;

  }
}



