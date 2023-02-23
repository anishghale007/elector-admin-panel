import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final voterIDProvider = Provider.autoDispose((ref) => VoterIDProvider());

class VoterIDProvider {
  CollectionReference dbElectoralRoll =
      FirebaseFirestore.instance.collection('electoral roll');

  Future<String> addVoterID({required String voterId}) async {
    try {
      isDuplicateVoterId(voterId);
      if (await isDuplicateVoterId(voterId)) {
        return 'Voter ID already exists';
      } else {
        await dbElectoralRoll.doc('electoralRoll').update({
          'totalVoterID': FieldValue.increment(1),
          'Voter ID': FieldValue.arrayUnion([voterId]),
        });
        return 'Success';
      }
    } on FirebaseException catch (err) {
      return '${err.message}';
    }
  }

  Future<String> deleteVoterID({required String voterId}) async {
    try{
      isNotExistentVoterId(voterId);
      if(await isNotExistentVoterId(voterId)) {
        return 'Voter ID does not exist';
      } else {
        await dbElectoralRoll.doc('electoralRoll').update({
          'Voter ID': FieldValue.arrayRemove([voterId]),
          'totalVoterID': FieldValue.increment(-1),
        });
        return 'Success';
      }
    } on FirebaseException catch (err){
      return '${err.message}';
    }
  }

  Future<bool> isDuplicateVoterId(String voterId) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('electoralRoll')
        .where('Voter ID', arrayContains: voterId)
        .get();
    return query.docs.isEmpty;
  }

  Future<bool> isNotExistentVoterId(String voterId) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('electoral roll')
        .where('Voter ID', arrayContains: voterId)
        .get();
    return query.docs.isEmpty;
  }

}
