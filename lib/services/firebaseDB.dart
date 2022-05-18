import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_ing_validator/models/allergy.dart';

class databaseService {

  final db = FirebaseFirestore.instance;

  Future<void> initialiseUser(String username, dynamic user) async {
    try{
      await db.collection("users").doc(user.uid).set({
        "username": username
      });
    }
    catch (error) {
      print("error");
      print(error.toString());
    }
  }

  Future<Map?> getData(dynamic user) async {
    Map? result;
    try{
      // print(user.uid);
      await db.collection("users").doc(user.uid ?? "Bk8VESaj7eZwHouyqFGRWcgZtOF2").get().then((value) {
        print("value from db");
        if(value.exists) {
          Map<String,dynamic>? data = value.data();
          print(data);
          result = data;
        }
        else{
          print("value does not exitst");
          result = {
            "error": true
          };
        }
      }).onError((error, stackTrace) {
        print("something went wrong");
        result = {
          "error": true
        };
      });
    }
    catch (error){
      print("error");
      print(error.toString());
      result = {
        "error": true
      };
    }
    return result;
  }

  Future<void> addAllergiesOfUser(List<AllergyModal> allergies, dynamic user, dynamic username) async {
    print("inside the add function");
    // final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

    List onlyAllergyNames = [];
    dynamic data = new Map<String,dynamic>();

    allergies.forEach((element) {
      onlyAllergyNames.add(element.name);
    });

    try{
      await db.collection("users").doc(user.uid).update({
        "allergies" : onlyAllergyNames
      });
      print("after the collection");
    }
    catch (err) {
      print("Something went wrong while setting data to firestore");
      print(err.toString());
    }

  }

}