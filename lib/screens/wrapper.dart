import 'package:flutter/widgets.dart';
import 'package:project_ing_validator/screens/home/home.dart';
import 'package:project_ing_validator/screens/authenticate/authenticate.dart';
import 'package:project_ing_validator/models/user.dart';
import 'package:project_ing_validator/screens/initialScreens/selectAllergies.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<AppUser?>(context);
    if(user == null) {
      return Authenticate();
    }
    else {
      return Home();
    }

  }
}
