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
                          province + " FPTP Candidates",
                          style: GoogleFonts.roboto(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    if (province == "Province 1")
                    province1FPTPStream.when(
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
                                    'Profile Picture',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Candidate Name',
                                    style:
                                    TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                DataColumn(
                                  label: Text(
                                    'Party Name',
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
                                      Text(dat.candidateName),
                                      onTap: () {
                                        print(dat.candidateName);
                                      },
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
                                              Get.to(() =>
                                                  EditProvincialFPTPPage(
                                                      dat, "Province 1"));
                                            },
                                          ),
                                          SizedBox(width: 15),
                                          ElevatedButton(
                                            child: Text('Delete'),
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
                      bagmatiFPTPStream.when(
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
                                      'Profile Picture',
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Candidate Name',
                                      style:
                                      TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  DataColumn(
                                    label: Text(
                                      'Party Name',
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
                                        Text(dat.candidateName),
                                        onTap: () {
                                          print(dat.candidateName);
                                        },
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
                                                Get.to(() =>
                                                    EditProvincialFPTPPage(
                                                        dat, "Bagmati"));
                                              },
                                            ),
                                            SizedBox(width: 15),
                                            ElevatedButton(
                                              child: Text('Delete'),
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
                        madheshFPTPStream.when(
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
                                        'Profile Picture',
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Candidate Name',
                                        style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    DataColumn(
                                      label: Text(
                                        'Party Name',
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
                                          Text(dat.candidateName),
                                          onTap: () {
                                            print(dat.candidateName);
                                          },
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
                                                  Get.to(() =>
                                                      EditProvincialFPTPPage(
                                                          dat, "Madhesh"));
                                                },
                                              ),
                                              SizedBox(width: 15),
                                              ElevatedButton(
                                                child: Text('Delete'),
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
                          gandakiFPTPStream.when(
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
                                          'Profile Picture',
                                          style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Candidate Name',
                                          style:
                                          TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      DataColumn(
                                        label: Text(
                                          'Party Name',
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
                                            Text(dat.candidateName),
                                            onTap: () {
                                              print(dat.candidateName);
                                            },
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
                                                    Get.to(() =>
                                                        EditProvincialFPTPPage(
                                                            dat, "Gandaki"));
                                                  },
                                                ),
                                                SizedBox(width: 15),
                                                ElevatedButton(
                                                  child: Text('Delete'),
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
                            sudurpaschimFPTPStream.when(
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
                                            'Profile Picture',
                                            style:
                                            TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Candidate Name',
                                            style:
                                            TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        DataColumn(
                                          label: Text(
                                            'Party Name',
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
                                              Text(dat.candidateName),
                                              onTap: () {
                                                print(dat.candidateName);
                                              },
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
                                                      Get.to(() =>
                                                          EditProvincialFPTPPage(
                                                              dat, "Sudurpaschim"));
                                                    },
                                                  ),
                                                  SizedBox(width: 15),
                                                  ElevatedButton(
                                                    child: Text('Delete'),
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
                              lumbiniFPTPStream.when(
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
                                              'Profile Picture',
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Candidate Name',
                                              style:
                                              TextStyle(fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          DataColumn(
                                            label: Text(
                                              'Party Name',
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
                                                Text(dat.candidateName),
                                                onTap: () {
                                                  print(dat.candidateName);
                                                },
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
                                                        Get.to(() =>
                                                            EditProvincialFPTPPage(
                                                                dat, "Lumbini"));
                                                      },
                                                    ),
                                                    SizedBox(width: 15),
                                                    ElevatedButton(
                                                      child: Text('Delete'),
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
                                karnaliFPTPStream.when(
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
                                                'Profile Picture',
                                                style:
                                                TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Candidate Name',
                                                style:
                                                TextStyle(fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            DataColumn(
                                              label: Text(
                                                'Party Name',
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
                                                  Text(dat.candidateName),
                                                  onTap: () {
                                                    print(dat.candidateName);
                                                  },
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
                                                          Get.to(() =>
                                                              EditProvincialFPTPPage(
                                                                  dat, "Karnali"));
                                                        },
                                                      ),
                                                      SizedBox(width: 15),
                                                      ElevatedButton(
                                                        child: Text('Delete'),
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
