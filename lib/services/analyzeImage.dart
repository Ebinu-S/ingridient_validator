import 'dart:io';
import 'dart:developer'; // delete on production
import 'package:flutter/cupertino.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

// analyzes and return the text of input image

Future<Map> PickImage(ImageSource source ) async {

  var result = {};

  try{

    final ImagePicker _picker = ImagePicker();
    final pickedImage = await _picker.pickImage(source: source);
    if(pickedImage != null) {
      File image = File(pickedImage.path);
      await cropImage(image.path).then((value) {

        result = {
          'success' : true,
          'message' : value!['text'],
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

Future<Map?> cropImage(filePath) async {

  File imageFile;

  File? croppedImage = await ImageCropper().cropImage(
    sourcePath: filePath,
  );

  if(croppedImage != null) {
    imageFile = croppedImage;
    List text = await getRecognizedText(croppedImage);
    return {
      'text': text ,
      'image' : imageFile
      };
  }
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