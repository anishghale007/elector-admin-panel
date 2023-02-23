import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/ongoingElection_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/bagmatiFPTP_stats_controller.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/bagmati_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/gandakiFPTP_stats_controller.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/gandaki_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/karnaliFPTP_stats_controller.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/karnali_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/lumbiniFPTP_stats_controller.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/lumbini_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/madheshFPTP_stats_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/madhesh_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/province1FPTP_stats_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/province1_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/sudurpaschimFPTP_stats_controller.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/sudurpaschim_provider.dart';
import 'package:elector_admin_dashboard/models/provincial_election.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';

class ProvincialFPTPStatsPage extends StatefulWidget {
  const ProvincialFPTPStatsPage({Key? key}) : super(key: key);

  @override
  State<ProvincialFPTPStatsPage> createState() =>
      _ProvincialFPTPStatsPageState();
}

class _ProvincialFPTPStatsPageState extends State<ProvincialFPTPStatsPage> {
  String _selectedProvince = "";
  var province = {
    'Province No.1',
    'Madhesh',
    'Bagmati',
    'Gandaki',
    'Lumbini',
    'Karnali',
    'Sudurpaschim',
  };

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
    print(voterTurnout);
    voterTurnout = int.parse(totalVotes!) / int.parse(totalUsers!) * 100;
    voteTurnOut = voterTurnout!.toStringAsFixed(2);
    return voteTurnOut;
  }

  final BagmatiFPTPStatsController bagmatiFPTPStatsController =
      Get.put(BagmatiFPTPStatsController());
  final Province1FPTPStatsController province1FPTPStatsController =
      Get.put(Province1FPTPStatsController());
  final GandakiFPTPStatsController gandakiFPTPStatsController =
      Get.put(GandakiFPTPStatsController());
  final MadheshFPTPStatsController madheshFPTPStatsController =
      Get.put(MadheshFPTPStatsController());
  final LumbiniFPTPStatsController lumbiniFPTPStatsController =
  Get.put(LumbiniFPTPStatsController());
  final KarnaliFPTPStatsController karnaliFPTPStatsController =
  Get.put(KarnaliFPTPStatsController());
  final SudurpaschimFPTPStatsController sudurpaschimFPTPStatsController =
  Get.put(SudurpaschimFPTPStatsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer(builder: (context, ref, child) {
        final bagmatiSortedStream = ref.watch(bagmatiFptpSortedProvider);
        final province1SortedStream = ref.watch(province1FptpSortedProvider);
        final gandakiSortedStream = ref.watch(gandakiFptpSortedProvider);
        final madheshSortedStream = ref.watch(madheshFptpSortedProvider);
        final lumbiniSortedStream = ref.watch(lumbiniFptpSortedProvider);
        final karnaliSortedStream = ref.watch(karnaliFptpSortedProvider);
        final sudurpaschimSortedStream = ref.watch(sudurpaschimFptpSortedProvider);
        final totalVoteStream = ref.watch(ongoingProvincialTotalVotesProvider);
        return SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 50),
              Center(
                child: Text(
                  'Please select the province that you wish to see the stats of',
                  style: kSubHeadingTextStyle,
                ),
              ),
              SizedBox(height: 50),
              Center(
                child: Container(
                  width: 400,
                  height: 58,
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: DropdownButtonFormField(
                      value: _selectedProvince.isNotEmpty
                          ? _selectedProvince
                          : null,
                      validator: (value) {
                        if (value == null) {
                          return 'Gender is required';
                        }
                      },
                      hint: Text(
                        "Select",
                      ),
                      decoration: InputDecoration(
                        fillColor: secondaryColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: secondaryColor),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(color: Colors.transparent),
                        ),
                      ),
                      items: province.map((String gender) {
                        return DropdownMenuItem(
                          child: Text(gender),
                          value: gender,
                        );
                      }).toList(),
                      onChanged: (newValue) {
                        setState(() {
                          _selectedProvince = "$newValue";
                          print(_selectedProvince);
                        });
                      }),
                ),
              ),
              SizedBox(height: 50),
              /*
              PROVINCE NO 1
              */
              if (_selectedProvince == "Province No.1")
                FutureBuilder(
                  future: province1FPTPStatsController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            height: 300,
                            width: 1000,
                            padding: EdgeInsets.all(10),
                            child: CustomBarChart(
                              fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Province No.1") SizedBox(height: 40),
              if (_selectedProvince == "Province No.1")
                FutureBuilder(
                  future: province1FPTPStatsController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            height: 300,
                            width: 600,
                            padding: EdgeInsets.all(10),
                            child: CustomPieChart(
                              fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Province No.1") SizedBox(height: 40),
              if (_selectedProvince == "Province No.1")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
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
                                  Text(
                                    'Total Vote Counts',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    data.totalVote.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                      SizedBox(width: 10),
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
                                            fontSize: 20,
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
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final vote = await count();
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
                                  Text(
                                    'Voter Turnout',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    voteTurnOut + ' %',
                                    style: TextStyle(
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
                ),
              if (_selectedProvince == "Province No.1") SizedBox(height: 40),
              if (_selectedProvince == "Province No.1")
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
              if (_selectedProvince == "Province No.1") SizedBox(height: 40),
              if (_selectedProvince == "Province No.1")
                province1SortedStream.when(
                  data: (data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
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
              if (_selectedProvince == "Province No.1") SizedBox(height: 40),
              /*
              MADHESH
              */
              if (_selectedProvince == "Madhesh")
                FutureBuilder(
                  future: madheshFPTPStatsController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            height: 300,
                            width: 1000,
                            padding: EdgeInsets.all(10),
                            child: CustomBarChart(
                              fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Madhesh") SizedBox(height: 40),
              if (_selectedProvince == "Madhesh")
                FutureBuilder(
                  future: madheshFPTPStatsController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            height: 300,
                            width: 600,
                            padding: EdgeInsets.all(10),
                            child: CustomPieChart(
                              fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Madhesh") SizedBox(height: 40),
              if (_selectedProvince == "Madhesh")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
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
                                  Text(
                                    'Total Vote Counts',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    data.totalVote.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                      SizedBox(width: 10),
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
                                            fontSize: 20,
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
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final vote = await count();
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
                                  Text(
                                    'Voter Turnout',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    voteTurnOut + ' %',
                                    style: TextStyle(
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
                ),
              if (_selectedProvince == "Madhesh") SizedBox(height: 40),
              if (_selectedProvince == "Madhesh")
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
              if (_selectedProvince == "Madhesh") SizedBox(height: 40),
              if (_selectedProvince == "Madhesh")
                madheshSortedStream.when(
                  data: (data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
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
              if (_selectedProvince == "Madhesh") SizedBox(height: 40),
              /*
                  BAGMATI
                  */
              if (_selectedProvince == "Bagmati")
                FutureBuilder(
                  future: bagmatiFPTPStatsController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            height: 300,
                            width: 1000,
                            padding: EdgeInsets.all(10),
                            child: CustomBarChart(
                              fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Bagmati") SizedBox(height: 40),
              if (_selectedProvince == "Bagmati")
                FutureBuilder(
                  future: bagmatiFPTPStatsController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            height: 300,
                            width: 600,
                            padding: EdgeInsets.all(10),
                            child: CustomPieChart(
                              fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Bagmati") SizedBox(height: 40),
              if (_selectedProvince == "Bagmati")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
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
                                  Text(
                                    'Total Vote Counts',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    data.totalVote.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                      SizedBox(width: 10),
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
                                            fontSize: 20,
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
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final vote = await count();
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
                                  Text(
                                    'Voter Turnout',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    voteTurnOut + ' %',
                                    style: TextStyle(
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
                ),
              if (_selectedProvince == "Bagmati") SizedBox(height: 40),
              if (_selectedProvince == "Bagmati")
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
              if (_selectedProvince == "Bagmati") SizedBox(height: 40),
              if (_selectedProvince == "Bagmati")
                bagmatiSortedStream.when(
                  data: (data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
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
              if (_selectedProvince == "Bagmati") SizedBox(height: 40),
              /*
             GANDAKI
             */
              if (_selectedProvince == "Gandaki")
                FutureBuilder(
                  future: gandakiFPTPStatsController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            height: 300,
                            width: 1000,
                            padding: EdgeInsets.all(10),
                            child: CustomBarChart(
                              fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Gandaki") SizedBox(height: 40),
              if (_selectedProvince == "Gandaki")
                FutureBuilder(
                  future: gandakiFPTPStatsController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            height: 300,
                            width: 600,
                            padding: EdgeInsets.all(10),
                            child: CustomPieChart(
                              fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Gandaki") SizedBox(height: 40),
              if (_selectedProvince == "Gandaki")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
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
                                  Text(
                                    'Total Vote Counts',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    data.totalVote.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                      SizedBox(width: 10),
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
                                            fontSize: 20,
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
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final vote = await count();
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
                                  Text(
                                    'Voter Turnout',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    voteTurnOut + ' %',
                                    style: TextStyle(
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
                ),
              if (_selectedProvince == "Gandaki") SizedBox(height: 40),
              if (_selectedProvince == "Gandaki")
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
              if (_selectedProvince == "Gandaki") SizedBox(height: 40),
              if (_selectedProvince == "Gandaki")
                gandakiSortedStream.when(
                  data: (data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
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
              if (_selectedProvince == "Gandaki") SizedBox(height: 40),
              /*
                LUMBINI
                * */
              if (_selectedProvince == "Lumbini")
                FutureBuilder(
                  future: lumbiniFPTPStatsController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            height: 300,
                            width: 1000,
                            padding: EdgeInsets.all(10),
                            child: CustomBarChart(
                              fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Lumbini") SizedBox(height: 40),
              if (_selectedProvince == "Lumbini")
                FutureBuilder(
                  future: lumbiniFPTPStatsController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            height: 300,
                            width: 600,
                            padding: EdgeInsets.all(10),
                            child: CustomPieChart(
                              fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Lumbini") SizedBox(height: 40),
              if (_selectedProvince == "Lumbini")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
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
                                  Text(
                                    'Total Vote Counts',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    data.totalVote.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                      SizedBox(width: 10),
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
                                            fontSize: 20,
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
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final vote = await count();
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
                                  Text(
                                    'Voter Turnout',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    voteTurnOut + ' %',
                                    style: TextStyle(
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
                ),
              if (_selectedProvince == "Lumbini") SizedBox(height: 40),
              if (_selectedProvince == "Lumbini")
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
              if (_selectedProvince == "Lumbini") SizedBox(height: 40),
              if (_selectedProvince == "Lumbini")
                lumbiniSortedStream.when(
                  data: (data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
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
              if (_selectedProvince == "Lumbini") SizedBox(height: 40),
                /*
                * KARNALI
                * */
                if (_selectedProvince == "Karnali")
                    FutureBuilder(
                      future: karnaliFPTPStatsController.stats.value,
                      builder: (BuildContext context,
                          AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                        if (snapshot.hasData) {
                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Expanded(
                              child: Container(
                                height: 300,
                                width: 1000,
                                padding: EdgeInsets.all(10),
                                child: CustomBarChart(
                                  fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Karnali") SizedBox(height: 40),
              if (_selectedProvince == "Karnali")
                FutureBuilder(
                  future: karnaliFPTPStatsController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            height: 300,
                            width: 600,
                            padding: EdgeInsets.all(10),
                            child: CustomPieChart(
                              fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Karnali") SizedBox(height: 40),
              if (_selectedProvince == "Karnali")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
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
                                  Text(
                                    'Total Vote Counts',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    data.totalVote.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                      SizedBox(width: 10),
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
                                            fontSize: 20,
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
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final vote = await count();
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
                                  Text(
                                    'Voter Turnout',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    voteTurnOut + ' %',
                                    style: TextStyle(
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
                ),
              if (_selectedProvince == "Karnali") SizedBox(height: 40),
              if (_selectedProvince == "Karnali")
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
              if (_selectedProvince == "Karnali") SizedBox(height: 40),
              if (_selectedProvince == "Karnali")
                karnaliSortedStream.when(
                  data: (data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
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
              if (_selectedProvince == "Karnali") SizedBox(height: 40),
                  /*
                  * SUDURPASCHIM
                  * */
                  if (_selectedProvince == "Sudurpaschim")
                      FutureBuilder(
                        future: sudurpaschimFPTPStatsController.stats.value,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                          if (snapshot.hasData) {
                            return SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Expanded(
                                child: Container(
                                  height: 300,
                                  width: 1000,
                                  padding: EdgeInsets.all(10),
                                  child: CustomBarChart(
                                    fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Sudurpaschim") SizedBox(height: 40),
              if (_selectedProvince == "Sudurpaschim")
                FutureBuilder(
                  future: sudurpaschimFPTPStatsController.stats.value,
                  builder: (BuildContext context,
                      AsyncSnapshot<List<ProvincialFPTPStats>> snapshot) {
                    if (snapshot.hasData) {
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Expanded(
                          child: Container(
                            height: 300,
                            width: 600,
                            padding: EdgeInsets.all(10),
                            child: CustomPieChart(
                              fptpStats: snapshot.data!,
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
              if (_selectedProvince == "Sudurpaschim") SizedBox(height: 40),
              if (_selectedProvince == "Sudurpaschim")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Row(
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
                                  Text(
                                    'Total Vote Counts',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    data.totalVote.toString(),
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
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
                      SizedBox(width: 10),
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
                                            fontSize: 20,
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
                      SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () async {
                            final vote = await count();
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
                                  Text(
                                    'Voter Turnout',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    voteTurnOut + ' %',
                                    style: TextStyle(
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
                ),
              if (_selectedProvince == "Sudurpaschim") SizedBox(height: 40),
              if (_selectedProvince == "Sudurpaschim")
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
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
              if (_selectedProvince == "Sudurpaschim") SizedBox(height: 40),
              if (_selectedProvince == "Sudurpaschim")
                sudurpaschimSortedStream.when(
                  data: (data) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30),
                      child: Container(
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
              if (_selectedProvince == "Sudurpaschim") SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }
}

class CustomBarChart extends StatelessWidget {
  const CustomBarChart({
    Key? key,
    required this.fptpStats,
  }) : super(key: key);

  final List<ProvincialFPTPStats> fptpStats;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ProvincialFPTPStats, String>> series = [
      charts.Series(
        id: 'Bagmati FPTP',
        data: fptpStats,
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

class CustomPieChart extends StatelessWidget {
  const CustomPieChart({
    Key? key,
    required this.fptpStats,
  }) : super(key: key);

  final List<ProvincialFPTPStats> fptpStats;

  @override
  Widget build(BuildContext context) {
    List<charts.Series<ProvincialFPTPStats, String>> series = [
      charts.Series(
        id: 'Bagmati FPTP',
        data: fptpStats,
        domainFn: (series, _) => series.candidateName.toString(),
        measureFn: (series, _) => series.voteData.vote,
        colorFn: (series, _) =>
            charts.ColorUtil.fromDartColor(Color(int.parse(series.barColor))),
      )
    ];
    return charts.PieChart<String>(
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
