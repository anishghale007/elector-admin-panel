import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/models/upcoming_election.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final upcomingProvider =
    Provider.autoDispose((ref) => UpcomingElectionProvider());
final upcomingElectionProvider =
    StreamProvider.autoDispose((ref) => UpcomingElectionProvider().getData());

class UpcomingElectionProvider {
  CollectionReference dbUpcomingElection =
      FirebaseFirestore.instance.collection('upcoming election');

  Future<String> addUpcomingElectionPost({
    required String electionType,
    required String startDate,
    required String startTime,
    required String month,
    required String day,
  }) async {
    try {
      await dbUpcomingElection.add({
        'electionType': electionType,
        'startDate': startDate,
        'startTime': startTime,
        'month': month,
        'day': day,
      });
      return 'Success';
    } on FirebaseException catch (err) {
      return '$err';
    }
  }

  List<UpcomingElection> getUpcomingElectionData(QuerySnapshot querySnapshot) {
    return querySnapshot.docs.map((e) {
      final json = e.data() as Map<String, dynamic>;
      return UpcomingElection(
        id: e.id,
        day: json['day'],
        month: json['month'],
        electionType: json['electionType'],
        startDate: json['startDate'],
        startTime: json['startTime'],
      );
    }).toList();
  }

  Stream<List<UpcomingElection>> getData() {
    return dbUpcomingElection
        .snapshots()
        .map((event) => getUpcomingElectionData(event));
  }

  Future<String> postUpdate(
      {required String electionType,
      required String startDate,
      required String startTime,
      required String month,
      required String day,
      required String postId}) async {
    try {
      await dbUpcomingElection.doc(postId).update({
        'electionType': electionType,
        'startDate': startDate,
        'startTime': startTime,
        'month': month,
        'day': day,
      });
      return 'Success';
    } on FirebaseException {
      return '';
    }
  }

  Future<String> removeUpcomingElection({required String postId}) async {
    try {
      await dbUpcomingElection.doc(postId).delete();
      return 'Success';
    } on FirebaseException {
      return '';
    }
  }
}
