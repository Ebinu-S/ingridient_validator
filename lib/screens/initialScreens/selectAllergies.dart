import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:project_ing_validator/services/auth.dart';
import 'package:project_ing_validator/db/allergens.dart';
import 'package:project_ing_validator/models/allergy.dart';
import 'package:project_ing_validator/screens/home/home.dart';
import 'package:project_ing_validator/services/firebaseDB.dart';
import 'package:project_ing_validator/screens/shared/loading.dart';
import 'package:sn_progress_dialog/sn_progress_dialog.dart';

class SelectAllergies extends StatefulWidget {
  final dynamic user, username;
  SelectAllergies({required this.user, this.username});

  @override
  State<SelectAllergies> createState() => _SelectAllergiesState();
}

class _SelectAllergiesState extends State<SelectAllergies> {

  final AuthService _auth = AuthService();

  final databaseService db = databaseService();

  bool loading = false;

  List<AllergyModal> allergy = [
    AllergyModal('dairy', false),
    AllergyModal('eggs', false),
    AllergyModal('peanuts', false),
    AllergyModal('treenuts', false),
    AllergyModal('shellfish', false),
    AllergyModal('wheat', false),
    AllergyModal('soy', false),
    AllergyModal('fish', false),
    AllergyModal('corn', false),
  ];

  List<AllergyModal> selectedAllergy = [];

  @override
  Widget build(BuildContext context) {
    ProgressDialog pd = ProgressDialog(context: context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text("Select allergies"),
        backgroundColor: Color(0xff533E85),
        automaticallyImplyLeading: false,
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
                onPressed: () async {
                  pd.show(
                      max:10,
                      msg: 'finalizing please wait....',
                      progressValueColor: Colors.deepPurple,
                      barrierColor: Colors.black12.withOpacity(0.5)
                  );

                  await databaseService().addAllergiesOfUser(selectedAllergy, widget.user, widget.username);
                  print("succesfully updated,user");
                  pd.close();
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(user: widget.user,)));
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
      // leading: CircleAvatar(
      //   backgroundColor: Colors.green[700],
      //   child: Icon(
      //     Icons.e,
      //     color: Colors.white,
      //   ),
      // ),
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
