import 'package:sapri_fit/models/user.dart';

class Person {
  String uid;
  String name;
  String email;
  User userUid;
  String? birthDate;
  String? sex;
  List? imc;

  //IMAGEM

  Person({
    required this.uid, 
    required this.name, 
    required this.email, 
    required this.userUid, 
    this.birthDate,
    this.sex,
    this.imc,
  });

  Person.fromFirestore(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'],
        email = data['email'],
        userUid = data['userUid'],
        birthDate = data['birthDate'],
        sex = data['sex'],
        imc = data['imc'];

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'userUid': userUid,
      'birthDate': birthDate,
      'sex': sex,
      'imc': imc,
    };
  }
}