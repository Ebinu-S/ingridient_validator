import 'package:flutter/material.dart';
import 'package:project_ing_validator/data/allergens.dart';

class AllergyFinder {
  Map findAllergens(Map allConcepts, dynamic udata) {
    var userAllergies = udata['allergies'];

    List conceptsList = allConcepts['concepts'];
    List allergensFound = [];

    for (String allergy in userAllergies) {
      allergens.forEach((allergen) {
        if (allergen["name"] == allergy) {
          for (dynamic concepts in conceptsList) {
            List data = allergen['data'].toList();
            for (var d in data) {
              if (d == concepts['name']) {
                allergensFound.add(d);
              }
            }
          }
        }
      });
    };

    return {
      "allergensFound": allergensFound,
      "Ingredients": conceptsList,
      "error": false
    };
  }
}
