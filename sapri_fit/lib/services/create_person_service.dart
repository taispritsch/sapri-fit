import 'package:cloud_firestore/cloud_firestore.dart';

class CreatePersonService {

  FirebaseFirestore db = FirebaseFirestore.instance;
  
  // Create a person with the name and the user id
  Future createPerson({required String name, required String email, required String userUid}) async {
    // Create a person with the name and the user id
    try {
      final newPerson = db.collection('persons').doc();

      await newPerson.set({
        'uid': newPerson.id,
        'name': name,
        'email': email,
        'userUid': userUid,
      });
      return "Person created";
    } catch (e) {
      return "Error creating person";
    }

  }
}