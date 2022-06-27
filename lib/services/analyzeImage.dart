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
import 'package:project_ing_validator/services/ingredients_extractor.dart';


// analyzes and return the text of input image

Future<Map> PickImage(ImageSource source, dynamic user,bool isText) async {

  var result = {};

  try{

    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.pickImage(source: source);
    if(pickedImage != null) {
      File image = File(pickedImage.path);
      await cropImage(image.path, user, isText).then((value) {
        bool success = value!['error'] == true ? false : true;
        result = {
          'success' : success,
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
  }
  return result;

}

Future<Map?> cropImage(filePath, dynamic user, bool isText) async {
StorageService storage = StorageService();

  File imageFile;

  File? croppedImage = await ImageCropper().cropImage(
    sourcePath: filePath,
  );

  if(croppedImage != null) {
    if(isText) {
      // get the allergen's from the text.
      dynamic scannedTexts = await getRecognizedText(croppedImage);
      final IngredientExtractor IE = IngredientExtractor();
      final AllergyFinder af = AllergyFinder();
      final databaseService db = databaseService();
      imageFile = croppedImage;

      dynamic udata = await db.getData(user);
      Map extracted__ingridients = IE.extractTheIngredients(scannedTexts);
      if(extracted__ingridients == []){
        // todo return error message
        return {
          'allergensFound': [],
          'ingredients' : [],
          'image' : imageFile
        };
      }
      else {
        Map result = af.findAllergens(extracted__ingridients, udata, isText);
        return {
          'allergensFound': result["allergensFound"],
          'ingredients' : result["Ingredients"],
          'image' : imageFile
        };
      }

    }
    else {
      String url = await storage.uploadImageAndGetUrl(croppedImage);
      Map data = await getIngredientsFromImage(url, user);
      imageFile = croppedImage;
      return {
        'allergensFound': data["allergensFound"],
        'ingredients' : data["Ingredients"],
        'image' : imageFile
      };
    }
  }
}

Future<Map> getIngredientsFromImage(String firebaseImageurl, dynamic user) async {

  Map result = {};
  final databaseService db = databaseService();
  final AllergyFinder af = AllergyFinder();

  dynamic udata = await db.getData(user);

  try{
    var url = Uri.parse("https://ing-validator-backend.herokuapp.com/api");
    var body =  {
      "url":firebaseImageurl,
    };
    var data;
    var response = await http.post(url, body: body);
    print("response from backend");
    if (response.body.isNotEmpty) {
      print("dd");
      print(data);
      data = json.decode(response.body);
      Map result = af.findAllergens(data, udata, false);
      return result;
    }
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