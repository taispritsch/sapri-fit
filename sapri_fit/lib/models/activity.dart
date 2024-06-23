
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity {
  String uid;
  String title;
  String description;
  List? image;
  String dateTime;
  String pace;
  String distance;
  String duration;
  List location;
  DocumentReference personUid;
  String? personName;

  Activity({
    required this.uid,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.pace,
    required this.distance,
    required this.duration,
    required this.location,
    required this.personUid,
    this.image,
    this.personName
  });

  Activity.fromFirestore(Map<String, dynamic> data)
      : uid = data['uid'],
        title = data['title'],
        description = data['description'],
        dateTime = data['dateTime'],
        pace = data['pace'],
        distance = data['distance'],
        duration = data['duration'],
        location = data['location'],
        personUid = data['personUid'],
        image = data['image'];

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'title': title,
      'description': description,
      'dateTime': dateTime,
      'pace': pace,
      'distance': distance,
      'duration': duration,
      'location': location,
      'personUid': personUid,
      'image': image,
    };
  }

}