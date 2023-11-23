// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/models/provincial_election.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final madheshProvider = Provider.autoDispose((ref) => MadheshProvider());
final madheshFPTPProvider =
    StreamProvider.autoDispose((ref) => MadheshProvider().getFPTPStream());
final madheshFptpSortedProvider = StreamProvider.autoDispose(
    (ref) => MadheshProvider().getSortedFPTPStream());
final madheshPRProvider =
    StreamProvider.autoDispose((ref) => MadheshProvider().getPRStream());

class MadheshProvider {
  CollectionReference dbMadheshFPTP =
      FirebaseFirestore.instance.collection('madhesh fptp');
  CollectionReference dbMadheshPR =
      FirebaseFirestore.instance.collection('madhesh pr');
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> addFPTPPost({
    required String candidateName,
    required String partyName,
    required String candidateInfo,
    required String imageUrl,
    required String partyUrl,
    required String barColor,
  }) async {
    try {
      final imageId = DateTime.now().toString();
      final partyImageId = DateTime.now().toString();
      await dbMadheshFPTP.add({
        'candidateName': candidateName,
        'partyName': partyName,
        'candidateInfo': candidateInfo,
        'imageUrl': imageUrl,
        'imageId': imageId,
        'partyUrl': partyUrl,
        'partyImageId': partyImageId,
        'barColor': barColor,
        'votes': {
          'vote': 0,
          'userId': [],
        },
      });
      return 'Success';
    } on FirebaseException catch (err) {
      return '$err';
    }
  }

  Stream<List<ProvincialFPTP>> getFPTPStream() {
    return dbMadheshFPTP.snapshots().map((event) => getFPTPData(event));
  }

  Stream<List<ProvincialFPTP>> getSortedFPTPStream() {
    return dbMadheshFPTP
        .orderBy('votes.vote', descending: true)
        .snapshots()
        .map((event) => getFPTPData(event));
  }

  List<ProvincialFPTP> getFPTPData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final json = e.data() as Map<String, dynamic>;
      return ProvincialFPTP(
        id: e.id,
        candidateName: json['candidateName'],
        partyName: json['partyName'],
        partyUrl: json['partyUrl'],
        barColor: json['barColor'],
        imageUrl: json['imageUrl'],
        candidateInfo: json['candidateInfo'],
        partyImageId: json['partyImageId'],
        imageId: json['imageId'],
        voteData: Vote.fromJson(json['votes']),
      );
    }).toList();
  }

  Future<String> updateFPTP(
      {required String candidateName,
      required String partyName,
      required String candidateInfo,
      required String barColor,
      required String postId}) async {
    try {
      await dbMadheshFPTP.doc(postId).update({
        'candidateName': candidateName,
        'partyName': partyName,
        'candidateInfo': candidateInfo,
        'barColor': barColor,
      });
      return 'Success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<String> removeFPTP(
      {required String postId,
      required String imageId,
      required String partyImageId}) async {
    try {
      final ref = FirebaseStorage.instance
          .ref()
          .child('provincialCandidateImage/$imageId');
      await ref.delete();
      final ref1 = FirebaseStorage.instance
          .ref()
          .child('provincialPartyImage/$partyImageId');
      await ref1.delete();
      await dbMadheshFPTP.doc(postId).delete();
      return 'Success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<List<ProvincialFPTPStats>> getProvincialFPTPStats() {
    return _firebaseFirestore.collection('madhesh fptp').get().then(
        (querySnapshot) => querySnapshot.docs
            .asMap()
            .entries
            .map((entry) =>
                ProvincialFPTPStats.fromSnapshot(entry.value, entry.key))
            .toList());
  }

  // Proportional Voting

  Future<String> addPRPost({
    required String partyName,
    required String partyInfo,
    required String imageUrl,
    required String barColor,
  }) async {
    try {
      final imageId = DateTime.now().toString();
      await dbMadheshPR.add({
        'partyName': partyName,
        'partyInfo': partyInfo,
        'imageUrl': imageUrl,
        'imageId': imageId,
        'barColor': barColor,
        'votes': {
          'vote': 0,
          'userId': [],
        },
      });
      return 'Success';
    } on FirebaseException catch (err) {
      return '$err';
    }
  }

  Stream<List<ProvincialPR>> getPRStream() {
    return dbMadheshPR.snapshots().map((event) => getPRData(event));
  }

  List<ProvincialPR> getPRData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final json = e.data() as Map<String, dynamic>;
      return ProvincialPR(
        id: e.id,
        partyName: json['partyName'],
        partyInfo: json['partyInfo'],
        imageUrl: json['imageUrl'],
        barColor: json['barColor'],
        imageId: json['imageId'],
        voteData: Vote.fromJson(json['votes']),
      );
    }).toList();
  }

  Future<String> updatePR(
      {required String partyName,
      required String partyInfo,
      required String barColor,
      required String postId}) async {
    try {
      await dbMadheshPR.doc(postId).update({
        'partyName': partyName,
        'partyInfo': partyInfo,
        'barColor': barColor,
      });
      return 'Success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<String> removePR(
      {required String postId, required String imageId}) async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child('provincialPartyImage/$imageId');
      await ref.delete();
      await dbMadheshPR.doc(postId).delete();
      return 'Success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }
}
