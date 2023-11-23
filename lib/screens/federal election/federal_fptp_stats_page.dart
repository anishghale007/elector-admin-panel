import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/federalFPTP_stats_controller.dart';
import 'package:elector_admin_dashboard/controllers/federal_provider.dart';
import 'package:elector_admin_dashboard/controllers/ongoingElection_provider.dart';
import 'package:elector_admin_dashboard/models/federal_election.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FederalFPTPStatsPage extends StatefulWidget {
  const FederalFPTPStatsPage({super.key});

  @override
  State<FederalFPTPStatsPage> createState() => _FederalFPTPStatsPageState();
}

class _FederalFPTPStatsPageState extends State<FederalFPTPStatsPage> {
  String? totalUsers;
  String? totalVotes;
  String voteTurnOut = "";
  double? voterTurnout;

  Future<int> countUsersDocuments() async {
    QuerySnapshot myDoc =
        await FirebaseFirestore.instance.collection('users').get();
    List<DocumentSnapshot> myDocCount = myDoc.docs;
    totalUsers = myDocCount.length.toString();
    return myDocCount.length;
  }

  String count() {
    voterTurnout = int.parse(totalVotes!) / int.parse(totalUsers!) * 100;
    voteTurnOut = voterTurnout!.toStringAsFixed(2);
    return voteTurnOut;
  }

  final FederalFPTPStatsController federalFPTPStatsController =
      Get.put(FederalFPTPStatsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            padding: const EdgeInsets.all(24),
            child: Consumer(builder: (context, ref, child) {
              final sortedStream = ref.watch(fptpSortedProvider);
              final totalVoteStream = ref.watch(ongoingTotalVotesProvider);
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 40),
                  FutureBuilder(
                    future: federalFPTPStatsController.stats.value,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<FederalFPTPStats>> snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Expanded(
                            child: Container(
                              height: 300,
                              width: 1000,
                              padding: const EdgeInsets.all(10),
                              child: CustomBarChart(
                                federalFPTPStats: snapshot.data!,
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  FutureBuilder(
                    future: federalFPTPStatsController.stats.value,
                    builder: (BuildContext context,
                        AsyncSnapshot<List<FederalFPTPStats>> snapshot) {
                      if (snapshot.hasData) {
                        return SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Expanded(
                            child: Container(
                              height: 300,
                              width: 600,
                              padding: const EdgeInsets.all(10),
                              child: CustomPieChart(
                                federalFPTPStats: snapshot.data!,
                              ),
                            ),
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.red,
                          ),
                        );
                      }
                    },
                  ),
                  const SizedBox(height: 40),
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.purple[800],
                          ),
                          child: totalVoteStream.when(
                            data: (data) {
                              totalVotes = data.totalVote.toString();
                              return Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Total Vote Counts',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    data.totalVote.toString(),
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              );
                            },
                            error: (err, stack) => Text('$err'),
                            loading: () => const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 100,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue[800],
                          ),
                          child: FutureBuilder<int>(
                            future: countUsersDocuments(),
                            builder: (BuildContext context, snapshot) {
                              final count = snapshot.data;
                              if (snapshot.hasData) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'Total Users',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        count.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final vote = count();
                            setState(() {
                              voteTurnOut = vote;
                            });
                          },
                          child: Container(
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.green[800],
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Voter Turnout',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(height: 10),
                                  Text(
                                    '$voteTurnOut %',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 40),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: Text(
                        'Candidates Vote Count (Rank Wise)',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  sortedStream.when(
                    data: (data) {
                      return Container(
                        decoration: const BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: SizedBox(
                          width: double.maxFinite,
                          child: DataTable(
                            columnSpacing: 10,
                            dataRowMaxHeight: 80,
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Profile Picture',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Candidate Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Party Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Total Votes',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: List.generate(data.length, (index) {
                              final dat = data[index];
                              return DataRow(
                                cells: [
                                  DataCell(
                                    CircleAvatar(
                                      backgroundImage:
                                          NetworkImage(dat.imageUrl),
                                    ),
                                  ),
                                  DataCell(
                                    Text(dat.candidateName),
                                  ),
                                  DataCell(
                                    Text(dat.partyName),
                                  ),
                                  DataCell(
                                    Text(dat.voteData.vote.toString()),
                                  ),
                                ],
                              );
                            }),
                          ),
                        ),
                      );
                    },
                    error: (err, stack) => Text('$err'),
                    loading: () => const Center(
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class CustomBarChart extends StatelessWidget {
  const CustomBarChart({
    Key? key,
    required this.federalFPTPStats,
  }) : super(key: key);

  final List<FederalFPTPStats> federalFPTPStats;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<FederalFPTPStats, String>> series = [
      charts.Series(
        id: 'Federal FPTP',
        data: federalFPTPStats,
        domainFn: (series, _) => series.candidateName.toString(),
        measureFn: (series, _) => series.voteData.vote,
        colorFn: (series, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(series.barColor))),
      )
    ];
    return charts.BarChart(
      series,
      animate: true,
      animationDuration: const Duration(seconds: 3),
      behaviors: [
        charts.DatumLegend(
          entryTextStyle: const charts.TextStyleSpec(
              color: charts.MaterialPalette.black, fontSize: 12),
        ),
      ],
    );
  }
}

class CustomPieChart extends StatelessWidget {
  const CustomPieChart({
    Key? key,
    required this.federalFPTPStats,
  }) : super(key: key);

  final List<FederalFPTPStats> federalFPTPStats;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<FederalFPTPStats, String>> series = [
      charts.Series(
        id: 'Federal FPTP',
        data: federalFPTPStats,
        domainFn: (series, _) => series.candidateName.toString(),
        measureFn: (series, _) => series.voteData.vote,
        colorFn: (series, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(series.barColor))),
      )
    ];
    return charts.PieChart<String>(
      series,
      animate: true,
      animationDuration: const Duration(seconds: 3),
      behaviors: [
        charts.DatumLegend(
          entryTextStyle: const charts.TextStyleSpec(
              color: charts.MaterialPalette.black, fontSize: 12),
        ),
      ],
    );
  }
}
