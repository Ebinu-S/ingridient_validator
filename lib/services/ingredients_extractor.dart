// extract and return ingredients from input array of strings
import 'dart:developer'; // delete on production

class IngredientExtractor {

  List<String> extractTheIngredients(List blocks) {

    List<String> result = [];
    bool nextHasIngredients = false; //sets true if the ingredients are on next block

    for (String element in blocks) {

      if(nextHasIngredients) {
        List<String> temp = element.split(',');
        result = temp;
        break;
      }

      // check if the block contains word INGREDIENT[s]
      if(element.contains("INGREDIENTS") || element.contains("INGREDIENT")) {
        // validate if ingredients are in this block or next
        if(element.length > 12 ){
          List<String> temp = element.substring(13).split(',');
          result = temp;
          break;
        }
        else {
          nextHasIngredients = true;
        }
      }
    }

    return result;
  }
}
