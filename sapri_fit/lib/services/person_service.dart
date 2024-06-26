import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sapri_fit/models/person.dart';
import 'dart:async';

import 'package:sapri_fit/models/user.dart';

class PersonService {

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  
  // Create a person with the name and the user id
  Future createPerson({required String name, required String email, required String userUid, String? sex,}) async {
    // Create a person with the name and the user id
    try {
      final newPerson = db.collection('persons').doc();

      await newPerson.set({
        'uid': newPerson.id,
        'name': name,
        'email': email,
        'userUid': userUid,
        'sex': sex,
      });
      return "Person created";
    } catch (e) {
      return "Error creating person";
    }
  }

  Future<Person?> getPersonByUserUid(String userUid) async {
    try {
      var querySnapshot = await db.collection('persons').where('userUid', isEqualTo: userUid).limit(1).get();

      if (querySnapshot.docs.isNotEmpty) {
        var userData = querySnapshot.docs.first.data();
        dynamic userUidData = userData['userUid'];

        if (userUidData is String) {
          User user = User(uid: userUidData, email: userData['email']);
          userData['userUid'] = user; 
          return Person.fromFirestore(userData);
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<String> updatePerson({
    required String uid,
    required String name,
    required String email,
    String? sex,
    String? birthDate,
    int? height,
    int? weight,
    String? imageUrl,
  }) async {
    try {
      final personRef = db.collection('persons').doc(uid);
      await personRef.update({
        'name': name,
        'email': email,
        'sex': sex,
        'birthDate': birthDate,
        'height': height,
        'weight': weight,
        'imageUrl': imageUrl,
      });

      return "Updated person";
    } catch (e) {
      return "Error updating person";
    }
  }

  Future<String> uploadImage(String path, String fileName) async {
    File file = File(path);

    try {
      await storage.ref('profile/$fileName').putFile(file);

      var imageUrl = await storage.ref('profile/$fileName').getDownloadURL();
      return imageUrl.toString();
    } on FirebaseStorage catch (e) {
      print(e);
      return 'Não foi possível salvar a imagem';
    }
  }
}
