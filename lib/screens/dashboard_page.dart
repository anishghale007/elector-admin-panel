import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/federalFPTP_stats_controller.dart';
import 'package:elector_admin_dashboard/controllers/federal_provider.dart';
import 'package:elector_admin_dashboard/models/federal_election.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';

class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<int> countUsersDocuments() async {
    QuerySnapshot myDoc =
        await FirebaseFirestore.instance.collection('users').get();
    List<DocumentSnapshot> myDocCount = myDoc.docs;
    return myDocCount.length;
  }

  Future<int> countOngoingDocuments() async {
    QuerySnapshot myDoc =
        await FirebaseFirestore.instance.collection('ongoing election').get();
    List<DocumentSnapshot> myDocCount = myDoc.docs;
    return myDocCount.length;
  }

  final FederalFPTPStatsController federalFPTPStatsController =
  Get.put(FederalFPTPStatsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Consumer(builder: (context, ref, child) {
          final federalFPTPStream = ref.watch(fptpProvider);
          final federalPRStream = ref.watch(prProvider);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.deepPurple[800],
                        ),
                        child: FutureBuilder<int>(
                          future: countUsersDocuments(),
                          builder: (BuildContext context, snapshot) {
                            final count = snapshot.data;
                            if (snapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Users',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      count.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.orangeAccent[700],
                        ),
                        child: StreamBuilder<
                            DocumentSnapshot<Map<String, dynamic>>>(
                          stream: FirebaseFirestore.instance
                              .collection('electoral roll')
                              .doc('electoralRoll')
                              .snapshots(),
                          builder: (_, snapshot) {
                            if (snapshot.hasData) {
                              var output = snapshot.data!.data();
                              var value = output!['totalVoterID'];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Total Registered Voter ID',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      value.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                    SizedBox(width: 25),
                    Expanded(
                      child: Container(
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.lightBlueAccent[700],
                        ),
                        child: FutureBuilder<int>(
                          future: countOngoingDocuments(),
                          builder: (BuildContext context, snapshot) {
                            final count = snapshot.data;
                            if (snapshot.hasData) {
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Ongoing Election',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      count.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 35,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              );
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 50),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 500,
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          children: [
                            federalFPTPStream.when(
                              data: (data) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: secondaryColor,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                  ),
                                  child: SizedBox(
                                    width: double.maxFinite,
                                    child: DataTable(
                                      columnSpacing: 10,
                                      dataRowHeight: 80,
                                      columns: [
                                        DataColumn(
                                          label: Text(
                                            'Profile Picture',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Candidate Name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Party Name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ],
                                      rows: List.generate(
                                          data.length < 5 ? data.length : 5,
                                          (index) {
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
                                              onTap: () {
                                                print(dat.candidateName);
                                              },
                                            ),
                                            DataCell(
                                              Text(dat.partyName),
                                            ),
                                          ],
                                        );
                                      }),
                                    ),
                                  ),
                                );
                              },
                              error: (err, stack) => Text('$err'),
                              loading: () => Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 30),
                    Expanded(
                      child: Container(
                        height: 500,
                        decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(20)),
                        child: federalPRStream.when(
                          data: (data) {
                            return Container(
                              decoration: BoxDecoration(
                                color: secondaryColor,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                              ),
                              child: SizedBox(
                                width: double.maxFinite,
                                child: DataTable(
                                  columnSpacing: 10,
                                  dataRowHeight: 80,
                                  columns: [
                                    DataColumn(
                                      label: Text(
                                        'Party Picture',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Party Full Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Party Short Form Name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                  rows: List.generate(
                                      data.length < 5 ? data.length : 5,
                                      (index) {
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
                                          Text(dat.partyFull),
                                        ),
                                        DataCell(
                                          Text(dat.partyName),
                                        ),
                                      ],
                                    );
                                  }),
                                ),
                              ),
                            );
                          },
                          error: (err, stack) => Text('$err'),
                          loading: () => Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
                  ],
                ),
                SizedBox(height: 50),
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
                            padding: EdgeInsets.all(10),
                            child: CustomBarChart(
                              federalFPTPStats: snapshot.data!,
                            ),
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Text('${snapshot.error}');
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Colors.red,
                        ),
                      );
                    }
                  },
                ),
                SizedBox(height: 50),
              ],
            ),
          );
        }),
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
      animationDuration: Duration(seconds: 3),
      behaviors: [
        new charts.DatumLegend(
          entryTextStyle: charts.TextStyleSpec(
              color: charts.MaterialPalette.black, fontSize: 12),
        ),
      ],
    );
  }
}
