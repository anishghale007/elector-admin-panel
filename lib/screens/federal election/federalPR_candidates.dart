import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/federal_provider.dart';
import 'package:elector_admin_dashboard/screens/federal%20election/edit_FPTPCandidate_page.dart';
import 'package:elector_admin_dashboard/screens/federal%20election/edit_PRCandidate_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FederalPRCandidates extends StatelessWidget {
  Future<int> countFederalPRDocuments() async {
    QuerySnapshot myDoc =
        await FirebaseFirestore.instance.collection('federal pr').get();
    List<DocumentSnapshot> myDocCount = myDoc.docs;
    return myDocCount.length;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final federalPRStream = ref.watch(prProvider);
        return Scaffold(
          body: SingleChildScrollView(
            child: Center(
              child: Container(
                constraints: BoxConstraints(maxWidth: 1200),
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 100,
                          width: 300,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12),
                            child: Image.asset(
                              "assets/images/elector_logo2.png",
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Row(
                      children: [
                        Text(
                          "Federal PR Candidates",
                          style: GoogleFonts.roboto(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    FutureBuilder<int>(
                      future: countFederalPRDocuments(),
                      builder: (BuildContext context, snapshot) {
                        final count = snapshot.data;
                        if (snapshot.hasData) {
                          return Row(
                            children: [
                              Text(
                                "Total Parties: " + count.toString(),
                                style: TextStyle(
                                  color: Color(0xFFA4A6B3),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
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
                    SizedBox(
                      height: 40,
                    ),
                    federalPRStream.when(
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
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Party Full Name',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Party Short Form Name',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Bar Color',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Actions',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
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
                                      Text(dat.partyFull),
                                    ),
                                    DataCell(
                                      Text(dat.partyName),
                                    ),
                                    DataCell(
                                      Text(dat.barColor),
                                    ),
                                    DataCell(
                                      Row(
                                        children: [
                                          ElevatedButton(
                                            child: Text('Edit'),
                                            onPressed: () {
                                              Get.to(() => EditPRCandidatePage(dat));
                                            },
                                          ),
                                          SizedBox(width: 15),
                                          ElevatedButton(
                                            child: Text('Delete'),
                                            onPressed: () async {
                                              await ref
                                                  .read(federalProvider)
                                                  .removePR(
                                                    imageId: dat.imageId,
                                                    postId: dat.id,
                                                  );
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.red),
                                          ),
                                        ],
                                      ),
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
                    SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
