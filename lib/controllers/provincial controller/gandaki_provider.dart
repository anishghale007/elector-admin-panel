import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/models/provincial_election.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final gandakiProvider = Provider.autoDispose((ref) => GandakiProvider());
final gandakiFPTPProvider =
    StreamProvider.autoDispose((ref) => GandakiProvider().getFPTPStream());
final gandakiFptpSortedProvider = StreamProvider.autoDispose(
        (ref) => GandakiProvider().getSortedFPTPStream());
final gandakiPRProvider =
    StreamProvider.autoDispose((ref) => GandakiProvider().getPRStream());

class GandakiProvider {
  CollectionReference dbGandakiFPTP =
      FirebaseFirestore.instance.collection('gandaki fptp');
  CollectionReference dbGandakiPR =
  FirebaseFirestore.instance.collection('gandaki pr');
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

  Future<String> addFPTPPost({
    required String candidateName,
    required String partyName,
    required String candidateInfo,
    required String barColor,
    required String imageUrl,
    required String partyUrl,
  }) async {
    try {
      final imageId = DateTime.now().toString();
      final partyImageId = DateTime.now().toString();
      await dbGandakiFPTP.add({
        'candidateName': candidateName,
        'partyName': partyName,
        'candidateInfo': candidateInfo,
        'barColor': barColor,
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
    } on FirebaseException catch (err) {
      return '$err';
    }
  }

  Stream<List<ProvincialFPTP>> getFPTPStream() {
    return dbGandakiFPTP.snapshots().map((event) => getFPTPData(event));
  }

  Stream<List<ProvincialFPTP>> getSortedFPTPStream() {
    return dbGandakiFPTP
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
      await dbGandakiFPTP.doc(postId).update({
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
      await dbGandakiFPTP.doc(postId).delete();
      return 'Success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<List<ProvincialFPTPStats>> getProvincialFPTPStats() {
    return _firebaseFirestore.collection('gandaki fptp').get().then(
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
      await dbGandakiPR.add({
        'partyName': partyName,
        'partyInfo': partyInfo,
        'imageUrl': imageUrl,
        'imageId': imageId,
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
    return dbGandakiPR.snapshots().map((event) => getPRData(event));
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
      await dbGandakiPR.doc(postId).update({
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
      await dbGandakiPR.doc(postId).delete();
      return 'Success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }
}
