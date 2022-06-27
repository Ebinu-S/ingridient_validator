// extract and return ingredients from input array of strings
import 'dart:developer'; // delete on production

class IngredientExtractor {

  Map extractTheIngredients(List blocks) {

      List result = [];
      bool nextHasIngredients = false; //sets true if the ingredients are on next block

      for (String element in blocks) {

        if(nextHasIngredients) {
          List ingredients = [];
          List<String> temp = element.split(',');
          for (var element in temp) {
            ingredients.add({
              "id": "null",
              "name": element,
            });
          }
          result = ingredients;
          break;
        }

      // check if the block contains word INGREDIENT[s]
      if(element.contains("INGREDIENTS") || element.contains("INGREDIENT")) {
        // validate if ingredients are in this block or next
        if(element.length > 12 ){
          List ingredients = [];
          List<String> temp = element.substring(13).split(',');
          for (var element in temp) {
            ingredients.add({
              "id": "null",
              "name": element,
            });
          }
          result = ingredients;
          break;
        }
        else {
          nextHasIngredients = true;
        }
      }
    }

    if(result == []) {
      return{
        "concepts": result,
        "error": true
      };
    }

    return {
      "concepts": result,
      "error": false
    };
  }
}
