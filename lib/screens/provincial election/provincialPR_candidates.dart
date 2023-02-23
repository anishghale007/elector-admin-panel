import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/bagmati_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/gandaki_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/karnali_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/lumbini_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/madhesh_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/province1_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/sudurpaschim_provider.dart';
import 'package:elector_admin_dashboard/screens/provincial%20election/edit_ProvincialFPTP_candidates.dart';
import 'package:elector_admin_dashboard/screens/provincial%20election/edit_ProvincialPR_candidates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProvincialPRCandidates extends StatelessWidget {

  final String province;
  ProvincialPRCandidates({required this.province});


  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final bagmatiPRStream = ref.watch(bagmatiPRProvider);
        final gandakiPRStream = ref.watch(gandakiPRProvider);
        final karnaliPRStream = ref.watch(karnaliPRProvider);
        final lumbiniPRStream = ref.watch(lumbiniPRProvider);
        final madheshPRStream = ref.watch(madheshPRProvider);
        final provincial1PRStream = ref.watch(province1PRProvider);
        final sudurpaschimPRStream = ref.watch(sudurpaschimPRProvider);
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
                          province + " PR Candidates",
                          style: GoogleFonts.roboto(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    if (province == "Province 1")
                      provincial1PRStream.when(
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
                                                Get.to(() => EditProvincialPRPage(
                                                    dat, "Province 1"));
                                              },
                                            ),
                                            SizedBox(width: 15),
                                            ElevatedButton(
                                              child: Text('Delete'),
                                              onPressed: () async {
                                                await ref
                                                    .read(province1Provider)
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
                    if (province == "Bagmati")
                      bagmatiPRStream.when(
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
                                                Get.to(() => EditProvincialPRPage(
                                                    dat, "Bagmati"));
                                              },
                                            ),
                                            SizedBox(width: 15),
                                            ElevatedButton(
                                              child: Text('Delete'),
                                              onPressed: () async {
                                                await ref
                                                    .read(bagmatiProvider)
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
                    if (province == "Madhesh")
                      madheshPRStream.when(
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
                                                Get.to(() => EditProvincialPRPage(
                                                    dat, "Madhesh"));
                                              },
                                            ),
                                            SizedBox(width: 15),
                                            ElevatedButton(
                                              child: Text('Delete'),
                                              onPressed: () async {
                                                await ref
                                                    .read(madheshProvider)
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
                    if (province == "Gandaki")
                      gandakiPRStream.when(
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
                                                Get.to(() => EditProvincialPRPage(
                                                    dat, "Gandaki"));
                                              },
                                            ),
                                            SizedBox(width: 15),
                                            ElevatedButton(
                                              child: Text('Delete'),
                                              onPressed: () async {
                                                await ref
                                                    .read(gandakiProvider)
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
                    if (province == "Sudurpashchim")
                      sudurpaschimPRStream.when(
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
                                                Get.to(() => EditProvincialPRPage(
                                                    dat, "Sudurpaschim"));
                                              },
                                            ),
                                            SizedBox(width: 15),
                                            ElevatedButton(
                                              child: Text('Delete'),
                                              onPressed: () async {
                                                await ref
                                                    .read(sudurpaschimProvider)
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
                    if (province == "Lumbini")
                      lumbiniPRStream.when(
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
                                                Get.to(() => EditProvincialPRPage(
                                                    dat, "Lumbini"));
                                              },
                                            ),
                                            SizedBox(width: 15),
                                            ElevatedButton(
                                              child: Text('Delete'),
                                              onPressed: () async {
                                                await ref
                                                    .read(lumbiniProvider)
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
                    if (province == "Karnali")
                      karnaliPRStream.when(
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
                                                Get.to(() => EditProvincialPRPage(
                                                    dat, "Karnali"));
                                              },
                                            ),
                                            SizedBox(width: 15),
                                            ElevatedButton(
                                              child: Text('Delete'),
                                              onPressed: () async {
                                                await ref
                                                    .read(karnaliProvider)
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
