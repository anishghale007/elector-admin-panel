import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/models/ongoing_election.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ongoingProvider =
    Provider.autoDispose((ref) => OngoingElectionProvider());
final ongoingElectionProvider =
    StreamProvider.autoDispose((ref) => OngoingElectionProvider().getData());
final ongoingTotalVotesProvider =
StreamProvider.autoDispose((ref) => OngoingElectionProvider().getTotalVotes());
final ongoingProvincialTotalVotesProvider =
StreamProvider.autoDispose((ref) => OngoingElectionProvider().getProvincialTotalVotes());

class OngoingElectionProvider {
  CollectionReference dbOngoingElection =
      FirebaseFirestore.instance.collection('ongoing election');

  Future<String> addOngoingElectionPost({
    required String electionType,
    required String candidates,
    required String startDate,
    required String endDate,
    required String startTime,
    required String endTime,
  }) async {
    try {
      await dbOngoingElection.add({
        'electionType': electionType,
        'candidates': candidates,
        'startDate': startDate,
        'endDate': endDate,
        'startTime': startTime,
        'endTime': endTime,
        'canVote': false,
        'totalVote': 0,
        'userId': [],
      });
      return 'Success';
    } on FirebaseException catch (err) {
      return '$err';
    }
  }

  List<OngoingElection> getOngoingElectionData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final json = e.data() as Map<String, dynamic>;
      return OngoingElection(
        id: e.id,
        electionType: json['electionType'],
        candidates: json['candidates'],
        startDate: json['startDate'],
        endDate: json['endDate'],
        startTime: json['startTime'],
        endTime: json['endTime'],
        canVote: json['canVote'],
        totalVote: json['totalVote'],
        voterId: ((json['voterID'] ?? []) as List)
            .map((e) => (e as String))
            .toList(),
      );
    }).toList();
  }

  Stream<List<OngoingElection>> getData() {
    return dbOngoingElection
        .snapshots()
        .map((event) => getOngoingElectionData(event));
  }

  Future<String> postUpdate(
      {required String electionType,
      required String candidates,
      required String startDate,
      required String endDate,
      required String startTime,
      required String endTime,
      required String postId}) async {
    try {
      await dbOngoingElection.doc(postId).update({
        'electionType': electionType,
        'candidates': candidates,
        'startDate': startDate,
        'endDate': endDate,
        'startTime': startTime,
        'endTime': endTime,
      });
      return 'Success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<String> removeOngoingElection({required String postId}) async {
    try {
      await dbOngoingElection.doc(postId).delete();
      return 'Success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<String> startElection(
      {required String postId, required bool canVote}) async {
    try {
      await dbOngoingElection.doc(postId).update({
        'canVote': canVote,
      });
      return 'Success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  Future<String> endElection(
      {required String postId, required bool canVote}) async {
    try {
      await dbOngoingElection.doc(postId).update({
        'canVote': canVote,
      });
      return 'Success';
    } on FirebaseException catch (err) {
      print(err);
      return '';
    }
  }

  OngoingElectionSingle ongoingElection(QuerySnapshot querySnapshot) {
    final singleData = querySnapshot.docs[0].data() as Map<String, dynamic>;
    return OngoingElectionSingle.fromJson(singleData);
  }

  Stream<OngoingElectionSingle> getTotalVotes() {
    final totalVote = dbOngoingElection.where('electionType', isEqualTo: "Federal Election").snapshots();
    return totalVote.map((event) => ongoingElection(event));
  }

  Stream<OngoingElectionSingle> getProvincialTotalVotes() {
    final totalVote = dbOngoingElection.where('electionType', isEqualTo: "Provincial Election").snapshots();
    return totalVote.map((event) => ongoingElection(event));
  }
}
