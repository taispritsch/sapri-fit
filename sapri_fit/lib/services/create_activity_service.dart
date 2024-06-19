import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:sapri_fit/models/person.dart';

class CreateActivityService {
  FirebaseStorage storage = FirebaseStorage.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<String> uploadImage(String path, String fileName) async {
    File file = File(path);

    try {
      await storage.ref('activities/$fileName').putFile(file);

      var imageUrl = await storage.ref('activities/$fileName').getDownloadURL();
      return imageUrl.toString();
    } on FirebaseStorage catch (e) {
      print(e);
      return 'Não foi possível salvar a imagem';
    }
  }

  Future<String> createActivity(
      {required String title,
      String? description,
      required String dateTime,
      required String pace,
      required String distance,
      required String duration,
      required String userUid,
      List? image,
      required List<GeoPoint> location,
      }) async {
    try {
      // Save activity in database
       var personUid = await db.collection('persons').where('userUid', isEqualTo: userUid).get().then((value) => value.docs.first.id);

      final newActivity = db.collection('activities').doc();

      await newActivity.set({
        'uid': newActivity.id,
        'title': title,
        'description': description,
        'dateTime': dateTime,
        'pace': pace,
        'distance': distance,
        'duration': duration,
        'personUid': personUid,
        'image': image,
        'location': location,
      });

      //PEGAR O UID DA ATIVIDADE E DA PESSOA
      return 'Atividade criada com sucesso';
    } catch (e) {
      print(e);
      return 'Erro ao criar atividade';
    }
  }
}