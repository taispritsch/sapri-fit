class User {
  String uid;
  String email;

  User({required this.uid, required this.email});

  User.fromMap(Map<String, dynamic> data)
      : uid = data['uid'],
        email = data['email'];

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
    };
  }
}
