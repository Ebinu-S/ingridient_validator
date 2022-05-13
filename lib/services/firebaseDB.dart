import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_ing_validator/models/allergy.dart';

class databaseService {

  final db = FirebaseFirestore.instance;

  Future<void> addAllergiesOfUser(List<AllergyModal> allergies, dynamic user, dynamic username) async {
    print("inside the add function");
    // final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

    List onlyAllergyNames = [];
    dynamic data = new Map<String,dynamic>();

    allergies.forEach((element) {
      onlyAllergyNames.add(element.name);
    });

    try{
      await db.collection("users").doc(user.uid).set({
        "email" : user.email,
        "username" : username,
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