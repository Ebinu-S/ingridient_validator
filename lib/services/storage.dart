import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';
import 'package:path/path.dart';

class StorageService {
  final storage = FirebaseStorage.instance;

  Future<String> uploadImageAndGetUrl(File? image) async {

    String result;

    try{
      String filename = basename(image!.path);
      final imageref = storage.ref().child(filename);

      await imageref.putFile(image);

      String url = await imageref.getDownloadURL();
      result = url;
    }
    catch (error) {
      print("error");
      print(error);
      result = "error";
    }
    return result;
  }
}