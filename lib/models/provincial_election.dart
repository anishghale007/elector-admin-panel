import 'package:cloud_firestore/cloud_firestore.dart';

class ProvincialFPTP {
  late String id;
  late String candidateName;
  late String candidateInfo;
  late String partyName;
  late String partyImageId;
  late String imageUrl;
  late String imageId;
  late String partyUrl;
  late String barColor;
  late Vote voteData;

  ProvincialFPTP({
    required this.id,
    required this.candidateName,
    required this.candidateInfo,
    required this.partyName,
    required this.partyUrl,
    required this.imageUrl,
    required this.barColor,
    required this.voteData,
    required this.partyImageId,
    required this.imageId,
  });
}

class ProvincialFPTPStats{
  final int index;
  final String candidateName;
  final Vote voteData;
  final String barColor;


  ProvincialFPTPStats({
    required this.candidateName,
    required this.voteData,
    required this.index,
    required this.barColor,
  });


  factory ProvincialFPTPStats.fromSnapshot(DocumentSnapshot snap, int index) {
    return ProvincialFPTPStats(
      index: index,
      candidateName: snap['candidateName'],
      barColor: snap['barColor'],
      voteData: Vote.fromJson(snap['votes']),
    );
  }

}

class ProvincialPR {
  late String id;
  late String partyName;
  late String partyInfo;
  late String imageUrl;
  late String imageId;
  late String barColor;
  late Vote voteData;


  ProvincialPR({
    required this.id,
    required this.partyName,
    required this.partyInfo,
    required this.imageUrl,
    required this.imageId,
    required this.barColor,
    required this.voteData,
  });
}



class Vote {
  late int vote;
  late List<String> userId;

  Vote({
    required this.vote,
    required this.userId,
  });

  factory Vote.fromJson(Map<String, dynamic> json) {
    return Vote(
      vote: json['vote'],
      userId:
          ((json['userId'] ?? []) as List).map((e) => (e as String)).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': this.userId,
      'like': this.vote,
    };
  }
}
