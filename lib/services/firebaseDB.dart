import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:project_ing_validator/models/allergy.dart';

class databaseService {

  Future<void> addAllergiesOfUser(List<AllergyModal> allergies, dynamic user) async {
    print("inside the add function");
    final CollectionReference userCollection = FirebaseFirestore.instance.collection("users");

    List onlyAllergyNames = [];
    dynamic data = new Map<String,dynamic>();

    allergies.forEach((element) {
      onlyAllergyNames.add(element.name);
    });

    data["email"] = user.email;
    data["allergies"] = onlyAllergyNames;
    print("this is the data");
    print(data);

    await userCollection.doc(user.uid).set(data).onError((error, stackTrace) => print("error happend db.set $error"));
    print("after the collection");
  }

}