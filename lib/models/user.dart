class AppUser {

  final String? uid;
  var allergies = [];

  AppUser({ this.uid  });

  addAllergies(List input){
    allergies = input;
  }

}