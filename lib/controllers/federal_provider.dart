import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/models/federal_election.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final federalProvider = Provider.autoDispose((ref) => FederalProvider());
final fptpProvider =
    StreamProvider.autoDispose((ref) => FederalProvider().getFPTPStream());
final fptpSortedProvider =
StreamProvider.autoDispose((ref) => FederalProvider().getSortedFPTPStream());
final prProvider =
StreamProvider.autoDispose((ref) => FederalProvider().getPRStream());
final prSortedProvider =
StreamProvider.autoDispose((ref) => FederalProvider().getSortedPRStream());


class FederalProvider {
  CollectionReference dbFederalFPTP =
      FirebaseFirestore.instance.collection('federal fptp');
  CollectionReference dbFederalPR =
      FirebaseFirestore.instance.collection('federal pr');

  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> addFPTPPost({
    required String candidateName,
    required String partyName,
    required String barColor,
    required String candidateInfo,
    required String imageUrl,
    required String partyUrl,
  }) async {
    try {
      final imageId = DateTime.now().toString();
      final partyImageId = DateTime.now().toString();
      isDuplicateFPTPBarColor(barColor);
      if (await  isDuplicateFPTPBarColor(barColor)) {
        return 'Barcolor is already taken';
      } else {
        await dbFederalFPTP.add({
          'candidateName': candidateName,
          'partyName': partyName,
          'barColor': barColor,
          'candidateInfo': candidateInfo,
          'imageUrl': imageUrl,
          'imageId': imageId,
          'partyUrl': partyUrl,
          'partyImageId': partyImageId,
          'votes': {
            'vote': 0,
            'userId': [],
          },
        });
        return 'Success';
      }
    } on FirebaseException catch (err) {
      return '$err';
    }
  }

  Stream<List<FederalFPTP>> getFPTPStream() {
    return dbFederalFPTP.snapshots().map((event) => getFPTPData(event));
  }

  Stream<List<FederalFPTP>> getSortedFPTPStream() {
    return dbFederalFPTP
        .orderBy('votes.vote', descending: true)
        .snapshots()
        .map((event) => getFPTPData(event));
  }


  List<FederalFPTP> getFPTPData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final json = e.data() as Map<String, dynamic>;
      return FederalFPTP(
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

  Future<List<FederalFPTPStats>> getFederalFPTPStats() {
    return _firebaseFirestore.collection('federal fptp').get().then(
        (querySnapshot) => querySnapshot.docs
            .asMap()
            .entries
            .map((entry) =>
                FederalFPTPStats.fromSnapshot(entry.value, entry.key))
            .toList());
  }

  Future<String> updateFPTP(
      {required String candidateName,
      required String partyName,
      required String candidateInfo,
      required String barColor,
      required String postId}) async {
    try {
      await dbFederalFPTP.doc(postId).update({
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
          .child('federalCandidateImage/$imageId');
      await ref.delete();
      final ref1 = FirebaseStorage.instance
          .ref()
          .child('federalPartyImage/$partyImageId');
      await ref1.delete();
      await dbFederalFPTP.doc(postId).delete();
      return 'Success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<bool> isDuplicateFPTPBarColor(String barColor) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('federal fptp')
        .where('barColor', isEqualTo: barColor)
        .get();
    return query.docs.isNotEmpty;
  }

  // Federal PR voting

  Future<String> addPRPost({
    required String partyName,
    required String partyFull,
    required String partyInfo,
    required String barColor,
    required String imageUrl,
  }) async {
    try {
      final imageId = DateTime.now().toString();
      if (await  isDuplicateFPTPBarColor(barColor)) {
        return 'Barcolor is already taken';
      } else {
        await dbFederalPR.add({
          'partyName': partyName,
          'partyInfo': partyInfo,
          'barColor': barColor,
          'partyFull': partyFull,
          'imageUrl': imageUrl,
          'imageId': imageId,
          'votes': {
            'vote': 0,
            'userId': [],
          },
        });
        return 'Success';
      }
    } on FirebaseException catch (err) {
      return '$err';
    }
  }

  Stream<List<FederalPR>> getPRStream() {
    return dbFederalPR.snapshots().map((event) => getPRData(event));
  }

  Stream<List<FederalPR>> getSortedPRStream() {
    return dbFederalPR
        .orderBy('votes.vote', descending: true)
        .snapshots()
        .map((event) => getPRData(event));
  }


  List<FederalPR> getPRData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final json = e.data() as Map<String, dynamic>;
      return FederalPR(
        id: e.id,
        partyName: json['partyName'],
        partyInfo: json['partyInfo'],
        partyFull: json['partyFull'],
        imageUrl: json['imageUrl'],
        barColor: json['barColor'],
        imageId: json['imageId'],
        voteData: Vote.fromJson(json['votes']),
      );
    }).toList();
  }

  Future<String> updatePR(
      {required String partyName,
        required String partyFull,
      required String partyInfo,
      required String barColor,
      required String postId}) async {
    try {
      await dbFederalFPTP.doc(postId).update({
        'partyFull': partyFull,
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
          FirebaseStorage.instance.ref().child('federalPartyImage/$imageId');
      await ref.delete();
      await dbFederalFPTP.doc(postId).delete();
      return 'Success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<List<FederalPRStats>> getFederalPRtats() {
    return _firebaseFirestore.collection('federal pr').get().then(
            (querySnapshot) => querySnapshot.docs
            .asMap()
            .entries
            .map((entry) => FederalPRStats.fromSnapshot(entry.value, entry.key))
            .toList());
  }

  Future<bool> isDuplicatePRBarColor(String barColor) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('federal pr')
        .where('barColor', isEqualTo: barColor)
        .get();
    return query.docs.isNotEmpty;
  }
}
