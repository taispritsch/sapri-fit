import 'package:sapri_fit/models/user.dart';

class Person {
  String uid;
  String name;
  String email;
  User userUid;
  String? birthDate;
  String? sex;
  int? weight;
  int? height;
  String? imageUrl;

  //IMAGEM

  Person({
    required this.uid, 
    required this.name, 
    required this.email, 
    required this.userUid, 
    this.birthDate,
    this.sex,
    this.weight,
    this.height,
    this.imageUrl,
  });

  Person.fromFirestore(Map<String, dynamic> data)
      : uid = data['uid'],
        name = data['name'],
        email = data['email'],
        userUid = data['userUid'],
        birthDate = data['birthDate'],
        sex = data['sex'],
        weight = data['weight'],
        height = data['height'],
        imageUrl = data['imageUrl'];

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'userUid': userUid,
      'birthDate': birthDate,
      'sex': sex,
      'weight': weight,
      'height': height,
      'imageUrl': imageUrl,
    };
  }
 
}