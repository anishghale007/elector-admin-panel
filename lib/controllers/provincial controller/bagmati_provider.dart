import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/models/provincial_election.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final bagmatiProvider = Provider.autoDispose((ref) => BagmatiProvider());
final bagmatiFPTPProvider =
    StreamProvider.autoDispose((ref) => BagmatiProvider().getFPTPStream());
final bagmatiFptpSortedProvider = StreamProvider.autoDispose(
    (ref) => BagmatiProvider().getSortedFPTPStream());
final bagmatiPRProvider =
    StreamProvider.autoDispose((ref) => BagmatiProvider().getPRStream());

class BagmatiProvider {
  CollectionReference dbBagmatiFPTP =
      FirebaseFirestore.instance.collection('bagmati fptp');
  CollectionReference dbBagmatiPR =
      FirebaseFirestore.instance.collection('bagmati pr');
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
      isDuplicateFPTPBarColor(barColor);
      if (await isDuplicateFPTPBarColor(barColor)) {
        return 'Barcolor is already taken';
      } else {
        await dbBagmatiFPTP.add({
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
      }
    } on FirebaseException catch (err) {
      return '$err';
    }
  }

  Stream<List<ProvincialFPTP>> getFPTPStream() {
    return dbBagmatiFPTP.snapshots().map((event) => getFPTPData(event));
  }

  Stream<List<ProvincialFPTP>> getSortedFPTPStream() {
    return dbBagmatiFPTP
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
      await dbBagmatiFPTP.doc(postId).update({
        'candidateName': candidateName,
        'partyName': partyName,
        'candidateInfo': candidateInfo,
        'barColor': barColor,
      });
      return 'Success';
    } on FirebaseException {
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
      await dbBagmatiFPTP.doc(postId).delete();
      return 'Success';
    } on FirebaseException {
      return '';
    }
  }

  Future<bool> isDuplicateFPTPBarColor(String barColor) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('bagmati fptp')
        .where('barColor', isEqualTo: barColor)
        .get();
    return query.docs.isNotEmpty;
  }

  Future<List<ProvincialFPTPStats>> getProvincialFPTPStats() {
    return _firebaseFirestore.collection('bagmati fptp').get().then(
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
      if (await isDuplicateFPTPBarColor(barColor)) {
        return 'Barcolor is already taken';
      } else {
        await dbBagmatiPR.add({
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
      }
    } on FirebaseException catch (err) {
      return '$err';
    }
  }

  Stream<List<ProvincialPR>> getPRStream() {
    return dbBagmatiPR.snapshots().map((event) => getPRData(event));
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
      await dbBagmatiPR.doc(postId).update({
        'partyName': partyName,
        'partyInfo': partyInfo,
        'barColor': barColor,
      });
      return 'Success';
    } on FirebaseException {
      return '';
    }
  }

  Future<String> removePR(
      {required String postId, required String imageId}) async {
    try {
      final ref =
          FirebaseStorage.instance.ref().child('provincialPartyImage/$imageId');
      await ref.delete();
      await dbBagmatiPR.doc(postId).delete();
      return 'Success';
    } on FirebaseException {
      return '';
    }
  }

  Future<bool> isDuplicatePRBarColor(String barColor) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('bagmati pr')
        .where('barColor', isEqualTo: barColor)
        .get();
    return query.docs.isNotEmpty;
  }
}
