class OngoingElection {
  late String id;
  late String electionType;
  late String candidates;
  late String startDate;
  late String endDate;
  late String startTime;
  late String endTime;
  late bool canVote;
  late int totalVote;
  late List<String> voterId;

  OngoingElection({
    required this.id,
    required this.electionType,
    required this.candidates,
    required this.startDate,
    required this.endDate,
    required this.startTime,
    required this.endTime,
    required this.canVote,
    required this.totalVote,
    required this.voterId,
  });
}

class OngoingElectionSingle {
  late String electionType;
  late String candidates;
  late String startDate;
  late String startTime;
  late String endDate;
  late String endTime;
  late int totalVote;
  late bool canVote;
  late List<String> voterId;

  OngoingElectionSingle({
    required this.electionType,
    required this.candidates,
    required this.startDate,
    required this.startTime,
    required this.endDate,
    required this.endTime,
    required this.voterId,
    required this.canVote,
    required this.totalVote,
  });

  factory OngoingElectionSingle.fromJson(Map<String, dynamic> json) {
    return OngoingElectionSingle(
      canVote: json['canVote'],
      startTime: json['startTime'],
      endTime: json['endTime'],
      startDate: json['startDate'],
      endDate: json['endDate'],
      voterId:
          ((json['userId'] ?? []) as List).map((e) => (e as String)).toList(),
      electionType: json['electionType'],
      candidates: json['candidates'],
      totalVote: json['totalVote'],
    );
  }
}
