import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final authStatusProvider = StreamProvider.autoDispose(
    (ref) => FirebaseAuth.instance.authStateChanges());

final authProvider = Provider.autoDispose((ref) => AuthProvider());

class AuthProvider {
  CollectionReference dbAdmin = FirebaseFirestore.instance.collection('admins');

  Future<String> userSignUp({
    required String fullName,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential response = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await dbAdmin.add({
        'Full Name': fullName,
        'email': email,
        'adminId': response.user!.uid,
      });
      return 'Success';
    } on FirebaseAuthException catch (err) {
      return '${err.message}';
    }
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      return 'Success';
    } on FirebaseAuthException catch (err) {
      return '${err.message}';
    }
  }

  Future<String> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      return 'Success';
    } on FirebaseAuthException catch (err) {
      return '${err.message}';
    }
  }
}
