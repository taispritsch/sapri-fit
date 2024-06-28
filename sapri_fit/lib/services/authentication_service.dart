import 'package:firebase_auth/firebase_auth.dart';
import 'package:sapri_fit/models/person.dart';
import 'package:sapri_fit/services/person_service.dart';

class AuthenticationService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final PersonService _personService = PersonService();

  // Sign in with email and password
  Future<String?> signIn(
      {required String email, required String password}) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return "Usuário não encontrado";
      } else if (e.code == 'wrong-password') {
        return "Senha incorreta";
      }

      return "Erro ao fazer login";
    }
  }

  // Sign up with email and password
  Future<String?> signUp(
      {required String email,
      required String password,
      required String name}) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;

      await _personService.createPerson(
          name: name, email: email, userUid: user!.uid);

      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        return "O usuário já está cadastrado";
      }

      return "Erro ao cadastrar usuário";
    }
  }

  // Sign out
  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  // Get current user
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  // Get person by user uid
  Future<Person?> getPersonByUserUid(String userUid) async {
    return await _personService.getPersonByUserUid(userUid);
  }
}
