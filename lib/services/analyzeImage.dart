import 'dart:io';
import 'dart:developer'; // delete on production
import 'package:flutter/cupertino.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:project_ing_validator/services/allergyFinder.dart';
import 'package:project_ing_validator/services/storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:project_ing_validator/services/firebaseDB.dart';

// import 'package:flutter_dotenv/flutter_dotenv.dart';

// analyzes and return the text of input image

Future<Map> PickImage(ImageSource source, dynamic user) async {

  var result = {};

  try{

    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.pickImage(source: source);
    if(pickedImage != null) {
      File image = File(pickedImage.path);
      await cropImage(image.path, user).then((value) {
        result = {
          'success' : true,
          'ingredients' : value!['ingredients'],
          'allergensFound' : value['allergensFound'],
          'image' : value['image'],
        };
      });
    }

    else {
      // inform error
      print("error");
      result = {
        'success' : false,
        'message' : 'Picked image is null'
      };
    }
  }
  catch (e) {

    result = {
      'success' : false,
      'message' : 'Pick image error'
    };

    print("Error");
    // todo return error
  }

  return result;

}

Future<Map?> cropImage(filePath, dynamic user) async {
StorageService storage = StorageService();

  File imageFile;

  File? croppedImage = await ImageCropper().cropImage(
    sourcePath: filePath,
  );

  if(croppedImage != null) {
    String url = await storage.uploadImageAndGetUrl(croppedImage);
    Map data = await getIngredientsFromImage(url, user);
    imageFile = croppedImage;

    // *********old***************
    // List text = await getRecognizedText(croppedImage);
    // *********old***************

    return {
      'allergensFound': data["allergensFound"],
      'ingredients' : data["Ingredients"],
      'image' : imageFile
    };
  }
}

Future<Map> getIngredientsFromImage(String firebaseImageurl, dynamic user) async {

  Map result = {};
  final databaseService db = databaseService();
  final AllergyFinder af = AllergyFinder();

  dynamic udata = await db.getData(user);

  try{
    print("in the try");
    var url = Uri.parse("https://ing-validator-backend.herokuapp.com/api");
    var body =  {
      "url":firebaseImageurl,
      "userAllergies": jsonEncode(udata['allergies'])
    };
    print(body);
    print("before response");
    var data;
    var response = await http.post(url, body: body);
    print("response from backend");
    if (response.body.isNotEmpty) {
      data = json.decode(response.body);
      Map result = af.findAllergens(data, udata);
      return result;
    }
    print(data);
  }
  catch (error) {
    print("error from api connection");
    print(error);
    result = {
      "error": true
    };
  }


  return result;
}

Future<List> getRecognizedText(File? image) async {

  var scannedText = <String>[];

  final inputImage = InputImage.fromFilePath(image!.path);
  final textDetector = GoogleMlKit.vision.textRecognizer();
  RecognizedText recognizedText = await textDetector.processImage(inputImage);
  await textDetector.close();

  for( TextBlock block in recognizedText.blocks) {
    scannedText.add(block.text);
  }
  return scannedText;
}