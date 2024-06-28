import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ActivityService {
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

  Future createActivity(
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
      DocumentReference personUid = await db.collection('persons').where('userUid', isEqualTo: userUid).get().then((value) => value.docs.first.reference);

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

      return 'Atividade criada com sucesso';
    } catch (e) {
      print(e);
      return 'Erro ao criar atividade';
    }
  }

  Future updateActivity(
      {required String uid,
      required String title,
      String? description,
      List? image,
      }) async {
    try {
      // Save activity in database
      final newActivity = db.collection('activities').doc(uid);

      await newActivity.update({
        'title': title,
        'description': description,
        'image': image,
      });

      return 'Atividade atualizada com sucesso';
    } catch (e) {
      print(e);
      return 'Erro ao atualizar atividade';
    }
  }
}