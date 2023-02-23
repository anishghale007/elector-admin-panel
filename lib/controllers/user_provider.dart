import 'package:elector_admin_dashboard/models/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userStream =
    StreamProvider.autoDispose((ref) => CrudProvider().getSingleUser());
final userProvider =
    StreamProvider.autoDispose((ref) => CrudProvider().getUserData());

class CrudProvider {
  CollectionReference dbUsers = FirebaseFirestore.instance.collection('users');

  List<User> UserData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs
        .map((e) => User.fromJson((e.data() as Map<String, dynamic>)))
        .toList();
  }

  Stream<List<User>> getUserData() {
    return dbUsers.snapshots().map((event) => UserData(event));
  }

  User singleUser(QuerySnapshot querySnapshot) {
    final singleData = querySnapshot.docs[0].data() as Map<String, dynamic>;
    return User.fromJson(singleData);
  }

  Stream<User> getSingleUser() {
    final uid = auth.FirebaseAuth.instance.currentUser!.uid;
    final user = dbUsers.where('userId', isEqualTo: uid).snapshots();
    return user.map((event) => singleUser(event));
  }
}
