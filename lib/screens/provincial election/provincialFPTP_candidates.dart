import 'package:elector_admin_dashboard/constants.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/bagmati_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/gandaki_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/karnali_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/lumbini_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/madhesh_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/province1_provider.dart';
import 'package:elector_admin_dashboard/controllers/provincial%20controller/sudurpaschim_provider.dart';
import 'package:elector_admin_dashboard/screens/provincial%20election/edit_ProvincialFPTP_candidates.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProvincialFPTPCandidates extends StatelessWidget {
  final String province;
  ProvincialFPTPCandidates({required this.province});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final province1FPTPStream = ref.watch(province1FPTPProvider);
        final gandakiFPTPStream = ref.watch(gandakiFPTPProvider);
        final karnaliFPTPStream = ref.watch(karnaliFPTPProvider);
        final lumbiniFPTPStream = ref.watch(lumbiniFPTPProvider);
        final sudurpaschimFPTPStream = ref.watch(sudurpaschimFPTPProvider);
        final madheshFPTPStream = ref.watch(madheshFPTPProvider);
        final bagmatiFPTPStream = ref.watch(bagmatiFPTPProvider);
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
                          province + " FPTP Candidates",
                          style: GoogleFonts.roboto(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 40,
                    ),
                    if (province == "Province 1")
                      province1FPTPStream.when(
                        data: (data) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: secondaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                  DataColumn(
                                    label: Text(
                                      'Bar Color',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Actions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                        onTap: () {},
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
                                                    EditProvincialFPTPPage(
                                                        dat, "Province 1"));
                                              },
                                            ),
                                            const SizedBox(width: 15),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await ref
                                                    .read(province1Provider)
                                                    .removeFPTP(
                                                      postId: dat.id,
                                                      imageId: dat.imageId,
                                                      partyImageId:
                                                          dat.partyImageId,
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
                    if (province == "Bagmati")
                      bagmatiFPTPStream.when(
                        data: (data) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: secondaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                  DataColumn(
                                    label: Text(
                                      'Bar Color',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Actions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                        onTap: () {},
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
                                                    EditProvincialFPTPPage(
                                                        dat, "Bagmati"));
                                              },
                                            ),
                                            const SizedBox(width: 15),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await ref
                                                    .read(bagmatiProvider)
                                                    .removeFPTP(
                                                      postId: dat.id,
                                                      imageId: dat.imageId,
                                                      partyImageId:
                                                          dat.partyImageId,
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
                    if (province == "Madhesh")
                      madheshFPTPStream.when(
                        data: (data) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: secondaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                  DataColumn(
                                    label: Text(
                                      'Bar Color',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Actions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                        onTap: () {},
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
                                                    EditProvincialFPTPPage(
                                                        dat, "Madhesh"));
                                              },
                                            ),
                                            const SizedBox(width: 15),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await ref
                                                    .read(madheshProvider)
                                                    .removeFPTP(
                                                      postId: dat.id,
                                                      imageId: dat.imageId,
                                                      partyImageId:
                                                          dat.partyImageId,
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
                    if (province == "Gandaki")
                      gandakiFPTPStream.when(
                        data: (data) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: secondaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                  DataColumn(
                                    label: Text(
                                      'Bar Color',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Actions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                        onTap: () {},
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
                                                    EditProvincialFPTPPage(
                                                        dat, "Gandaki"));
                                              },
                                            ),
                                            const SizedBox(width: 15),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await ref
                                                    .read(gandakiProvider)
                                                    .removeFPTP(
                                                      postId: dat.id,
                                                      imageId: dat.imageId,
                                                      partyImageId:
                                                          dat.partyImageId,
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
                    if (province == "Sudurpashchim")
                      sudurpaschimFPTPStream.when(
                        data: (data) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: secondaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                  DataColumn(
                                    label: Text(
                                      'Bar Color',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Actions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                        onTap: () {},
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
                                                    EditProvincialFPTPPage(
                                                        dat, "Sudurpaschim"));
                                              },
                                            ),
                                            const SizedBox(width: 15),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await ref
                                                    .read(sudurpaschimProvider)
                                                    .removeFPTP(
                                                      postId: dat.id,
                                                      imageId: dat.imageId,
                                                      partyImageId:
                                                          dat.partyImageId,
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
                    if (province == "Lumbini")
                      lumbiniFPTPStream.when(
                        data: (data) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: secondaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                  DataColumn(
                                    label: Text(
                                      'Bar Color',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Actions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                        onTap: () {},
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
                                                    EditProvincialFPTPPage(
                                                        dat, "Lumbini"));
                                              },
                                            ),
                                            const SizedBox(width: 15),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await ref
                                                    .read(lumbiniProvider)
                                                    .removeFPTP(
                                                      postId: dat.id,
                                                      imageId: dat.imageId,
                                                      partyImageId:
                                                          dat.partyImageId,
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
                    if (province == "Karnali")
                      karnaliFPTPStream.when(
                        data: (data) {
                          return Container(
                            decoration: const BoxDecoration(
                              color: secondaryColor,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                  DataColumn(
                                    label: Text(
                                      'Bar Color',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Actions',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
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
                                        onTap: () {},
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
                                                    EditProvincialFPTPPage(
                                                        dat, "Karnali"));
                                              },
                                            ),
                                            const SizedBox(width: 15),
                                            ElevatedButton(
                                              onPressed: () async {
                                                await ref
                                                    .read(karnaliProvider)
                                                    .removeFPTP(
                                                      postId: dat.id,
                                                      imageId: dat.imageId,
                                                      partyImageId:
                                                          dat.partyImageId,
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
