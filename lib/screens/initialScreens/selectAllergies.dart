import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_ing_validator/services/auth.dart';
import 'package:project_ing_validator/db/allergens.dart';
import 'package:project_ing_validator/models/allergy.dart';
import 'package:project_ing_validator/screens/home/home.dart';

class SelectAllergies extends StatefulWidget {
  const SelectAllergies({Key? key}) : super(key: key);

  @override
  State<SelectAllergies> createState() => _SelectAllergiesState();
}

class _SelectAllergiesState extends State<SelectAllergies> {

  final AuthService _auth = AuthService();

  List<AllergyModal> allergy = [
    AllergyModal('Milk', false),
    AllergyModal('Egg', false),
    AllergyModal('Nuts', false),
    AllergyModal('Peanuts', false),
    AllergyModal('Shellfish', false),
    AllergyModal('Wheat', false),
    AllergyModal('Soy', false),
    AllergyModal('Fish', false),
  ];

  List<AllergyModal> selectedAllergy = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select allergies"),
        backgroundColor: Color(0xff533E85),
        actions: <Widget>[
          ElevatedButton.icon(
              onPressed: () async{
                await _auth.signOut();
              },
              icon: Icon(Icons.person),
              label: Text("Log out"),
              style: ElevatedButton.styleFrom(
                  primary: Colors.transparent,
                  elevation: 0.0
              )
          )],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Select your known allegies"),
            // SizedBox(height: 20,),
            ListView.builder(
              itemCount: allergy.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemBuilder: (BuildContext context, int index) {
                return AllergyItem(
                  allergy[index].name,
                  allergy[index].isSelected,
                  index,
                );
              },
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (context) => Home()));
                },
                child: Text("Finish")
            )
          ],
        ),
      ),
    );
  }

  Widget AllergyItem(String? name, bool? isSelected, int index) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green[700],
        child: Icon(
          Icons.person_outline_outlined,
          color: Colors.white,
        ),
      ),
      title: Text(
        name!,
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: isSelected!
          ? Icon(
        Icons.check_circle,
        color: Colors.green[700],
      )
          : Icon(
        Icons.check_circle_outline,
        color: Colors.grey,
      ),
      onTap: () {
        setState(() {
          allergy[index].isSelected = !allergy[index].isSelected!;
          if (allergy[index].isSelected == true) {
            selectedAllergy.add(AllergyModal(name, true));
          } else if (allergy[index].isSelected == false) {
            selectedAllergy
                .removeWhere((element) => element.name == allergy[index].name);
          }
        });
      },
    );
  }
}
