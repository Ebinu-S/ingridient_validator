import 'dart:convert';

import 'package:project_ing_validator/data/allergens.dart';
import 'package:project_ing_validator/models/user.dart';

class AllergyFinder{

  Map findAllergens(Map allConcepts, dynamic udata) {

    var userAllergies = udata['allergies'];
    print("in find allergens");
    // print(allConcepts);
    // print(udata);

    //* logic
    // for (var allergy in userAllergies) { // iterates over the user allergies
      // for (var allergen in allergens) { // iterates over the allergens data
        // if (allergen.name == allergy) {
    //       for (let concept of allConcepts) { // iterate over the returned concepts (Clarafai API)
    //         for (let i of allergen.data) {
    //           if (i == concept) {
    //             allergensFound.push(i);
    //             console.log("allergen found: " + i);
    //           }
    //         }
    //       }
    //     }
    //   }
    // }
    //* end of logic

    List conceptsList = allConcepts['concepts'];
    List allergensFound = [];
    
    for(String allergy in userAllergies) {
      allergens.forEach((allergen) {

        if(allergen["name"] == allergy) {

          for(dynamic concepts in conceptsList) {
            List data = allergen['data'].toList();
            data.forEach((d) {
              if(d == concepts['name']) {
                print(d);
                allergensFound.add(d);
              }
            });
          }
        }
      }
      );
    };

      print(":: end of allergen finder");

    return {
      "allergensFound" : allergensFound,
      "Ingredients" : conceptsList
    };
  }

}