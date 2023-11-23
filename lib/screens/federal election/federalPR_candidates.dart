import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/federal_provider.dart';
import 'package:elector_admin_dashboard/screens/federal%20election/edit_PRCandidate_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FederalPRCandidates extends StatelessWidget {
  const FederalPRCandidates({super.key});

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
                constraints: const BoxConstraints(maxWidth: 1200),
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
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
                    const SizedBox(
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
                    const SizedBox(
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
                                "Total Parties: $count",
                                style: const TextStyle(
                                  color: Color(0xFFA4A6B3),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
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
                    const SizedBox(
                      height: 40,
                    ),
                    federalPRStream.when(
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
                              dataRowHeight: 80,
                              columns: const [
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
                                            child: const Text('Edit'),
                                            onPressed: () {
                                              Get.to(() =>
                                                  EditPRCandidatePage(dat));
                                            },
                                          ),
                                          const SizedBox(width: 15),
                                          ElevatedButton(
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
                                            child: const Text('Delete'),
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
                      loading: () => const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
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
